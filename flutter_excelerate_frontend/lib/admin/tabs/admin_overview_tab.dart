import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/learnify_models.dart';
import '../../theme/app_theme.dart';
import '../models/admin_user_activity.dart';
import '../widgets/admin_widgets.dart';

class AdminOverviewTab extends StatelessWidget {
  const AdminOverviewTab({
    super.key,
    required this.programs,
    required this.notifications,
    required this.activities,
    required this.onAddProgram,
    required this.onAddNotification,
    required this.onOpenContent,
    required this.onOpenUsers,
  });

  final List<Program> programs;
  final List<LearnifyNotification> notifications;
  final List<AdminUserActivity> activities;
  final VoidCallback onAddProgram;
  final VoidCallback onAddNotification;
  final VoidCallback onOpenContent;
  final VoidCallback onOpenUsers;

  @override
  Widget build(BuildContext context) {
    final completedModules = programs.fold<int>(
      0,
      (total, program) =>
          total + program.modules.where((module) => module.isComplete).length,
    );
    final moduleCount = programs.fold<int>(
      0,
      (total, program) => total + program.modules.length,
    );
    final reviewCount = activities
        .where((item) => item.status.toLowerCase().contains('review'))
        .length;

    return ListView(
      key: const ValueKey('admin-overview'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
      children: [
        AdminHero(
          email: FirebaseAuth.instance.currentUser?.email ?? 'Admin user',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 620;
            final cards = [
              AdminMetricCard(
                title: 'Programs',
                value: '${programs.length}',
                subtitle: '$moduleCount modules managed',
                icon: Icons.school_outlined,
                color: LearnifyColors.primary,
              ),
              AdminMetricCard(
                title: 'Completion',
                value: '$completedModules/$moduleCount',
                subtitle: 'Modules marked complete',
                icon: Icons.check_circle_outline_rounded,
                color: LearnifyColors.success,
              ),
              AdminMetricCard(
                title: 'Notifications',
                value: '${notifications.length}',
                subtitle: 'Learnify messages live',
                icon: Icons.notifications_active_outlined,
                color: LearnifyColors.info,
              ),
              AdminMetricCard(
                title: 'User Alerts',
                value: '$reviewCount',
                subtitle: 'Activities need attention',
                icon: Icons.manage_accounts_outlined,
                color: LearnifyColors.warning,
              ),
            ];

            return GridView.count(
              crossAxisCount: isWide ? 2 : 1,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: isWide ? 2.15 : 2.75,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: cards,
            );
          },
        ),
        const SizedBox(height: 18),
        const AdminSectionTitle(title: 'Admin Actions'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AdminActionButton(
              label: 'Add Program',
              icon: Icons.add_box_outlined,
              color: LearnifyColors.primary,
              onTap: onAddProgram,
            ),
            AdminActionButton(
              label: 'Publish Notice',
              icon: Icons.campaign_outlined,
              color: LearnifyColors.info,
              onTap: onAddNotification,
            ),
            AdminActionButton(
              label: 'Manage Content',
              icon: Icons.library_books_outlined,
              color: LearnifyColors.secondary,
              onTap: onOpenContent,
            ),
            AdminActionButton(
              label: 'Review Users',
              icon: Icons.groups_outlined,
              color: LearnifyColors.warning,
              onTap: onOpenUsers,
            ),
          ],
        ),
        const SizedBox(height: 18),
        const AdminSectionTitle(title: 'Latest User Activity'),
        const SizedBox(height: 10),
        ...activities
            .take(3)
            .map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AdminActivityTile(activity: activity),
              ),
            ),
      ],
    );
  }
}
