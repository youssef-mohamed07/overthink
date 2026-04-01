import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_shell.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  ConsumerState<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _completeProfile() async {
    final ok = await ref
        .read(authProvider.notifier)
        .completeProfile(
          fullName: _fullNameController.text,
          userName: _userNameController.text,
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

    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final state = ref.watch(authProvider);

    return AuthShell(
      title: loc.get('auth_setup_profile_title'),
      subtitle: loc.get('auth_setup_profile_subtitle'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthInputField(
            controller: _fullNameController,
            label: loc.get('auth_full_name_label'),
            hint: loc.get('auth_full_name_hint'),
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            controller: _userNameController,
            label: loc.get('auth_username_label'),
            hint: loc.get('auth_username_hint'),
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _completeProfile,
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
                  : Text(loc.get('auth_setup_profile_button')),
            ),
          ),
        ],
      ),
    );
  }
}
