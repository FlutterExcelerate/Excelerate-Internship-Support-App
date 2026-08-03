import 'ai_context_provider.dart';

class AiAdminDashboardContext implements ContextEntity {
  final int totalPrograms;
  final int completedModules;
  final int totalModules;
  final int activeNotifications;
  final int totalUsers;
  final int inactiveUsers;
  final int dailyPulseCount;
  final String? currentAdminScreen;
  final String? currentSelectedTab;
  final Map<String, dynamic>? analytics;

  const AiAdminDashboardContext({
    this.totalPrograms = 0,
    this.completedModules = 0,
    this.totalModules = 0,
    this.activeNotifications = 0,
    this.totalUsers = 0,
    this.inactiveUsers = 0,
    this.dailyPulseCount = 0,
    this.currentAdminScreen,
    this.currentSelectedTab,
    this.analytics,
  });

  AiAdminDashboardContext copyWith({
    int? totalPrograms,
    int? completedModules,
    int? totalModules,
    int? activeNotifications,
    int? totalUsers,
    int? inactiveUsers,
    int? dailyPulseCount,
    String? currentAdminScreen,
    String? currentSelectedTab,
    Map<String, dynamic>? analytics,
  }) {
    return AiAdminDashboardContext(
      totalPrograms: totalPrograms ?? this.totalPrograms,
      completedModules: completedModules ?? this.completedModules,
      totalModules: totalModules ?? this.totalModules,
      activeNotifications: activeNotifications ?? this.activeNotifications,
      totalUsers: totalUsers ?? this.totalUsers,
      inactiveUsers: inactiveUsers ?? this.inactiveUsers,
      dailyPulseCount: dailyPulseCount ?? this.dailyPulseCount,
      currentAdminScreen: currentAdminScreen ?? this.currentAdminScreen,
      currentSelectedTab: currentSelectedTab ?? this.currentSelectedTab,
      analytics: analytics ?? this.analytics,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'totalPrograms': totalPrograms,
    'completedModules': completedModules,
    'totalModules': totalModules,
    'activeNotifications': activeNotifications,
    'totalUsers': totalUsers,
    'inactiveUsers': inactiveUsers,
    'dailyPulseCount': dailyPulseCount,
    if (currentAdminScreen != null) 'currentAdminScreen': currentAdminScreen,
    if (currentSelectedTab != null) 'currentSelectedTab': currentSelectedTab,
    if (analytics != null) 'analytics': analytics,
  };
}

class AiAdminContentContext implements ContextEntity {
  final List<String> publishedPrograms;
  final List<String> draftPrograms;
  final List<String> categories;
  final List<String> upcomingDeadlines;
  final List<String> activeMentors;
  final Map<String, dynamic>? selectedProgram;
  final Map<String, dynamic>? selectedModule;
  final Map<String, dynamic>? selectedNotification;
  final Map<String, dynamic>? filters;

  const AiAdminContentContext({
    this.publishedPrograms = const [],
    this.draftPrograms = const [],
    this.categories = const [],
    this.upcomingDeadlines = const [],
    this.activeMentors = const [],
    this.selectedProgram,
    this.selectedModule,
    this.selectedNotification,
    this.filters,
  });

  AiAdminContentContext copyWith({
    List<String>? publishedPrograms,
    List<String>? draftPrograms,
    List<String>? categories,
    List<String>? upcomingDeadlines,
    List<String>? activeMentors,
    Map<String, dynamic>? selectedProgram,
    Map<String, dynamic>? selectedModule,
    Map<String, dynamic>? selectedNotification,
    Map<String, dynamic>? filters,
  }) {
    return AiAdminContentContext(
      publishedPrograms: publishedPrograms ?? this.publishedPrograms,
      draftPrograms: draftPrograms ?? this.draftPrograms,
      categories: categories ?? this.categories,
      upcomingDeadlines: upcomingDeadlines ?? this.upcomingDeadlines,
      activeMentors: activeMentors ?? this.activeMentors,
      selectedProgram: selectedProgram ?? this.selectedProgram,
      selectedModule: selectedModule ?? this.selectedModule,
      selectedNotification: selectedNotification ?? this.selectedNotification,
      filters: filters ?? this.filters,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'publishedPrograms': publishedPrograms,
    'draftPrograms': draftPrograms,
    'categories': categories,
    'upcomingDeadlines': upcomingDeadlines,
    'activeMentors': activeMentors,
    if (selectedProgram != null) 'selectedProgram': selectedProgram,
    if (selectedModule != null) 'selectedModule': selectedModule,
    if (selectedNotification != null)
      'selectedNotification': selectedNotification,
    if (filters != null) 'filters': filters,
  };
}

class AiAdminUsersContext implements ContextEntity {
  final List<String> activeStudents;
  final List<String> inactiveStudents;
  final List<String> adminUsers;
  final Map<String, dynamic> rolePermissions;
  final Map<String, dynamic>? selectedUser;
  final List<Map<String, dynamic>> studentProfiles;

  const AiAdminUsersContext({
    this.activeStudents = const [],
    this.inactiveStudents = const [],
    this.adminUsers = const [],
    this.rolePermissions = const {},
    this.selectedUser,
    this.studentProfiles = const [],
  });

  AiAdminUsersContext copyWith({
    List<String>? activeStudents,
    List<String>? inactiveStudents,
    List<String>? adminUsers,
    Map<String, dynamic>? rolePermissions,
    Map<String, dynamic>? selectedUser,
    List<Map<String, dynamic>>? studentProfiles,
  }) {
    return AiAdminUsersContext(
      activeStudents: activeStudents ?? this.activeStudents,
      inactiveStudents: inactiveStudents ?? this.inactiveStudents,
      adminUsers: adminUsers ?? this.adminUsers,
      rolePermissions: rolePermissions ?? this.rolePermissions,
      selectedUser: selectedUser ?? this.selectedUser,
      studentProfiles: studentProfiles ?? this.studentProfiles,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'activeStudents': activeStudents,
    'inactiveStudents': inactiveStudents,
    'adminUsers': adminUsers,
    'rolePermissions': rolePermissions,
    if (selectedUser != null) 'selectedUser': selectedUser,
    if (studentProfiles.isNotEmpty) 'studentProfiles': studentProfiles,
  };
}

class AiAdminSecurityContext implements ContextEntity {
  final List<String> configuredAdminEmails;
  final Map<String, dynamic> firestoreRules;
  final bool authEnabled;

  const AiAdminSecurityContext({
    this.configuredAdminEmails = const [],
    this.firestoreRules = const {},
    this.authEnabled = true,
  });

  AiAdminSecurityContext copyWith({
    List<String>? configuredAdminEmails,
    Map<String, dynamic>? firestoreRules,
    bool? authEnabled,
  }) {
    return AiAdminSecurityContext(
      configuredAdminEmails:
          configuredAdminEmails ?? this.configuredAdminEmails,
      firestoreRules: firestoreRules ?? this.firestoreRules,
      authEnabled: authEnabled ?? this.authEnabled,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'configuredAdminEmails': configuredAdminEmails,
    'firestoreRules': firestoreRules,
    'authEnabled': authEnabled,
  };
}
