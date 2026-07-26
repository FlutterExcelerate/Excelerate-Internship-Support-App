import 'package:flutter/material.dart';

import '../../models/learnify_models.dart';
import '../widgets/admin_widgets.dart';

class AdminContentTab extends StatelessWidget {
  const AdminContentTab({
    super.key,
    required this.programs,
    required this.notifications,
    required this.onAddProgram,
    required this.onAddModule,
    required this.onAddNotification,
  });

  final List<Program> programs;
  final List<LearnifyNotification> notifications;
  final VoidCallback onAddProgram;
  final ValueChanged<Program> onAddModule;
  final VoidCallback onAddNotification;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('admin-content'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
      children: [
        AdminSectionTitle(
          title: 'Course Summary',
          action: 'Add',
          onTap: onAddProgram,
        ),
        const SizedBox(height: 10),
        ...programs.map(
          (program) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AdminProgramCard(program: program, onAddModule: onAddModule),
          ),
        ),
        const SizedBox(height: 6),
        AdminSectionTitle(
          title: 'Learnify Notifications',
          action: 'Publish',
          onTap: onAddNotification,
        ),
        const SizedBox(height: 10),
        ...notifications.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AdminNotificationCard(notification: item),
          ),
        ),
      ],
    );
  }
}
