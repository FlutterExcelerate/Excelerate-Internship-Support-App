import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/learnify_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/learnify_widgets.dart';
import '../models/admin_user_activity.dart';

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
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(value, style: theme.textTheme.headlineSmall),
                  ),
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

class AdminFormDialog extends StatelessWidget {
  const AdminFormDialog({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.children,
    required this.onSubmit,
  });

  final String title;
  final String actionLabel;
  final List<Widget> children;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...children.expand((child) => [child, const SizedBox(height: 12)]),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: onSubmit, child: Text(actionLabel)),
      ],
    );
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

  final Program program;
  final ValueChanged<Program> onAddModule;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(icon: Icons.school_outlined, color: program.color),
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
            children: program.modules.isEmpty
                ? [
                    const Pill(
                      label: 'No modules yet',
                      icon: Icons.pending_outlined,
                      color: LearnifyColors.warning,
                    ),
                  ]
                : program.modules
                      .map(
                        (module) => Pill(
                          label: module.title,
                          icon: module.isComplete
                              ? Icons.check_rounded
                              : Icons.menu_book_outlined,
                          color: module.isComplete
                              ? LearnifyColors.success
                              : LearnifyColors.primary,
                        ),
                      )
                      .toList(),
          ),
        ],
      ),
    );
  }
}

class AdminNotificationCard extends StatelessWidget {
  const AdminNotificationCard({super.key, required this.notification});

  final LearnifyNotification notification;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          IconBadge(icon: notification.icon, color: notification.color),
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
                  '${notification.category} - ${notification.time}',
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
