import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/learnify_widgets.dart';

class AdminSettingsTab extends StatelessWidget {
  const AdminSettingsTab({super.key, required this.adminEmails});

  final Set<String> adminEmails;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('admin-settings'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBadge(
                icon: Icons.verified_user_outlined,
                color: LearnifyColors.secondary,
              ),
              const SizedBox(height: 14),
              Text(
                'Admin Access',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Admin routing is limited to signed-in Google accounts whose email is passed with --dart-define=ADMIN_EMAILS=email1@example.com,email2@example.com.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              if (adminEmails.isEmpty)
                const Pill(
                  label: 'No admin emails configured',
                  icon: Icons.warning_amber_rounded,
                  color: LearnifyColors.warning,
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: adminEmails
                      .map(
                        (email) => Pill(
                          label: email,
                          icon: Icons.admin_panel_settings_outlined,
                          color: LearnifyColors.success,
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBadge(
                icon: Icons.lock_outline_rounded,
                color: LearnifyColors.primary,
              ),
              const SizedBox(height: 14),
              Text(
                'Security Notes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'This protects navigation in the app. Mirror the same admin role in Firebase custom claims or Firestore security rules before storing real admin data.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
