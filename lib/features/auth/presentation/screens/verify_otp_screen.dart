import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_shell.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _verifyOtp() async {
    final ok = await ref
        .read(authProvider.notifier)
        .verifyOtp(_otpController.text);

    if (!mounted) {
      return;
    }

    final loc = AppLocalizations.of(context);
    final state = ref.read(authProvider);

    if (!ok) {
      final errorKey = state.errorMessage;
      _showMessage(
        errorKey != null ? loc.get(errorKey) : loc.get('auth_generic_error'),
      );
      return;
    }

    context.push('/auth/set-password');
  }

  Future<void> _resendOtp() async {
    final state = ref.read(authProvider);
    final target = state.identifier;
    final loc = AppLocalizations.of(context);

    if (target == null || target.isEmpty) {
      _showMessage(loc.get('auth_identifier_missing'));
      return;
    }

    final ok = await ref.read(authProvider.notifier).requestOtp(target);
    if (!mounted) {
      return;
    }

    if (ok) {
      _showMessage(loc.get('auth_otp_sent_again'));
      return;
    }

    final updatedState = ref.read(authProvider);
    final errorKey = updatedState.errorMessage;
    _showMessage(
      errorKey != null ? loc.get(errorKey) : loc.get('auth_generic_error'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final state = ref.watch(authProvider);

    return AuthShell(
      title: loc.get('auth_verify_otp_title'),
      subtitle:
          '${loc.get('auth_verify_otp_subtitle')} ${state.identifier ?? '-'}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthInputField(
            controller: _otpController,
            label: loc.get('auth_otp_label'),
            hint: loc.get('auth_otp_hint'),
            icon: Icons.lock_clock_outlined,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.get('auth_verify_otp_button')),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: state.isLoading ? null : _resendOtp,
              child: Text(loc.get('auth_resend_otp')),
            ),
          ),
        ],
      ),
    );
  }
}
