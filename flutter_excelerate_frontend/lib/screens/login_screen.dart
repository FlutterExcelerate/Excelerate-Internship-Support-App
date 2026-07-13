import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';
import 'home_dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
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
                child: isWide
                    ? Row(
                        children: [
                          Expanded(child: _BrandPanel(isWide: isWide)),
                          const SizedBox(width: 28),
                          const Expanded(child: _LoginActions()),
                        ],
                      )
                    : const Column(
                        children: [
                          Spacer(),
                          _BrandPanel(isWide: false),
                          SizedBox(height: 28),
                          _LoginActions(),
                          Spacer(),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          width: isWide ? 120 : 100,
          height: isWide ? 120 : 100,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Image.asset('assets/images/learnify.png', fit: BoxFit.cover),
        ),
        const SizedBox(height: 24),
        Text('Learnify', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 10),
        Text(
          'Personalized learning, wellbeing check-ins, and deadlines in one calm workspace.',
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: LearnifyColors.muted),
        ),
      ],
    );
  }
}

class _LoginActions extends StatelessWidget {
  const _LoginActions();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Welcome back', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Choose how you want to continue your session.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _enterApp(context),
              icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
              label: const Text('Continue with Google'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _enterApp(context),
              icon: const Icon(Icons.person_outline_rounded),
              label: const Text('Continue as Guest'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _enterApp(context),
              icon: const Icon(Icons.admin_panel_settings_outlined),
              label: const Text('Admin Login'),
            ),
          ),
          const SizedBox(height: 24),
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
      MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
    );
  }
}
