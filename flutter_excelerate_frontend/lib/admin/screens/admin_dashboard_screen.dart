// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/context/ai_admin_context.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/context/ai_context_provider.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/persona/admin_persona.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_action.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_module.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/widget/ai_launcher.dart';
import 'package:flutter_excelerate_frontend/firebase/models/program_model.dart';
import '../../firebase/models/module_model.dart';
import '../../firebase/models/app_user.dart';
import '../../firebase/models/daily_pulse_model.dart';
import '../../firebase/service/daily_pulse_service.dart';
import '../../firebase/service/module_service.dart';
import '../../firebase/service/repository.dart';
import '../../firebase/service/program_service.dart';
import '../../firebase/service/user_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';
import '../../student/widgets/learnify_widgets.dart';
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

  StreamSubscription<AiActionRequest>? _actionSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AiModule.isInitialized) {
        AiModule.initialize();
      }

      AiModule.instance.patchApplicationContext(
        system: const AiSystemContext(system: 'AdminPanel', isAdmin: true),
      );

      _actionSubscription = AiModule.instance.actionStream.listen((action) {
        if (!mounted) return;
        if (action.type == 'openDashboard' || action.type == 'openOverview')
          _selectTab(0);
        else if (action.type == 'openContent')
          _selectTab(1);
        else if (action.type == 'openUsers')
          _selectTab(2);
        else if (action.type == 'openSecurity' || action.type == 'openSettings')
          _selectTab(3);
      });
    });
  }

  @override
  void dispose() {
    _actionSubscription?.cancel();
    super.dispose();
  }

  final ProgramService _programService = ProgramService.instance;

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
                return StreamBuilder<List<DailyPulseModel>>(
                  stream: DailyPulseService.instance.pulsesStream(),
                  builder: (context, pulseSnapshot) {
                    final users = userSnapshot.data ?? [];
                    final pulses = pulseSnapshot.data ?? [];
                    final notifications = notificationSnapshot.data ?? [];
                    final programs = snapshot.data ?? [];

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (AiModule.isInitialized) {
                        AiModule.instance.patchApplicationContext(
                          programs: AiProgramsContext(
                            programs: programs
                                .map(
                                  (c) => AiProgramContract(
                                    id: c.id,
                                    title: c.title,
                                    category: c.category,
                                    description: c.description,
                                    status: c.isPublished ? 'published' : 'draft',
                                  ),
                                )
                                .toList(),
                          ),
                          adminUsersContext: AiAdminUsersContext(
                            adminUsers: users
                                .where((u) => u.role == 'admin')
                                .map((u) => u.uid)
                                .toList(),
                            activeStudents: users
                                .where((u) => u.role == 'student' && u.isActive)
                                .map((u) => '${u.name.isNotEmpty ? u.name : 'Unknown'} (${u.email})')
                                .toList(),
                            inactiveStudents: users
                                .where(
                                  (u) => u.role == 'student' && !u.isActive,
                                )
                                .map((u) => '${u.name.isNotEmpty ? u.name : 'Unknown'} (${u.email})')
                                .toList(),
                            studentProfiles: users
                                .where((u) => u.role == 'student')
                                .map((u) => {
                                  'name': u.name,
                                  'email': u.email,
                                  'isActive': u.isActive,
                                  'cohort': u.cohort,
                                  'location': u.location,
                                  'headline': u.headline,
                                  'skills': u.skills,
                                })
                                .toList(),
                          ),
                          adminContentContext: AiAdminContentContext(
                            publishedPrograms: programs
                                .where((p) => p.isPublished)
                                .map((p) => p.title)
                                .toList(),
                            draftPrograms: programs
                                .where((p) => !p.isPublished)
                                .map((p) => p.title)
                                .toList(),
                            categories: programs
                                .map((p) => p.category)
                                .toSet()
                                .toList(),
                            upcomingDeadlines: programs
                                .where((p) => p.applicationDeadline.isNotEmpty)
                                .map(
                                  (p) => '${p.title}: ${p.applicationDeadline}',
                                )
                                .toList(),
                          ),
                        );
                      }
                    });

                    final pages = [
                      AdminOverviewTab(
                        programs: programs,
                        notifications: notifications,
                        users: users,
                        pulseCount: pulses.length,
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
                        onDeleteProgram: _deleteProgram,
                      ),
                      AdminUsersTab(
                        users: users,
                        pulses: pulses,
                        onEditUser: _showUserAdminDialog,
                      ),
                      AdminSettingsTab(users: users, programs: programs),
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
                            Flexible(
                              child: Text(
                                _titleForIndex(safeIndex),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
                                    (
                                      child,
                                      primaryAnimation,
                                      secondaryAnimation,
                                    ) {
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
                            left: context.responsiveValue(
                              mobile: 14.0,
                              tablet: 20.0,
                              desktop: 24.0,
                            ),
                            right: context.responsiveValue(
                              mobile: 14.0,
                              tablet: 20.0,
                              desktop: 24.0,
                            ),
                            bottom: context.viewPadding.bottom + 5,
                            child: FloatingGlassNavBar(
                              selectedIndex: _selectedIndex,
                              destinations: _navDestinations,
                              onDestinationSelected: _selectTab,
                            ),
                          ),
                          Positioned(
                            bottom: context.viewPadding.bottom + 85,
                            right: context.responsiveValue(
                              mobile: 12.0,
                              tablet: 16.0,
                            ),
                            child: const AiLauncher(persona: AdminPersona()),
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

    AiModule.instance.patchApplicationContext(
      adminDashboardContext: AiAdminDashboardContext(
        currentSelectedTab: _titleForIndex(index).toLowerCase(),
      ),
    );
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

  Future<void> _deleteProgram(ProgramModel program) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Program'),
        content: Text('Are you sure you want to delete ${program.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _programService.deleteProgram(program.id);
      if (mounted) {
        _showSnack('${program.title} was deleted.');
      }
    }
  }

  Future<void> _showNotificationDialog() async {
    final added = await showDialog<NotificationModel>(
      context: context,
      builder: (context) => const _NotificationFormDialog(),
    );

    if (!mounted) return;

    if (added != null) {
      await NotificationService.instance.addNotification(notification: added);

      _showSnack('${added.title} was published.');
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

class _NotificationFormDialog extends StatefulWidget {
  const _NotificationFormDialog();

  @override
  State<_NotificationFormDialog> createState() =>
      _NotificationFormDialogState();
}

class _NotificationFormDialogState extends State<_NotificationFormDialog> {
  static const _categories = [
    'Announcement',
    'Assignment',
    'Update',
    'Reminder',
    'Alert',
  ];

  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = _categories.first;

  @override
  void dispose() {
    disposeTextControllersAfterFrame([_titleController, _messageController]);
    super.dispose();
  }

  void _publish() {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification title and message are required.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).pop(
      NotificationModel(
        id: '',
        title: title,
        message: message,
        category: _selectedCategory,
        color: _colorForCategory(_selectedCategory).toARGB32(),
        icon: _iconKeyForCategory(_selectedCategory),
        requiresAction: _selectedCategory == 'Assignment',
        createdAt: Timestamp.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LearnifyDialogShell(
      title: 'Add Notification',
      subtitle: 'Publish a clear update for all signed-in learners.',
      icon: Icons.campaign_outlined,
      color: LearnifyColors.info,
      primaryLabel: 'Publish',
      onPrimaryPressed: _publish,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LearnifyDialogField(
            controller: _titleController,
            label: 'Title',
            icon: Icons.title_rounded,
          ),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.local_offer_outlined),
            ),
            items: _categories
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedCategory = value);
            },
          ),
          const SizedBox(height: 12),
          LearnifyDialogField(
            controller: _messageController,
            label: 'Message',
            icon: Icons.chat_bubble_outline_rounded,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Color _colorForCategory(String category) {
    return switch (category) {
      'Assignment' => LearnifyColors.warning,
      'Update' => LearnifyColors.success,
      'Reminder' => LearnifyColors.wellness,
      'Alert' => LearnifyColors.warning,
      _ => LearnifyColors.info,
    };
  }

  String _iconKeyForCategory(String category) {
    return switch (category) {
      'Assignment' => 'assignment',
      'Update' => 'sync',
      'Reminder' => 'warning',
      'Alert' => 'warning',
      _ => 'campaign',
    };
  }
}
