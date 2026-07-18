import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';
import 'home_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
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
      crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
                color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.2),
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
            color: isDark ? LearnifyColors.mutedDark : LearnifyColors.mutedLight,
          ),
        ),
      ],
    );
  }
}

class _LoginActions extends StatelessWidget {
  const _LoginActions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Welcome back', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to continue your session.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _enterApp(context),
              icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
              label: const Text('Continue with Google'),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _enterApp(context),
              icon: const Icon(Icons.person_outline_rounded),
              label: const Text('Continue as Guest'),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _enterApp(context),
              icon: const Icon(Icons.admin_panel_settings_outlined),
              label: const Text('Admin Login'),
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

  void _enterApp(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeDashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
