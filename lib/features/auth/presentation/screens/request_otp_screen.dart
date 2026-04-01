import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_shell.dart';

class RequestOtpScreen extends ConsumerStatefulWidget {
  const RequestOtpScreen({super.key});

  @override
  ConsumerState<RequestOtpScreen> createState() => _RequestOtpScreenState();
}

class _RequestOtpScreenState extends ConsumerState<RequestOtpScreen> {
  final TextEditingController _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _requestOtp() async {
    final ok = await ref
        .read(authProvider.notifier)
        .requestOtp(_identifierController.text);

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

    context.push('/auth/verify-otp');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final state = ref.watch(authProvider);

    return AuthShell(
      title: loc.get('auth_request_otp_title'),
      subtitle: loc.get('auth_request_otp_subtitle'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthInputField(
            controller: _identifierController,
            label: loc.get('auth_identifier_label'),
            hint: loc.get('auth_identifier_hint'),
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          Text(
            loc.get('auth_demo_note'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _requestOtp,
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
                  : Text(loc.get('auth_send_otp')),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => context.push('/auth/forgot-password'),
              child: Text(loc.get('auth_forgot_password')),
            ),
          ),
        ],
      ),
    );
  }
}
