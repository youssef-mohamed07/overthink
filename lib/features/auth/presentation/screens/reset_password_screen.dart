import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_shell.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _resetPassword() async {
    final ok = await ref
        .read(authProvider.notifier)
        .resetPassword(
          otp: _otpController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

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

    _showMessage(loc.get('auth_password_reset_success'));
    context.go('/auth/request-otp');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final state = ref.watch(authProvider);

    return AuthShell(
      title: loc.get('auth_reset_password_title'),
      subtitle: loc.get('auth_reset_password_subtitle'),
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
          const SizedBox(height: 16),
          AuthInputField(
            controller: _passwordController,
            label: loc.get('auth_password_label'),
            hint: loc.get('auth_password_hint'),
            icon: Icons.password_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            controller: _confirmPasswordController,
            label: loc.get('auth_confirm_password_label'),
            hint: loc.get('auth_confirm_password_hint'),
            icon: Icons.password_outlined,
            obscureText: true,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _resetPassword,
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
                  : Text(loc.get('auth_reset_password_button')),
            ),
          ),
        ],
      ),
    );
  }
}
