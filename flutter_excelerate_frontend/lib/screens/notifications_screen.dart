import 'package:flutter/material.dart';

import '../models/learnify_models.dart';
import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  static const notifications = [
    LearnifyNotification(
      title: 'New assignment due tomorrow',
      message:
          'Flutter Sprint requires your navigation pattern submission by 9:00 PM tomorrow.',
      category: 'Assignments',
      time: '2h ago',
      icon: Icons.assignment_late_outlined,
      color: LearnifyColors.warning,
      requiresAction: true,
    ),
    LearnifyNotification(
      title: 'Live session announced',
      message:
          'Join the mentor Q&A on building responsive Flutter interfaces this Friday.',
      category: 'Announcements',
      time: 'Today',
      icon: Icons.campaign_outlined,
      color: LearnifyColors.info,
    ),
    LearnifyNotification(
      title: 'Course progress updated',
      message:
          'Your Workspace Mastery progress has been synced to your profile.',
      category: 'Updates',
      time: 'Yesterday',
      icon: Icons.sync_rounded,
      color: LearnifyColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      key: const ValueKey('notifications'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Pill(
              label: 'Announcements',
              icon: Icons.campaign_outlined,
              color: LearnifyColors.info,
            ),
            Pill(
              label: 'Assignments',
              icon: Icons.assignment_outlined,
              color: LearnifyColors.warning,
            ),
            Pill(
              label: 'Updates',
              icon: Icons.sync_rounded,
              color: LearnifyColors.success,
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...notifications.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SectionCard(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NotificationDetailsScreen(notification: item),
                ),
              ),
              child: Row(
                children: [
                  IconBadge(icon: item.icon, color: item.color),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.category,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(color: item.color),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        item.time,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (!showAppBar) {
      return content;
    }

    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('Notifications')),
      child: content,
    );
  }
}

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key, required this.notification});

  final LearnifyNotification notification;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SectionCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBadge(
                  icon: notification.icon,
                  color: notification.color,
                  size: 64,
                ),
                const SizedBox(height: 18),
                Pill(
                  label: notification.category,
                  icon: notification.icon,
                  color: notification.color,
                ),
                const SizedBox(height: 16),
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  notification.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                if (notification.requiresAction) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('View Assignment'),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Mark as Completed'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
