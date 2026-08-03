import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/models/notification_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../student/widgets/learnify_widgets.dart';
import '../models/admin_user_activity.dart';
import '../../firebase/models/program_model.dart';

class AdminHero extends StatelessWidget {
  const AdminHero({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.workspace_premium_outlined,
            color: LearnifyColors.secondary,
            size: 58,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Control Center',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(email, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconBadge(icon: icon, color: color, size: 46),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value, style: theme.textTheme.headlineSmall),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminActionButton extends StatelessWidget {
  const AdminActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon, color: color),
      label: Text(label),
    );
  }
}

class AdminActivityTile extends StatelessWidget {
  const AdminActivityTile({super.key, required this.activity});

  final AdminUserActivity activity;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          IconBadge(icon: Icons.person_search_outlined, color: activity.color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.user,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  activity.action,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Pill(
                  label: activity.status,
                  icon: Icons.circle_outlined,
                  color: activity.color,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(activity.time, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onTap,
  });

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              action!,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

class AdminFormDialog extends StatefulWidget {
  const AdminFormDialog({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.fields,
    required this.onSubmit,
    this.headerWidget,
  });

  final String title;
  final String actionLabel;

  final List<(String label, String initial, int maxLines)> fields;

  final void Function(Map<String, String> values) onSubmit;

  final Widget? headerWidget;

  @override
  State<AdminFormDialog> createState() => _AdminFormDialogState();
}

class _AdminFormDialogState extends State<AdminFormDialog> {
  late final List<TextEditingController> _controllers;
  bool _controllersDisposed = false;

  @override
  void initState() {
    super.initState();
    _controllers = widget.fields
        .map((f) => TextEditingController(text: f.$2))
        .toList();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_controllersDisposed) {
          _controllersDisposed = true;
          for (final c in _controllers) {
            c.dispose();
          }
        }
      });
    });
    super.dispose();
  }

  Map<String, String> get _values => {
    for (var i = 0; i < widget.fields.length; i++)
      widget.fields[i].$1: _controllers[i].text.trim(),
  };

  @override
  Widget build(BuildContext context) {
    return LearnifyDialogShell(
      title: widget.title,
      subtitle: _subtitleForTitle(widget.title),
      icon: _iconForTitle(widget.title),
      color: _colorForTitle(widget.title),
      primaryLabel: widget.actionLabel,
      onPrimaryPressed: () => widget.onSubmit(_values),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.headerWidget != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: widget.headerWidget!,
            ),
            const SizedBox(height: 12),
          ],
          ...List.generate(
            widget.fields.length,
            (i) => LearnifyDialogField(
              controller: _controllers[i],
              label: widget.fields[i].$1,
              icon: _iconForField(widget.fields[i].$1),
              maxLines: widget.fields[i].$3,
              keyboardType: _keyboardForField(widget.fields[i].$1),
            ),
          ),
        ],
      ),
    );
  }

  String? _subtitleForTitle(String title) {
    if (title.contains('Program')) {
      return 'Add the required details students need before enrolling.';
    }
    if (title.contains('Notification')) {
      return 'Publish a clear update for all signed-in learners.';
    }
    if (title.contains('Module')) {
      return 'Create the next learning step inside this program.';
    }
    if (title.contains('User')) {
      return 'Adjust access details carefully.';
    }
    return null;
  }

  IconData _iconForTitle(String title) {
    if (title.contains('Program')) return Icons.school_outlined;
    if (title.contains('Notification')) return Icons.campaign_outlined;
    if (title.contains('Module')) return Icons.playlist_add_rounded;
    if (title.contains('User')) return Icons.manage_accounts_outlined;
    return Icons.edit_note_rounded;
  }

  Color _colorForTitle(String title) {
    if (title.contains('Program')) return LearnifyColors.primary;
    if (title.contains('Notification')) return LearnifyColors.info;
    if (title.contains('Module')) return LearnifyColors.secondary;
    if (title.contains('User')) return LearnifyColors.warning;
    return LearnifyColors.primary;
  }

  IconData _iconForField(String label) {
    final normalized = label.toLowerCase();
    if (normalized.contains('title')) return Icons.title_rounded;
    if (normalized.contains('category')) return Icons.local_offer_outlined;
    if (normalized.contains('duration')) return Icons.schedule_outlined;
    if (normalized.contains('level')) return Icons.trending_up_rounded;
    if (normalized.contains('mentor')) return Icons.person_outline_rounded;
    if (normalized.contains('email')) return Icons.mail_outline_rounded;
    if (normalized.contains('deadline')) return Icons.event_outlined;
    if (normalized.contains('schedule')) return Icons.calendar_month_outlined;
    if (normalized.contains('capacity')) return Icons.event_seat_outlined;
    if (normalized.contains('outcomes')) return Icons.flag_outlined;
    if (normalized.contains('prerequisites')) {
      return Icons.fact_check_outlined;
    }
    if (normalized.contains('description')) return Icons.notes_outlined;
    if (normalized.contains('message')) {
      return Icons.chat_bubble_outline_rounded;
    }
    if (normalized.contains('role')) return Icons.badge_outlined;
    if (normalized.contains('active')) return Icons.toggle_on_outlined;
    if (normalized.contains('department')) return Icons.apartment_outlined;
    if (normalized.contains('access')) {
      return Icons.admin_panel_settings_outlined;
    }
    return Icons.edit_outlined;
  }

  TextInputType? _keyboardForField(String label) {
    final normalized = label.toLowerCase();
    if (normalized.contains('email')) return TextInputType.emailAddress;
    if (normalized.contains('capacity')) return TextInputType.number;
    return null;
  }
}

