import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../firebase/auth/admin_access.dart';
import '../../firebase/service/repository.dart';
import '../../models/learnify_models.dart';
import '../../screens/notifications_screen.dart';
import '../../screens/programs_screen.dart';
import '../../theme/app_theme.dart';
import '../../widgets/learnify_widgets.dart';
import '../models/admin_user_activity.dart';
import '../tabs/admin_content_tab.dart';
import '../tabs/admin_overview_tab.dart';
import '../tabs/admin_settings_tab.dart';
import '../tabs/admin_users_tab.dart';
import '../widgets/admin_widgets.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  late final List<Program> _programs = List.of(ProgramsScreen.programs);
  late final List<LearnifyNotification> _notifications = List.of(
    NotificationsScreen.notifications,
  );
  final List<AdminUserActivity> _activities = [
    const AdminUserActivity(
      user: 'Aarav Sharma',
      action: 'Completed Deadline Systems module',
      status: 'Healthy',
      time: '12 min ago',
      color: LearnifyColors.success,
    ),
    const AdminUserActivity(
      user: 'Maya Singh',
      action: 'Missed Flutter Sprint submission',
      status: 'Needs review',
      time: '1h ago',
      color: LearnifyColors.warning,
    ),
    const AdminUserActivity(
      user: 'Rohan Mehta',
      action: 'Joined Internship Readiness',
      status: 'Active',
      time: 'Today',
      color: LearnifyColors.info,
    ),
  ];

  static const _navDestinations = [
    GlassNavDestination(
      selectedIcon: Icons.dashboard_rounded,
      icon: Icons.dashboard_outlined,
      label: 'Overview',
    ),
    GlassNavDestination(
      selectedIcon: Icons.library_books_rounded,
      icon: Icons.library_books_outlined,
      label: 'Content',
    ),
    GlassNavDestination(
      selectedIcon: Icons.groups_rounded,
      icon: Icons.groups_outlined,
      label: 'Users',
    ),
    GlassNavDestination(
      selectedIcon: Icons.shield_rounded,
      icon: Icons.shield_outlined,
      label: 'Security',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminOverviewTab(
        programs: _programs,
        notifications: _notifications,
        activities: _activities,
        onAddProgram: _showProgramDialog,
        onAddNotification: _showNotificationDialog,
        onOpenContent: () => _selectTab(1),
        onOpenUsers: () => _selectTab(2),
      ),
      AdminContentTab(
        programs: _programs,
        notifications: _notifications,
        onAddProgram: _showProgramDialog,
        onAddModule: _showModuleDialog,
        onAddNotification: _showNotificationDialog,
      ),
      AdminUsersTab(
        activities: _activities,
        onAddActivity: _showActivityDialog,
      ),
      AdminSettingsTab(adminEmails: AdminAccess.allowedEmails),
    ];

    return ResponsiveScaffold(
      appBar: AppBar(
        leadingWidth: 0,
        title: Row(
          children: [
            const Icon(
              Icons.admin_panel_settings_rounded,
              color: LearnifyColors.secondary,
            ),
            const SizedBox(width: 8),
            Text(_titleForIndex(_selectedIndex)),
          ],
        ),
        actions: [
          const ThemeToggleButton(),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => AuthRepository.instance.signOut(),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: GradientBlobBackground(
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 350),
                reverse: _selectedIndex < _previousIndex,
                transitionBuilder:
                    (child, primaryAnimation, secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        fillColor: Colors.transparent,
                        child: child,
                      );
                    },
                child: pages[_selectedIndex],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: FloatingGlassNavBar(
              selectedIndex: _selectedIndex,
              destinations: _navDestinations,
              onDestinationSelected: _selectTab,
            ),
          ),
        ],
      ),
    );
  }

  String _titleForIndex(int index) => switch (index) {
    1 => 'Content',
    2 => 'Users',
    3 => 'Security',
    _ => 'Admin Dashboard',
  };

  void _selectTab(int index) {
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  Future<void> _showProgramDialog() async {
    final titleController = TextEditingController();
    final categoryController = TextEditingController(text: 'Course');
    final durationController = TextEditingController(text: '4 weeks');
    final levelController = TextEditingController(text: 'Beginner');
    final descriptionController = TextEditingController();

    try {
      final added = await showDialog<Program>(
        context: context,
        builder: (context) => AdminFormDialog(
          title: 'Add Program',
          actionLabel: 'Add Program',
          children: [
            AdminTextField(controller: titleController, label: 'Title'),
            AdminTextField(controller: categoryController, label: 'Category'),
            AdminTextField(controller: durationController, label: 'Duration'),
            AdminTextField(controller: levelController, label: 'Level'),
            AdminTextField(
              controller: descriptionController,
              label: 'Description',
              maxLines: 3,
            ),
          ],
          onSubmit: () {
            final title = titleController.text.trim();
            final description = descriptionController.text.trim();

            if (title.isEmpty || description.isEmpty) {
              _showSnack('Program title and description are required.');
              return;
            }

            Navigator.of(context).pop(
              Program(
                title: title,
                category: categoryController.text.trim().isEmpty
                    ? 'Course'
                    : categoryController.text.trim(),
                description: description,
                duration: durationController.text.trim().isEmpty
                    ? '4 weeks'
                    : durationController.text.trim(),
                level: levelController.text.trim().isEmpty
                    ? 'Beginner'
                    : levelController.text.trim(),
                progress: 0,
                color: _colorForIndex(_programs.length),
                modules: const [],
              ),
            );
          },
        ),
      );

      if (!mounted) {
        return;
      }

      if (added != null) {
        setState(() => _programs.insert(0, added));
        _showSnack('${added.title} was added.');
      }
    } finally {
      titleController.dispose();
      categoryController.dispose();
      durationController.dispose();
      levelController.dispose();
      descriptionController.dispose();
    }
  }

  Future<void> _showModuleDialog(Program program) async {
    final titleController = TextEditingController();
    final summaryController = TextEditingController();
    final durationController = TextEditingController(text: '30 min');

    try {
      final added = await showDialog<ProgramModule>(
        context: context,
        builder: (context) => AdminFormDialog(
          title: 'Add Module',
          actionLabel: 'Add Module',
          children: [
            Text(program.title, style: Theme.of(context).textTheme.bodyMedium),
            AdminTextField(controller: titleController, label: 'Module title'),
            AdminTextField(
              controller: summaryController,
              label: 'Summary',
              maxLines: 3,
            ),
            AdminTextField(controller: durationController, label: 'Duration'),
          ],
          onSubmit: () {
            final title = titleController.text.trim();
            final summary = summaryController.text.trim();

            if (title.isEmpty || summary.isEmpty) {
              _showSnack('Module title and summary are required.');
              return;
            }

            Navigator.of(context).pop(
              ProgramModule(
                title: title,
                summary: summary,
                duration: durationController.text.trim().isEmpty
                    ? '30 min'
                    : durationController.text.trim(),
                isComplete: false,
              ),
            );
          },
        ),
      );

      if (!mounted) {
        return;
      }

      if (added != null) {
        final index = _programs.indexOf(program);
        final updated = Program(
          title: program.title,
          category: program.category,
          description: program.description,
          duration: program.duration,
          level: program.level,
          progress: program.progress,
          color: program.color,
          modules: [...program.modules, added],
        );

        if (index >= 0) {
          setState(() => _programs[index] = updated);
          _showSnack('${added.title} was added to ${program.title}.');
        }
      }
    } finally {
      titleController.dispose();
      summaryController.dispose();
      durationController.dispose();
    }
  }

  Future<void> _showNotificationDialog() async {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final categoryController = TextEditingController(text: 'Announcements');

    try {
      final added = await showDialog<LearnifyNotification>(
        context: context,
        builder: (context) => AdminFormDialog(
          title: 'Add Notification',
          actionLabel: 'Publish',
          children: [
            AdminTextField(controller: titleController, label: 'Title'),
            AdminTextField(controller: categoryController, label: 'Category'),
            AdminTextField(
              controller: messageController,
              label: 'Message',
              maxLines: 4,
            ),
          ],
          onSubmit: () {
            final title = titleController.text.trim();
            final message = messageController.text.trim();

            if (title.isEmpty || message.isEmpty) {
              _showSnack('Notification title and message are required.');
              return;
            }

            Navigator.of(context).pop(
              LearnifyNotification(
                title: title,
                message: message,
                category: categoryController.text.trim().isEmpty
                    ? 'Announcements'
                    : categoryController.text.trim(),
                time: 'Just now',
                icon: Icons.campaign_outlined,
                color: LearnifyColors.info,
              ),
            );
          },
        ),
      );

      if (!mounted) {
        return;
      }

      if (added != null) {
        setState(() => _notifications.insert(0, added));
        _showSnack('${added.title} was published.');
      }
    } finally {
      titleController.dispose();
      messageController.dispose();
      categoryController.dispose();
    }
  }

  Future<void> _showActivityDialog() async {
    final userController = TextEditingController();
    final actionController = TextEditingController();
    final statusController = TextEditingController(text: 'Needs review');

    try {
      final added = await showDialog<AdminUserActivity>(
        context: context,
        builder: (context) => AdminFormDialog(
          title: 'Log User Activity',
          actionLabel: 'Log Activity',
          children: [
            AdminTextField(controller: userController, label: 'User name'),
            AdminTextField(
              controller: actionController,
              label: 'Activity',
              maxLines: 3,
            ),
            AdminTextField(controller: statusController, label: 'Status'),
          ],
          onSubmit: () {
            final user = userController.text.trim();
            final action = actionController.text.trim();

            if (user.isEmpty || action.isEmpty) {
              _showSnack('User and activity are required.');
              return;
            }

            Navigator.of(context).pop(
              AdminUserActivity(
                user: user,
                action: action,
                status: statusController.text.trim().isEmpty
                    ? 'Needs review'
                    : statusController.text.trim(),
                time: 'Just now',
                color: LearnifyColors.warning,
              ),
            );
          },
        ),
      );

      if (!mounted) {
        return;
      }

      if (added != null) {
        setState(() => _activities.insert(0, added));
        _showSnack('Activity was logged for ${added.user}.');
      }
    } finally {
      userController.dispose();
      actionController.dispose();
      statusController.dispose();
    }
  }

  Color _colorForIndex(int index) {
    const colors = [
      LearnifyColors.primary,
      LearnifyColors.secondary,
      LearnifyColors.success,
      LearnifyColors.info,
      LearnifyColors.wellness,
    ];

    return colors[index % colors.length];
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
