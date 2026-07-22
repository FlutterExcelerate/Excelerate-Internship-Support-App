import 'package:flutter/material.dart';
import 'theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Subtle radial gradient background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 32),
                      // Logo
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // App name
                      Text('Learnify', style: textTheme.headlineLarge),
                      const SizedBox(height: 12),
                      // Tagline
                      Text(
                        'Personalized learning, wellbeing check-ins, and deadlines in one calm workspace.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Welcome card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text('Welcome back', style: textTheme.headlineMedium),
                            const SizedBox(height: 8),
                            Text(
                              'Choose how you want to continue your session.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMd.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Continue with Google
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.login_rounded, color: Colors.white),
                                  label: Text(
                                    'Continue with Google',
                                    style: AppTextStyles.labelMd.copyWith(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Continue as Guest
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                                  );
                                },
                                icon: Icon(Icons.person_outline_rounded, color: colorScheme.secondary),
                                label: Text(
                                  'Continue as Guest',
                                  style: AppTextStyles.labelMd.copyWith(color: colorScheme.secondary),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: colorScheme.secondary, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Switch login link
                      TextButton(
                        onPressed: () {
                          // TODO: navigate to Mentor/Admin login
                        },
                        child: Text(
                          'Are you a Mentor or Admin? Switch login',
                          style: AppTextStyles.labelMd.copyWith(
                            color: colorScheme.tertiary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Footer links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Terms of Service',
                              style: AppTextStyles.caption.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Text('•', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Privacy Policy',
                              style: AppTextStyles.caption.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}