import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final String? identifier;
  final String? fullName;
  final String? userName;
  final bool otpRequested;
  final bool otpVerified;
  final bool passwordSet;
  final bool profileCompleted;
  final bool biometricEnabled;
  final bool biometricSupported;
  final bool hasFingerprint;
  final bool hasFace;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
    this.identifier,
    this.fullName,
    this.userName,
    this.otpRequested = false,
    this.otpVerified = false,
    this.passwordSet = false,
    this.profileCompleted = false,
    this.biometricEnabled = false,
    this.biometricSupported = false,
    this.hasFingerprint = false,
    this.hasFace = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? identifier,
    bool clearIdentifier = false,
    String? fullName,
    bool clearFullName = false,
    String? userName,
    bool clearUserName = false,
    bool? otpRequested,
    bool? otpVerified,
    bool? passwordSet,
    bool? profileCompleted,
    bool? biometricEnabled,
    bool? biometricSupported,
    bool? hasFingerprint,
    bool? hasFace,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      identifier: clearIdentifier ? null : (identifier ?? this.identifier),
      fullName: clearFullName ? null : (fullName ?? this.fullName),
      userName: clearUserName ? null : (userName ?? this.userName),
      otpRequested: otpRequested ?? this.otpRequested,
      otpVerified: otpVerified ?? this.otpVerified,
      passwordSet: passwordSet ?? this.passwordSet,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricSupported: biometricSupported ?? this.biometricSupported,
      hasFingerprint: hasFingerprint ?? this.hasFingerprint,
      hasFace: hasFace ?? this.hasFace,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  AuthState build() {
    _restoreSession();
    _refreshBiometricStatus();
    return const AuthState();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated =
        prefs.getBool(AppStorageKeys.isAuthenticated) ?? false;
    final biometricEnabled =
        prefs.getBool(AppStorageKeys.biometricEnabled) ?? false;

    if (!ref.mounted) {
      return;
    }

    if (!isAuthenticated) {
      state = state.copyWith(
        isAuthenticated: false,
        biometricEnabled: biometricEnabled,
      );
      return;
    }

    state = state.copyWith(
      isAuthenticated: true,
      fullName: prefs.getString(AppStorageKeys.authDisplayName),
      userName: prefs.getString(AppStorageKeys.authUserName),
      identifier: prefs.getString(AppStorageKeys.authIdentifier),
      otpRequested: true,
      otpVerified: true,
      passwordSet: true,
      profileCompleted: true,
      biometricEnabled: biometricEnabled,
    );
  }

  Future<void> _refreshBiometricStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final biometricEnabled =
        prefs.getBool(AppStorageKeys.biometricEnabled) ?? false;

    var biometricSupported = false;
    var hasFingerprint = false;
    var hasFace = false;

    try {
      final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      final isDeviceSupported = await _localAuthentication.isDeviceSupported();

      biometricSupported = canCheckBiometrics || isDeviceSupported;

      if (biometricSupported) {
        final availableBiometrics = await _localAuthentication
            .getAvailableBiometrics();
        hasFingerprint =
            availableBiometrics.contains(BiometricType.fingerprint) ||
            availableBiometrics.contains(BiometricType.strong) ||
            availableBiometrics.contains(BiometricType.weak);
        hasFace = availableBiometrics.contains(BiometricType.face);
      }
    } on PlatformException {
      biometricSupported = false;
      hasFingerprint = false;
      hasFace = false;
    } catch (_) {
      biometricSupported = false;
      hasFingerprint = false;
      hasFace = false;
    }

    if (!ref.mounted) {
      return;
    }

    state = state.copyWith(
      biometricEnabled: biometricEnabled,
      biometricSupported: biometricSupported,
      hasFingerprint: hasFingerprint,
      hasFace: hasFace,
    );
  }

  Future<void> refreshBiometricStatus() async {
    await _refreshBiometricStatus();
  }

  Future<bool> authenticateWithBiometrics({String? reason}) async {
    await _refreshBiometricStatus();

    if (!(state.biometricSupported &&
        (state.hasFingerprint || state.hasFace))) {
      state = state.copyWith(errorMessage: 'auth_error_biometric_unavailable');
      return false;
    }

    try {
      final authenticated = await _localAuthentication.authenticate(
        localizedReason:
            reason ??
            'Authenticate using your face or fingerprint to continue.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (!authenticated) {
        state = state.copyWith(errorMessage: 'auth_error_biometric_canceled');
        return false;
      }

      state = state.copyWith(clearErrorMessage: true);
      return true;
    } on PlatformException catch (error) {
      state = state.copyWith(errorMessage: _mapBiometricError(error.code));
      return false;
    } catch (_) {
      state = state.copyWith(errorMessage: 'auth_error_biometric_failed');
      return false;
    }
  }

  String _mapBiometricError(String code) {
    switch (code) {
      case auth_error.notAvailable:
        return 'auth_error_biometric_unavailable';
      case auth_error.notEnrolled:
        return 'auth_error_biometric_not_enrolled';
      case auth_error.passcodeNotSet:
        return 'auth_error_biometric_passcode_not_set';
      case auth_error.lockedOut:
      case auth_error.permanentlyLockedOut:
        return 'auth_error_biometric_locked';
      default:
        return 'auth_error_biometric_failed';
    }
  }

  Future<bool> setBiometricEnabled(bool enabled, {String? reason}) async {
    if (enabled) {
      final authenticated = await authenticateWithBiometrics(reason: reason);

      if (!authenticated) {
        return false;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStorageKeys.biometricEnabled, enabled);

    if (!ref.mounted) {
      return false;
    }

    state = state.copyWith(biometricEnabled: enabled, clearErrorMessage: true);
    return true;
  }

  Future<bool> requestOtp(String identifier) async {
    final input = identifier.trim();

    if (input.isEmpty) {
      state = state.copyWith(errorMessage: 'auth_error_identifier_required');
      return false;
    }

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    await Future<void>.delayed(const Duration(milliseconds: 650));

    state = state.copyWith(
      isLoading: false,
      identifier: input,
      otpRequested: true,
      otpVerified: false,
      passwordSet: false,
      profileCompleted: false,
    );

    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    final code = otp.trim();

    if (code.length != 6 || !RegExp(r'^\d+$').hasMatch(code)) {
      state = state.copyWith(errorMessage: 'auth_error_otp_invalid');
      return false;
    }

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    await Future<void>.delayed(const Duration(milliseconds: 600));

    state = state.copyWith(
      isLoading: false,
      otpVerified: true,
      otpRequested: true,
    );

    return true;
  }

  Future<bool> setPassword(String password, String confirmPassword) async {
    final pass = password.trim();
    final confirm = confirmPassword.trim();

    if (pass.length < 8) {
      state = state.copyWith(errorMessage: 'auth_error_password_too_short');
      return false;
    }

    if (pass != confirm) {
      state = state.copyWith(errorMessage: 'auth_error_password_mismatch');
      return false;
    }

    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    await Future<void>.delayed(const Duration(milliseconds: 600));

    state = state.copyWith(isLoading: false, passwordSet: true);

    return true;
  }

  Future<bool> completeProfile({
    required String fullName,
    required String userName,
  }) async {
    final safeName = fullName.trim();
    final safeUserName = userName.trim();

    if (safeName.length < 2) {
      state = state.copyWith(errorMessage: 'auth_error_full_name_invalid');
      return false;
    }

    if (safeUserName.length < 3) {
      state = state.copyWith(errorMessage: 'auth_error_username_invalid');
      return false;
    }

    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStorageKeys.isAuthenticated, true);
    await prefs.setString(AppStorageKeys.authDisplayName, safeName);
    await prefs.setString(AppStorageKeys.authUserName, safeUserName);

    if (state.identifier != null) {
      await prefs.setString(AppStorageKeys.authIdentifier, state.identifier!);
    }

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      fullName: safeName,
      userName: safeUserName,
      profileCompleted: true,
      otpRequested: true,
      otpVerified: true,
      passwordSet: true,
    );

    return true;
  }

  Future<bool> forgotPasswordRequestOtp(String identifier) async {
    return requestOtp(identifier);
  }

  Future<bool> resetPassword({
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    final safeOtp = otp.trim();
    final otpValid = safeOtp.length == 6 && RegExp(r'^\d+$').hasMatch(safeOtp);
    if (!otpValid) {
      state = state.copyWith(errorMessage: 'auth_error_otp_invalid');
      return false;
    }

    if (password.trim().length < 8) {
      state = state.copyWith(errorMessage: 'auth_error_password_too_short');
      return false;
    }

    if (password.trim() != confirmPassword.trim()) {
      state = state.copyWith(errorMessage: 'auth_error_password_mismatch');
      return false;
    }

    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    state = state.copyWith(isLoading: false);
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStorageKeys.isAuthenticated, false);
    await prefs.remove(AppStorageKeys.authDisplayName);
    await prefs.remove(AppStorageKeys.authUserName);
    await prefs.remove(AppStorageKeys.authIdentifier);
    await prefs.remove(AppStorageKeys.biometricEnabled);

    state = const AuthState();
    await _refreshBiometricStatus();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
