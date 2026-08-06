import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/admin/screens/admin_feedback_screen.dart';
import 'package:flutter_excelerate_frontend/firebase/models/feedback_model.dart';
import 'package:flutter_excelerate_frontend/firebase/models/notification_model.dart';
import 'package:flutter_excelerate_frontend/firebase/models/program_model.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/student/screens/program_details_screen.dart';
import '../widgets/admin_widgets.dart';

class AdminContentTab extends StatefulWidget {
  const AdminContentTab({
    super.key,
    required this.programs,
    required this.notifications,
    required this.onAddProgram,
    required this.onAddModule,
    required this.onAddNotification,
    required this.onDeleteProgram,
    this.feedback = const [],
  });

  final List<ProgramModel> programs;
  final List<NotificationModel> notifications;
  final List<FeedbackModel> feedback;

  final VoidCallback onAddProgram;
  final ValueChanged<ProgramModel> onAddModule;
  final VoidCallback onAddNotification;
  final ValueChanged<ProgramModel> onDeleteProgram;

  @override
  State<AdminContentTab> createState() => _AdminContentTabState();
}

class _AdminContentTabState extends State<AdminContentTab> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    final feedbackCount = widget.feedback.length;

    return ListView(
      key: const ValueKey('admin-content'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
      children: [
        _UsersTopNav(
          selectedIndex: _selectedView,
          feedbackCount: feedbackCount,
          onChanged: (index) {
            setState(() {
              _selectedView = index;
            });
          },
        ),
        if (_selectedView == 0) ...[
          const SizedBox(height: 16),
          AdminSectionTitle(
            title: 'Course Summary',
            action: 'Add',
            onTap: widget.onAddProgram,
          ),
          const SizedBox(height: 10),
          ...widget.programs.map(
            (program) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminProgramCard(
                program: program,
                onAddModule: widget.onAddModule,
                onDeleteProgram: widget.onDeleteProgram,
                onKnowMore: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProgramDetailsScreen(program: program),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          AdminSectionTitle(
            title: 'Learnify Notifications',
            action: 'Publish',
            onTap: widget.onAddNotification,
          ),
          const SizedBox(height: 10),
          ...widget.notifications.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminNotificationCard(notification: item),
            ),
          ),
        ] else ...[
          const SizedBox(height: 16),
          // Feedback view placeholder
          const AdminFeedbackScreen(),
        ],
      ],
    );
  }
}

class _UsersTopNav extends StatelessWidget {
  const _UsersTopNav({
    required this.selectedIndex,
    required this.feedbackCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int? feedbackCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF111827).withValues(alpha: 0.72)
            : Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? LearnifyColors.borderDark
              : LearnifyColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          _NavItem(
            label: 'Content',
            icon: Icons.groups_outlined,
            isSelected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _NavItem(
            label: 'Feedback',
            count: feedbackCount,
            icon: Icons.timeline_rounded,
            isSelected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    this.count,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int? count;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor.withValues(alpha: 0.13)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? selectedColor
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? selectedColor
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              count != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColor.withValues(alpha: 0.18)
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.06,
                              ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$count',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected ? selectedColor : null,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
