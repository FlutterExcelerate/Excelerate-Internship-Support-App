import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/widgets/learnify_widgets.dart';
import '../theme/app_theme.dart';
import '../firebase/models/notification_model.dart';
import '../firebase/service/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  static IconData iconFromString(String icon) {
    switch (icon) {
      case 'assignment':
      case 'assignment_late':
        return Icons.assignment_outlined;
      case 'campaign':
      case 'announcement':
        return Icons.campaign_outlined;
      case 'sync':
      case 'update':
        return Icons.sync_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = StreamBuilder<List<NotificationModel>>(
      stream: NotificationService.instance.notificationsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final notifications = snapshot.data ?? [];

        return ListView(
          key: const ValueKey('notifications'),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
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
              (notification) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SectionCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationDetailsScreen(
                          notification: notification,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      IconBadge(
                        icon: iconFromString(notification.icon),
                        color: Color(notification.color),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.category,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: Color(notification.color)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              notification.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
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

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final icon = NotificationsScreen.iconFromString(notification.icon);
    final color = Color(notification.color);

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
                IconBadge(icon: icon, color: color, size: 64),
                const SizedBox(height: 18),
                Pill(label: notification.category, icon: icon, color: color),
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
