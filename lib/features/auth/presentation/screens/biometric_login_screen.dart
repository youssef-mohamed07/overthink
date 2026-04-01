import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_shell.dart';

class BiometricLoginScreen extends ConsumerStatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  ConsumerState<BiometricLoginScreen> createState() =>
      _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends ConsumerState<BiometricLoginScreen> {
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loc = AppLocalizations.of(context);
      _authenticate(loc.get('auth_biometric_reason'));
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _authenticate([String? reason]) async {
    if (_isAuthenticating) {
      return;
    }

    setState(() {
      _isAuthenticating = true;
    });

    final ok = await ref
        .read(authProvider.notifier)
        .authenticateWithBiometrics(reason: reason);

    if (!mounted) {
      return;
    }

    setState(() {
      _isAuthenticating = false;
    });

    final loc = AppLocalizations.of(context);

    if (ok) {
      context.go('/');
      return;
    }

    final state = ref.read(authProvider);
    final errorKey = state.errorMessage;
    _showMessage(
      errorKey != null ? loc.get(errorKey) : loc.get('auth_generic_error'),
    );
  }

  Future<void> _useOtpInstead() async {
    await ref.read(authProvider.notifier).logout();

    if (!mounted) {
      return;
    }

    context.go('/auth/request-otp');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return AuthShell(
      title: loc.get('auth_biometric_title'),
      subtitle: loc.get('auth_biometric_subtitle'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          const Icon(Icons.fingerprint_rounded, size: 92),
          const SizedBox(height: 20),
          Text(
            loc.get('auth_biometric_helper'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 26),
          ElevatedButton(
            onPressed: _isAuthenticating
                ? null
                : () => _authenticate(loc.get('auth_biometric_reason')),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isAuthenticating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(loc.get('auth_biometric_login_button')),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _isAuthenticating ? null : _useOtpInstead,
            child: Text(loc.get('auth_use_otp_instead')),
          ),
        ],
      ),
    );
  }
}
