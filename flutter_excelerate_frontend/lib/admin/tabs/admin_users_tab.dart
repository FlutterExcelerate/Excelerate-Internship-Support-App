import 'package:flutter/material.dart';

import '../models/admin_user_activity.dart';
import '../widgets/admin_widgets.dart';

class AdminUsersTab extends StatelessWidget {
  const AdminUsersTab({
    super.key,
    required this.activities,
    required this.onAddActivity,
  });

  final List<AdminUserActivity> activities;
  final VoidCallback onAddActivity;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('admin-users'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
      children: [
        AdminSectionTitle(
          title: 'User Activities',
          action: 'Log',
          onTap: onAddActivity,
        ),
        const SizedBox(height: 10),
        ...activities.map(
          (activity) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AdminActivityTile(activity: activity),
          ),
        ),
      ],
    );
  }
}
