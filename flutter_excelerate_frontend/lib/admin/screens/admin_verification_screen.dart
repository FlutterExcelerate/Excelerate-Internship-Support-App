import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/admin/screens/admin_code_dialog.dart';
import 'package:flutter_excelerate_frontend/admin/screens/admin_dashboard_screen.dart';
import 'package:flutter_excelerate_frontend/firebase/service/admin_session_guard.dart';
import 'package:flutter_excelerate_frontend/firebase/service/repository.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/widgets/learnify_widgets.dart';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key, required this.uid});

  final String uid;

  @override
  State<AdminVerificationScreen> createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  bool _isOpeningDialog = false;

  Future<void> _verifyAdmin() async {
    setState(() => _isOpeningDialog = true);

    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AdminCodeDialog(),
    );

    if (!mounted) return;

    if (success == true) {
      AdminSessionGuard.markVerified(widget.uid);
      setState(() => _isOpeningDialog = false);
      return;
    }

    setState(() => _isOpeningDialog = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Admin verification is required.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _signOut() async {
    await AuthRepository.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (AdminSessionGuard.isVerified(widget.uid)) {
      return const AdminDashboardScreen();
    }

    final email = FirebaseAuth.instance.currentUser?.email ?? 'Admin account';
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      child: GradientBlobBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const IconBadge(
                    icon: Icons.admin_panel_settings_outlined,
                    color: LearnifyColors.secondary,
                    size: 64,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Admin Verification Required',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$email has admin access. Enter the admin code before opening admin tools.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _isOpeningDialog ? null : _verifyAdmin,
                    icon: _isOpeningDialog
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.verified_user_outlined),
                    label: Text(
                      _isOpeningDialog ? 'Opening...' : 'Verify Code',
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
