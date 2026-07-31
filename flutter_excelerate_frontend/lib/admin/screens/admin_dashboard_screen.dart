import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/models/program_model.dart';
import '../../firebase/models/module_model.dart';
import '../../firebase/models/app_user.dart';
import '../../firebase/service/module_service.dart';
import '../../firebase/service/repository.dart';
import '../../firebase/service/program_service.dart';
import '../../firebase/service/user_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/learnify_widgets.dart';
import '../models/admin_user_activity.dart';
import '../tabs/admin_content_tab.dart';
import '../tabs/admin_overview_tab.dart';
import '../tabs/admin_settings_tab.dart';
import '../tabs/admin_users_tab.dart';
import '../widgets/admin_widgets.dart';
import '../../firebase/models/notification_model.dart';
import '../../firebase/service/notification_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  final ProgramService _programService = ProgramService.instance;
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
    return StreamBuilder<List<ProgramModel>>(
      stream: _programService.programsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }

        return StreamBuilder<List<NotificationModel>>(
          stream: NotificationService.instance.notificationsStream(),
          builder: (context, notificationSnapshot) {
            return StreamBuilder<List<AppUser>>(
              stream: UserService.instance.usersStream(),
              builder: (context, userSnapshot) {
                final users = userSnapshot.data ?? [];
                final notifications = notificationSnapshot.data ?? [];
                final programs = snapshot.data ?? [];
                final pages = [
                  AdminOverviewTab(
                    programs: programs,
                    notifications: notifications,
                    users: users,
                    activities: _activities,
                    onAddProgram: () => _showProgramDialog(programs.length),
                    onAddNotification: _showNotificationDialog,
                    onOpenContent: () => _selectTab(1),
                    onOpenUsers: () => _selectTab(2),
                  ),
                  AdminContentTab(
                    programs: programs,
                    notifications: notifications,
                    onAddProgram: () => _showProgramDialog(programs.length),
                    onAddModule: _showModuleDialog,
                    onAddNotification: _showNotificationDialog,
                  ),
                  AdminUsersTab(
                    users: users,
                    activities: _activities,
                    onAddActivity: _showActivityDialog,
                    onEditUser: _showUserAdminDialog,
                  ),
                  const AdminSettingsTab(adminEmails: {}),
                ];

                final safeIndex = _selectedIndex.clamp(0, pages.length - 1);

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
                        Text(_titleForIndex(safeIndex)),
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
                            reverse: safeIndex < _previousIndex,
                            transitionBuilder:
                                (child, primaryAnimation, secondaryAnimation) {
                                  return SharedAxisTransition(
                                    animation: primaryAnimation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType:
                                        SharedAxisTransitionType.horizontal,
                                    fillColor: Colors.transparent,
                                    child: child,
                                  );
                                },
                            child: pages[safeIndex],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 5,
                        child: FloatingGlassNavBar(
                          selectedIndex: _selectedIndex,
                          destinations: _navDestinations,
                          onDestinationSelected: _selectTab,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
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

  Future<void> _showProgramDialog(int currentProgramCount) async {
    final added = await showDialog<ProgramModel>(
      context: context,
      builder: (context) => AdminFormDialog(
        title: 'Add Program',
        actionLabel: 'Add Program',
        fields: const [
          ('Title', '', 1),
          ('Category', 'Course', 1),
          ('Duration', '4 weeks', 1),
          ('Level', 'Beginner', 1),
          ('Mentor name', '', 1),
          ('Mentor email', '', 1),
          ('Application deadline', '', 1),
          ('Schedule', 'Flexible', 1),
          ('Capacity', '30', 1),
          ('Outcomes, comma separated', '', 2),
          ('Prerequisites, comma separated', '', 2),
          ('Description', '', 3),
        ],
        onSubmit: (values) {
          final title = values['Title'] ?? '';
          final description = values['Description'] ?? '';
          final mentorName = values['Mentor name'] ?? '';
          final mentorEmail = values['Mentor email'] ?? '';

          if (title.isEmpty ||
              description.isEmpty ||
              mentorName.isEmpty ||
              mentorEmail.isEmpty) {
            _showSnack(
              'Title, description, mentor name, and mentor email are required.',
            );
            return;
          }
          final capacity = int.tryParse(values['Capacity'] ?? '') ?? 0;
          Navigator.of(context).pop(
            ProgramModel(
              id: '',
              title: title,
              description: description,
              category: values['Category']!.isEmpty
                  ? 'Course'
                  : values['Category']!,
              duration: values['Duration']!.isEmpty
                  ? '4 weeks'
                  : values['Duration']!,
              level: values['Level']!.isEmpty ? 'Beginner' : values['Level']!,
              imageUrl: '',
              mentorName: mentorName,
              mentorEmail: mentorEmail,
              applicationDeadline: values['Application deadline'] ?? '',
              schedule: values['Schedule']!.isEmpty
                  ? 'Flexible'
                  : values['Schedule']!,
              capacity: capacity,
              outcomes: _splitList(values['Outcomes, comma separated'] ?? ''),
              prerequisites: _splitList(
                values['Prerequisites, comma separated'] ?? '',
              ),
              color: _colorForIndex(currentProgramCount).toARGB32(),
              isPublished: true,
              createdBy: '',
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.now(),
            ),
          );
        },
      ),
    );

    if (!mounted) return;

    if (added != null) {
      await ProgramService.instance.addProgram(program: added);
      _showSnack('Program added successfully.');
    }
  }

  Future<void> _showModuleDialog(ProgramModel program) async {
    final added = await showDialog<ModuleModel>(
      context: context,
      builder: (context) => AdminFormDialog(
        title: 'Add Module',
        actionLabel: 'Add Module',
        headerWidget: Text(
          program.title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        fields: const [
          ('Module title', '', 1),
          ('Summary', '', 3),
          ('Duration', '30 min', 1),
        ],
        onSubmit: (values) {
          final title = values['Module title'] ?? '';
          final summary = values['Summary'] ?? '';

          if (title.isEmpty || summary.isEmpty) {
            _showSnack('Module title and summary are required.');
            return;
          }

          Navigator.of(context).pop(
            ModuleModel(
              id: '',
              title: title,
              summary: summary,
              duration: values['Duration']!.isEmpty
                  ? '30 min'
                  : values['Duration']!,
              isComplete: false,
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.now(),
            ),
          );
        },
      ),
    );

    if (!mounted) return;

    if (added != null) {
      await ModuleService.instance.addModule(
        programId: program.id,
        module: added,
      );
      _showSnack('${added.title} was added to ${program.title}.');
    }
  }

  Future<void> _showNotificationDialog() async {
    final added = await showDialog<NotificationModel>(
      context: context,
      builder: (context) => AdminFormDialog(
        title: 'Add Notification',
        actionLabel: 'Publish',
        fields: const [
          ('Title', '', 1),
          ('Category', 'Announcements', 1),
          ('Message', '', 4),
        ],
        onSubmit: (values) {
          final title = values['Title'] ?? '';
          final message = values['Message'] ?? '';

          if (title.isEmpty || message.isEmpty) {
            _showSnack('Notification title and message are required.');
            return;
          }
          Navigator.of(context).pop(
            NotificationModel(
              id: '',
              title: title,
              message: message,
              category: values['Category']!.isEmpty
                  ? 'Announcements'
                  : values['Category']!,
              color: LearnifyColors.info.toARGB32(),
              icon: 'campaign',
              requiresAction: false,
              createdAt: Timestamp.now(),
            ),
          );
        },
      ),
    );

    if (!mounted) return;

    if (added != null) {
      await NotificationService.instance.addNotification(notification: added);

      _showSnack('${added.title} was published.');
    }
  }

  Future<void> _showActivityDialog() async {
    final added = await showDialog<AdminUserActivity>(
      context: context,
      builder: (context) => AdminFormDialog(
        title: 'Log User Activity',
        actionLabel: 'Log Activity',
        fields: const [
          ('User name', '', 1),
          ('Activity', '', 3),
          ('Status', 'Needs review', 1),
        ],
        onSubmit: (values) {
          final user = values['User name'] ?? '';
          final action = values['Activity'] ?? '';

          if (user.isEmpty || action.isEmpty) {
            _showSnack('User and activity are required.');
            return;
          }

          Navigator.of(context).pop(
            AdminUserActivity(
              user: user,
              action: action,
              status: values['Status']!.isEmpty
                  ? 'Needs review'
                  : values['Status']!,
              time: 'Just now',
              color: LearnifyColors.warning,
            ),
          );
        },
      ),
    );

    if (!mounted) return;

    if (added != null) {
      setState(() => _activities.insert(0, added));
      _showSnack('Activity was logged for ${added.user}.');
    }
  }

  Future<void> _showUserAdminDialog(AppUser user) async {
    final values = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AdminFormDialog(
        title: 'Update User',
        actionLabel: 'Save',
        headerWidget: Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        fields: [
          ('Role', user.role, 1),
          ('Active', user.isActive ? 'true' : 'false', 1),
          ('Admin department', user.adminDepartment, 1),
          ('Admin access level', user.adminAccessLevel, 1),
        ],
        onSubmit: (values) {
          Navigator.of(context).pop(values);
        },
      ),
    );

    if (values == null) return;

    await UserService.instance.updateUserAdminFields(
      uid: user.uid,
      role: values['Role']!.isEmpty ? user.role : values['Role']!,
      isActive: (values['Active'] ?? 'true').toLowerCase() == 'true',
      adminDepartment: values['Admin department'] ?? '',
      adminAccessLevel: values['Admin access level']!.isEmpty
          ? 'standard'
          : values['Admin access level']!,
    );
    _showSnack('${user.name.isEmpty ? user.email : user.name} was updated.');
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

  List<String> _splitList(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
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
