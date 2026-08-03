import 'dart:async';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_module.dart';
import 'package:flutter_excelerate_frontend/firebase/models/app_user.dart';
import 'package:flutter_excelerate_frontend/firebase/models/daily_pulse_model.dart';
import 'package:flutter_excelerate_frontend/firebase/models/notification_model.dart';
import 'package:flutter_excelerate_frontend/firebase/models/program_model.dart';
import 'package:flutter_excelerate_frontend/firebase/service/daily_pulse_service.dart';
import 'package:flutter_excelerate_frontend/firebase/service/notification_service.dart';
import 'package:flutter_excelerate_frontend/firebase/service/program_service.dart';
import 'package:flutter_excelerate_frontend/firebase/service/user_service.dart';
import 'ai_admin_context.dart';

class AdminContextSynchronizer {
  static final AdminContextSynchronizer instance =
      AdminContextSynchronizer._internal();

  AdminContextSynchronizer._internal();

  StreamSubscription? _programSub;
  StreamSubscription? _userSub;
  StreamSubscription? _notificationSub;
  StreamSubscription? _pulseSub;

  List<ProgramModel> _programs = [];
  List<AppUser> _users = [];
  List<NotificationModel> _notifications = [];
  List<DailyPulseModel> _pulses = [];

  final String _currentAdminScreen = 'Admin Dashboard';
  String? _currentSelectedTab = 'Overview';
  Map<String, dynamic>? _selectedProgram;
  Map<String, dynamic>? _selectedUser;
  Map<String, dynamic>? _selectedModule;
  Map<String, dynamic>? _selectedNotification;
  Map<String, dynamic>? _filters;

  bool _isListening = false;

  void startListening() {
    if (_isListening) return;
    _isListening = true;

    _programSub = ProgramService.instance.programsStream().listen((programs) {
      _programs = programs;
      _sync();
    });

    _userSub = UserService.instance.usersStream().listen((users) {
      _users = users;
      _sync();
    });

    _notificationSub = NotificationService.instance
        .notificationsStream()
        .listen((notifications) {
          _notifications = notifications;
          _sync();
        });

    _pulseSub = DailyPulseService.instance.pulsesStream().listen((pulses) {
      _pulses = pulses;
      _sync();
    });
  }

  void stopListening() {
    _programSub?.cancel();
    _userSub?.cancel();
    _notificationSub?.cancel();
    _pulseSub?.cancel();
    _isListening = false;
  }

  void updateTab(String tabName) {
    _currentSelectedTab = tabName;
    _sync();
  }

  void updateSelectedProgram(Map<String, dynamic>? program) {
    _selectedProgram = program;
    _sync();
  }

  void updateSelectedUser(Map<String, dynamic>? user) {
    _selectedUser = user;
    _sync();
  }

  void updateSelectedModule(Map<String, dynamic>? module) {
    _selectedModule = module;
    _sync();
  }

  void updateSelectedNotification(Map<String, dynamic>? notification) {
    _selectedNotification = notification;
    _sync();
  }

  void updateFilters(Map<String, dynamic>? filters) {
    _filters = filters;
    _sync();
  }

  void _sync() {
    final completedModules = 0;
    final moduleCount = 0;

    final studentUsers = _users
        .where((user) => user.role.toLowerCase() != 'admin')
        .toList();
    final inactiveCount = _users.where((user) => !user.isActive).length;

    final publishedPrograms = _programs
        .where((p) => p.isPublished)
        .map((p) => p.title)
        .toList();
    final draftPrograms = _programs
        .where((p) => !p.isPublished)
        .map((p) => p.title)
        .toList();
    final categories = _programs.map((p) => p.category).toSet().toList();
    final upcomingDeadlines = _programs
        .where((p) => p.applicationDeadline.isNotEmpty)
        .map((p) => p.title)
        .toList();
    final activeMentors = _programs
        .where((p) => p.mentorName.isNotEmpty)
        .map((p) => p.mentorName)
        .toSet()
        .toList();

    AiModule.instance.patchApplicationContext(
      adminDashboardContext: AiAdminDashboardContext(
        totalPrograms: _programs.length,
        completedModules: completedModules,
        totalModules: moduleCount,
        activeNotifications: _notifications.length,
        totalUsers: _users.length,
        inactiveUsers: inactiveCount,
        dailyPulseCount: _pulses.length,
        currentAdminScreen: _currentAdminScreen,
        currentSelectedTab: _currentSelectedTab,
      ),
      adminContentContext: AiAdminContentContext(
        publishedPrograms: publishedPrograms,
        draftPrograms: draftPrograms,
        categories: categories,
        upcomingDeadlines: upcomingDeadlines,
        activeMentors: activeMentors,
        selectedProgram: _selectedProgram,
        selectedModule: _selectedModule,
        selectedNotification: _selectedNotification,
        filters: _filters,
      ),
      adminUsersContext: AiAdminUsersContext(
        activeStudents: studentUsers
            .where((u) => u.isActive)
            .map((u) => u.email)
            .toList(),
        inactiveStudents: studentUsers
            .where((u) => !u.isActive)
            .map((u) => u.email)
            .toList(),
        adminUsers: _users
            .where((u) => u.role.toLowerCase() == 'admin')
            .map((u) => u.email)
            .toList(),
        rolePermissions: const {},
        selectedUser: _selectedUser,
      ),
    );
  }
}