class AdminTextField extends StatelessWidget {
  const AdminTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class AdminProgramCard extends StatelessWidget {
  const AdminProgramCard({
    super.key,
    required this.program,
    required this.onAddModule,
  });

  final ProgramModel program;
  final ValueChanged<ProgramModel> onAddModule;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(
                icon: Icons.school_outlined,
                color: Color(program.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${program.category} - ${program.duration} - ${program.level}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Add module',
                onPressed: () => onAddModule(program),
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            program.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Pill(
                label: program.isPublished ? 'Published' : 'Draft',
                icon: program.isPublished
                    ? Icons.public_rounded
                    : Icons.drafts_outlined,
                color: program.isPublished
                    ? LearnifyColors.success
                    : LearnifyColors.warning,
              ),
              if (program.mentorName.isNotEmpty)
                Pill(
                  label: program.mentorName,
                  icon: Icons.person_outline_rounded,
                  color: LearnifyColors.info,
                ),
              if (program.capacity > 0)
                Pill(
                  label: '${program.capacity} seats',
                  icon: Icons.event_seat_outlined,
                  color: LearnifyColors.secondary,
                ),
              if (program.applicationDeadline.isNotEmpty)
                Pill(
                  label: 'Due ${program.applicationDeadline}',
                  icon: Icons.event_outlined,
                  color: LearnifyColors.warning,
                ),
              const Pill(
                label: 'Modules in Firestore',
                icon: Icons.cloud_done_outlined,
                color: LearnifyColors.info,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminNotificationCard extends StatelessWidget {
  const AdminNotificationCard({super.key, required this.notification});

  final NotificationModel notification;
  IconData _iconFromString(String icon) {
    switch (icon) {
      case 'assignment':
        return Icons.assignment_outlined;
      case 'campaign':
        return Icons.campaign_outlined;
      case 'sync':
        return Icons.sync_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String timeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} h ago';
    if (difference.inDays == 1) return 'Yesterday';

    return '${difference.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          IconBadge(
            icon: _iconFromString(notification.icon),
            color: Color(notification.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${notification.category} • ${timeAgo(notification.createdAt)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
