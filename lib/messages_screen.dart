import 'package:flutter/material.dart';
import 'theme.dart';
import 'bottom_nav.dart';
import 'notification_detail_screen.dart';
import 'programs_screen.dart';
import 'profile_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _navIndex = 2; // Messages tab active
  String _selectedFilter = 'Announcements';

  static const _filters = ['Announcements', 'Assignments', 'Updates'];

  static const _notifications = [
    _NotificationItem(
      category: 'Assignments',
      icon: Icons.assignment_late_rounded,
      title: 'New assignment due tomorrow',
      preview: 'Final Case Study Submission is due tomorrow at 11:59 PM.',
      timestamp: '2h ago',
    ),
    _NotificationItem(
      category: 'Announcements',
      icon: Icons.campaign_rounded,
      title: 'Platform maintenance this weekend',
      preview: 'Learnify will be briefly unavailable on Saturday for upgrades.',
      timestamp: '5h ago',
    ),
    _NotificationItem(
      category: 'Updates',
      icon: Icons.celebration_rounded,
      title: 'New module unlocked',
      preview: 'Module 4: Usability Testing is now available in Advanced UX Design.',
      timestamp: '1d ago',
    ),
    _NotificationItem(
      category: 'Announcements',
      icon: Icons.campaign_rounded,
      title: 'Welcome to the new cohort!',
      preview: 'Say hello to your fellow learners in the community channel.',
      timestamp: '2d ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final filtered = _notifications.where((n) => n.category == _selectedFilter).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text('Messages', style: textTheme.headlineLarge?.copyWith(fontSize: 24)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Refreshed'), duration: Duration(seconds: 1)),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.person_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Filter chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isActive = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isActive ? AppColors.primaryGradient : null,
                        color: isActive ? null : colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                        border: isActive
                            ? null
                            : Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        filter,
                        style: AppTextStyles.labelMd.copyWith(
                          color: isActive ? Colors.white : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Notification list
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No messages in this category yet.',
                        style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _notificationCard(context, filtered[index]),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: LearnifyBottomNav(
          currentIndex: _navIndex,
          onTap: (index) {
            if (index == _navIndex) return;
            if (index == 0) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (index == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProgramsScreen()),
              );
            } else if (index == 3) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            }
          },
        ),
      ),
    );
  }

  Color _categoryColor(BuildContext context, String category) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (category) {
      case 'Assignments':
        return colorScheme.error;
      case 'Announcements':
        return colorScheme.secondary;
      case 'Updates':
      default:
        return colorScheme.primary;
    }
  }

  Widget _notificationCard(BuildContext context, _NotificationItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _categoryColor(context, item.category);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NotificationDetailScreen(
              category: item.category,
              title: item.title,
              description: item.preview,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    item.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  Text(item.timestamp, style: AppTextStyles.caption.copyWith(color: colorScheme.outline)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final String category;
  final IconData icon;
  final String title;
  final String preview;
  final String timestamp;

  const _NotificationItem({
    required this.category,
    required this.icon,
    required this.title,
    required this.preview,
    required this.timestamp,
  });
}