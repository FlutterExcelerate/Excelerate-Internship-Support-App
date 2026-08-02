import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/service/auth_controller.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../theme/app_theme.dart';
import '../../widgets/learnify_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: GradientBlobBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 720;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height - 48,
                ),
                child: IntrinsicHeight(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: isWide
                          ? Row(
                              children: [
                                Expanded(child: _BrandPanel(isWide: isWide)),
                                const SizedBox(width: 32),
                                const Expanded(child: _LoginActions()),
                              ],
                            )
                          : const Column(
                              children: [
                                Spacer(),
                                _BrandPanel(isWide: false),
                                SizedBox(height: 32),
                                _LoginActions(),
                                Spacer(),
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

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          width: isWide ? 112 : 92,
          height: isWide ? 112 : 92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(
                  alpha: isDark ? 0.35 : 0.2,
                ),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 28),
        Text('Learnify', style: theme.textTheme.displaySmall),
        const SizedBox(height: 12),
        Text(
          'Personalized learning, wellbeing check-ins, and deadlines in one calm workspace.',
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark
                ? LearnifyColors.mutedDark
                : LearnifyColors.mutedLight,
          ),
        ),
      ],
    );
  }
}

class _LoginActions extends StatefulWidget {
  const _LoginActions();

  @override
  State<_LoginActions> createState() => _LoginActionsState();
}

class _LoginActionsState extends State<_LoginActions> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _adminBtnController =
      RoundedLoadingButtonController();
  final AuthController _authController = AuthController();

  Future<void> _handleGoogleSignIn() async {
    try {
      final success = await _authController.signInWithGoogle();
      if (success) {
        _btnController.success();
      } else {
        _btnController.error();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google Sign-In was cancelled by user.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        await Future.delayed(const Duration(seconds: 2));
        _btnController.reset();
      }
    } catch (e) {
      _btnController.error();
      if (mounted) {
        final errText = e.toString();
        String userFriendlyMsg = 'Google Sign-In failed: $errText';
        if (errText.contains('10') || errText.contains('sign_in_failed')) {
          userFriendlyMsg =
              'Google Sign-In failed: Developer configuration error (Ensure SHA-1 fingerprint is added in Firebase Console).';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userFriendlyMsg),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      await Future.delayed(const Duration(seconds: 2));
      _btnController.reset();
    }
  }

  Future<void> _handleAdminLogin() async {
    try {
      final credential = await _authController.signInWithGoogleCredential();

      if (credential == null) {
        _adminBtnController.error();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Google Sign-In was cancelled."),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        await Future.delayed(const Duration(seconds: 2));
        _adminBtnController.reset();
        return;
      }

      _adminBtnController.success();
    } catch (e) {
      await _authController.signOut();
      _adminBtnController.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Admin login error: ${e.toString()}"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    await Future.delayed(const Duration(seconds: 2));
    _adminBtnController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Student Portal', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Sign in with your Google account to access your courses and workspace.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          RoundedLoadingButton(
            controller: _btnController,
            onPressed: _handleGoogleSignIn,
            color: theme.colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.g_mobiledata_rounded,
                  size: 28,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Continue with Google',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          RoundedLoadingButton(
            controller: _adminBtnController,
            onPressed: _handleAdminLogin,
            color: theme.colorScheme.secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 22,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text('Continue as Admin', style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 18,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Terms of Service'),
              ),
              TextButton(onPressed: () {}, child: const Text('Privacy Policy')),
            ],
          ),
        ],
      ),
    );
  }
}
