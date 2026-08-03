import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/admin/screens/admin_code_dialog.dart';
import 'package:flutter_excelerate_frontend/admin/screens/admin_dashboard_screen.dart';
import 'package:flutter_excelerate_frontend/firebase/service/admin_session_guard.dart';
import 'package:flutter_excelerate_frontend/firebase/service/repository.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/student/widgets/learnify_widgets.dart';
import 'package:flutter_excelerate_frontend/utils/responsive.dart';

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardPadding = context.responsiveValue(
              mobile: 18.0,
              tablet: 22.0,
              desktop: 24.0,
            );

            return SingleChildScrollView(
              padding: context.screenPadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: context.dialogMaxWidth,
                    ),
                    child: GlassCard(
                      padding: EdgeInsets.all(cardPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IconBadge(
                            icon: Icons.admin_panel_settings_outlined,
                            color: LearnifyColors.secondary,
                            size: context.isCompact ? 52 : 64,
                          ),
                          SizedBox(height: context.isCompact ? 14 : 18),
                          Text(
                            'Admin Verification Required',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$email has admin access. Enter the admin code before opening admin tools.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          SizedBox(height: context.isCompact ? 18 : 24),
                          FilledButton.icon(
                            onPressed: _isOpeningDialog ? null : _verifyAdmin,
                            icon: _isOpeningDialog
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
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
          },
        ),
      ),
    );
  }
}
