import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/models/app_user.dart';
import 'package:flutter_excelerate_frontend/firebase/models/daily_pulse_model.dart';

import '../../theme/app_theme.dart';
import '../../student/widgets/learnify_widgets.dart';

class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({
    super.key,
    required this.users,
    required this.pulses,
    required this.onEditUser,
  });

  final List<AppUser> users;
  final List<DailyPulseModel> pulses;
  final ValueChanged<AppUser> onEditUser;

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    final studentUsers = widget.users
        .where((user) => user.role.toLowerCase() != 'admin')
        .toList();
    final activityItems = _buildActivityItems(studentUsers, widget.pulses);

    return ListView(
      key: const ValueKey('admin-users'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
      children: [
        _UsersTopNav(
          selectedIndex: _selectedView,
          userCount: studentUsers.length,
          activityCount: activityItems.length,
          onChanged: (index) => setState(() => _selectedView = index),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _selectedView == 0
              ? _UsersListView(
                  key: const ValueKey('users-list'),
                  users: studentUsers,
                  onEditUser: widget.onEditUser,
                )
              : _ActivityTimelineView(
                  key: const ValueKey('activity-timeline'),
                  activities: activityItems,
                ),
        ),
      ],
    );
  }

  List<_ActivityItem> _buildActivityItems(
    List<AppUser> users,
    List<DailyPulseModel> pulses,
  ) {
    final usersById = {for (final user in users) user.uid: user};
    final items = <_ActivityItem>[];

    for (final user in users) {
      if (user.createdAt != null) {
        items.add(
          _ActivityItem(
            title: _displayName(user),
            detail: 'Joined Learnify workspace',
            status: user.isActive ? 'Active' : 'Inactive',
            time: _timeAgo(user.createdAt),
            sortAt: user.createdAt!,
            color: user.isActive
                ? LearnifyColors.success
                : LearnifyColors.warning,
            icon: Icons.person_add_alt_1_outlined,
          ),
        );
      }

      if (user.lastLogin != null &&
          !_isSameMinute(user.createdAt, user.lastLogin)) {
        items.add(
          _ActivityItem(
            title: _displayName(user),
            detail: 'Signed in to Learnify',
            status: user.isActive ? 'Active' : 'Inactive',
            time: _timeAgo(user.lastLogin),
            sortAt: user.lastLogin!,
            color: user.isActive
                ? LearnifyColors.success
                : LearnifyColors.warning,
            icon: Icons.login_rounded,
          ),
        );
      }
    }

    for (final pulse in pulses) {
      final user = usersById[pulse.userId];
      if (user == null) continue;

      final details = [
        'Submitted Daily Pulse: ${pulse.moodLabel}',
        if (pulse.tags.isNotEmpty) pulse.tags.join(', '),
      ].join(' • ');

      items.add(
        _ActivityItem(
          title: _displayName(user),
          detail: details,
          status: pulse.moodLabel,
          time: _timeAgo(pulse.createdAt.toDate()),
          sortAt: pulse.createdAt.toDate(),
          color: _pulseColor(pulse.mood),
          icon: Icons.favorite_outline_rounded,
        ),
      );
    }

    items.sort((a, b) => b.sortAt.compareTo(a.sortAt));
    return items;
  }

  bool _isSameMinute(DateTime? first, DateTime? second) {
    if (first == null || second == null) return false;

    return first.difference(second).abs().inMinutes < 1;
  }

  String _displayName(AppUser user) {
    return user.name.isEmpty ? user.email : user.name;
  }

  Color _pulseColor(int mood) {
    if (mood <= 1) return LearnifyColors.warning;
    if (mood == 2) return LearnifyColors.wellness;
    if (mood == 3) return LearnifyColors.info;
    return LearnifyColors.success;
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return 'Recently';

    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    return '${difference.inDays} days ago';
  }
}

class _UsersTopNav extends StatelessWidget {
  const _UsersTopNav({
    required this.selectedIndex,
    required this.userCount,
    required this.activityCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int userCount;
  final int activityCount;
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
            label: 'Users',
            count: userCount,
            icon: Icons.groups_outlined,
            isSelected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _NavItem(
            label: 'User Activity',
            count: activityCount,
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
    required this.count,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withValues(alpha: 0.18)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? selectedColor : null,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsersListView extends StatelessWidget {
  const _UsersListView({
    super.key,
    required this.users,
    required this.onEditUser,
  });

  final List<AppUser> users;
  final ValueChanged<AppUser> onEditUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Users',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Pill(
              label: 'Students only',
              icon: Icons.school_outlined,
              color: LearnifyColors.primary,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (users.isEmpty)
          SectionCard(
            child: Text(
              'No student users found yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ...users.map(
          (user) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AdminUserCard(user: user, onTap: () => onEditUser(user)),
          ),
        ),
      ],
    );
  }
}

class _ActivityTimelineView extends StatelessWidget {
  const _ActivityTimelineView({super.key, required this.activities});

  final List<_ActivityItem> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'User Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Pill(
              label: 'Live',
              icon: Icons.bolt_outlined,
              color: LearnifyColors.success,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (activities.isEmpty)
          SectionCard(
            child: Text(
              'No user activity yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ...activities.map(
          (activity) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ActivityTimelineCard(activity: activity),
          ),
        ),
      ],
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.title,
    required this.detail,
    required this.status,
    required this.time,
    required this.sortAt,
    required this.color,
    required this.icon,
  });

  final String title;
  final String detail;
  final String status;
  final String time;
  final DateTime sortAt;
  final Color color;
  final IconData icon;
}

class _ActivityTimelineCard extends StatelessWidget {
  const _ActivityTimelineCard({required this.activity});

  final _ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              IconBadge(icon: activity.icon, color: activity.color),
              Container(
                width: 2,
                height: 34,
                margin: const EdgeInsets.only(top: 8),
                color: activity.color.withValues(alpha: 0.18),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(activity.time, style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 4),
                Text(activity.detail, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Pill(
                  label: activity.status,
                  icon: Icons.circle_outlined,
                  color: activity.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminUserCard extends StatelessWidget {
  const _AdminUserCard({required this.user, required this.onTap});

  final AppUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.role == 'admin';

    return SectionCard(
      onTap: onTap,
      child: Row(
        children: [
          IconBadge(
            icon: isAdmin
                ? Icons.admin_panel_settings_outlined
                : Icons.person_outline_rounded,
            color: isAdmin ? LearnifyColors.secondary : LearnifyColors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isEmpty ? user.email : user.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Pill(
                      label: user.role,
                      icon: Icons.badge_outlined,
                      color: isAdmin
                          ? LearnifyColors.secondary
                          : LearnifyColors.primary,
                    ),
                    Pill(
                      label: user.isActive ? 'Active' : 'Inactive',
                      icon: user.isActive
                          ? Icons.check_circle_outline_rounded
                          : Icons.block_outlined,
                      color: user.isActive
                          ? LearnifyColors.success
                          : LearnifyColors.warning,
                    ),
                    if (user.cohort.isNotEmpty)
                      Pill(
                        label: user.cohort,
                        icon: Icons.groups_outlined,
                        color: LearnifyColors.info,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined),
        ],
      ),
    );
  }
}
