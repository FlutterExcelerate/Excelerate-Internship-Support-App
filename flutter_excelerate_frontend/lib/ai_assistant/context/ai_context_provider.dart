import 'ai_admin_context.dart';

abstract class ContextEntity {
  Map<String, dynamic> toMap();
}

class AiProgramContract {
  final String id;
  final String title;
  final String category;
  final String description;
  final String? status;
  final double? progress;
  const AiProgramContract({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.status,
    this.progress,
  });
  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'category': category, 'description': description, 'status': status, 'progress': progress};
}

class AiSystemContext implements ContextEntity {
  final String system;
  final bool? isAdmin;
  final List<String>? adminPermissions;
  const AiSystemContext({required this.system, this.isAdmin, this.adminPermissions});
  @override
  Map<String, dynamic> toMap() => {'system': system, 'isAdmin': isAdmin, 'adminPermissions': adminPermissions};
}

class AiUserContext implements ContextEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final Map<String, dynamic>? preferences;

  const AiUserContext({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.preferences = const {},
  });

  AiUserContext copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    Map<String, dynamic>? preferences,
  }) {
    return AiUserContext(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'preferences': preferences,
      };
}

class AiProfileContext implements ContextEntity {
  final Map<String, dynamic>? profileData;
  final List<String>? skills;
  final List<String>? interests;

  const AiProfileContext({
    this.profileData = const {},
    this.skills,
    this.interests,
  });

  AiProfileContext copyWith({
    Map<String, dynamic>? profileData,
    List<String>? skills,
    List<String>? interests,
  }) {
    return AiProfileContext(
      profileData: profileData ?? this.profileData,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
    );
  }

  @override
  Map<String, dynamic> toMap() => {'profileData': profileData, 'skills': skills, 'interests': interests};
}

class AiDashboardContext implements ContextEntity {
  final Map<String, dynamic>? dashboardState;
  final List<String>? quickActions;
  final Map<String, dynamic>? personalizedWidgets;

  const AiDashboardContext({
    this.dashboardState = const {},
    this.quickActions,
    this.personalizedWidgets,
  });

  AiDashboardContext copyWith({
    Map<String, dynamic>? dashboardState,
    List<String>? quickActions,
    Map<String, dynamic>? personalizedWidgets,
  }) {
    return AiDashboardContext(
      dashboardState: dashboardState ?? this.dashboardState,
      quickActions: quickActions ?? this.quickActions,
      personalizedWidgets: personalizedWidgets ?? this.personalizedWidgets,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'dashboardState': dashboardState,
        'quickActions': quickActions,
        'personalizedWidgets': personalizedWidgets,
      };
}

class AiProgramsContext implements ContextEntity {
  final List<String> activePrograms;
  final List<String> completedPrograms;
  final List<AiProgramContract>? published;
  final List<AiProgramContract>? programs;

  const AiProgramsContext({
    this.activePrograms = const [],
    this.completedPrograms = const [],
    this.published,
    this.programs,
  });

  AiProgramsContext copyWith({
    List<String>? activePrograms,
    List<String>? completedPrograms,
    List<AiProgramContract>? published,
    List<AiProgramContract>? programs,
  }) {
    return AiProgramsContext(
      activePrograms: activePrograms ?? this.activePrograms,
      completedPrograms: completedPrograms ?? this.completedPrograms,
      published: published ?? this.published,
      programs: programs ?? this.programs,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'activePrograms': activePrograms,
        'completedPrograms': completedPrograms,
      };
}

class AiAssignmentsContext implements ContextEntity {
  final int pendingCount;
  final List<String> upcomingDeadlines;
  final int? pendingAssignments;

  const AiAssignmentsContext({
    this.pendingCount = 0,
    this.upcomingDeadlines = const [],
    this.pendingAssignments,
  });
  AiAssignmentsContext copyWith({
    int? pendingCount,
    List<String>? upcomingDeadlines,
    int? pendingAssignments,
  }) {
    return AiAssignmentsContext(
      pendingCount: pendingCount ?? this.pendingCount,
      upcomingDeadlines: upcomingDeadlines ?? this.upcomingDeadlines,
      pendingAssignments: pendingAssignments ?? this.pendingAssignments,
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'pendingCount': pendingCount,
        'upcomingDeadlines': upcomingDeadlines,
        'pendingAssignments': pendingAssignments,
      };
}

class AiMessagesContext implements ContextEntity {
  final int unreadCount;
  final Map<String, dynamic> recentThreads;
  const AiMessagesContext({
    this.unreadCount = 0,
    this.recentThreads = const {},
  });
  AiMessagesContext copyWith({
    int? unreadCount,
    Map<String, dynamic>? recentThreads,
  }) {
    return AiMessagesContext(
      unreadCount: unreadCount ?? this.unreadCount,
      recentThreads: recentThreads ?? this.recentThreads,
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'unreadCount': unreadCount,
        'recentThreads': recentThreads,
      };
}

class AiNotificationsContext implements ContextEntity {
  final int activeNotifications;
  final List<String> priorityAlerts;
  const AiNotificationsContext({
    this.activeNotifications = 0,
    this.priorityAlerts = const [],
  });
  AiNotificationsContext copyWith({
    int? activeNotifications,
    List<String>? priorityAlerts,
  }) {
    return AiNotificationsContext(
      activeNotifications: activeNotifications ?? this.activeNotifications,
      priorityAlerts: priorityAlerts ?? this.priorityAlerts,
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'activeNotifications': activeNotifications,
        'priorityAlerts': priorityAlerts,
      };
}

class AiDailyPulseContext implements ContextEntity {
  final String lastMood;
  final Map<String, dynamic> pulseHistory;
  final bool? hasSubmittedToday;
  final String? currentMood;
  final List<dynamic>? topBlockers;

  const AiDailyPulseContext({
    this.lastMood = '',
    this.pulseHistory = const {},
    this.hasSubmittedToday,
    this.currentMood,
    this.topBlockers,
  });

  AiDailyPulseContext copyWith({
    String? lastMood,
    Map<String, dynamic>? pulseHistory,
    bool? hasSubmittedToday,
    String? currentMood,
    List<dynamic>? topBlockers,
  }) {
    return AiDailyPulseContext(
      lastMood: lastMood ?? this.lastMood,
      pulseHistory: pulseHistory ?? this.pulseHistory,
      hasSubmittedToday: hasSubmittedToday ?? this.hasSubmittedToday,
      currentMood: currentMood ?? this.currentMood,
      topBlockers: topBlockers ?? this.topBlockers,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'lastMood': lastMood,
        'pulseHistory': pulseHistory,
        'hasSubmittedToday': hasSubmittedToday,
        'currentMood': currentMood,
        'topBlockers': topBlockers,
      };
}

class AiScreenContext implements ContextEntity {
  final String id;
  final String name;
  final Map<String, dynamic> visibleData;

  const AiScreenContext({
    this.id = '',
    this.name = '',
    this.visibleData = const {},
  });

  AiScreenContext copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? visibleData,
  }) {
    return AiScreenContext(
      id: id ?? this.id,
      name: name ?? this.name,
      visibleData: visibleData ?? this.visibleData,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'visibleData': visibleData,
      };
  
  String get screenName => name;
}

class AiNavigationContext implements ContextEntity {
  final String currentRoute;
  final List<String> routeHistory;
  const AiNavigationContext({
    this.currentRoute = '',
    this.routeHistory = const [],
  });
  AiNavigationContext copyWith({
    String? currentRoute,
    List<String>? routeHistory,
  }) {
    return AiNavigationContext(
      currentRoute: currentRoute ?? this.currentRoute,
      routeHistory: routeHistory ?? this.routeHistory,
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'currentRoute': currentRoute,
        'routeHistory': routeHistory,
      };
}

class AiSessionContext implements ContextEntity {
  final String sessionId;
  final DateTime startedAt;
  final Map<String, dynamic> metadata;
  const AiSessionContext({
    required this.sessionId,
    required this.startedAt,
    this.metadata = const {},
  });
  AiSessionContext copyWith({
    String? sessionId,
    DateTime? startedAt,
    Map<String, dynamic>? metadata,
  }) {
    return AiSessionContext(
      sessionId: sessionId ?? this.sessionId,
      startedAt: startedAt ?? this.startedAt,
      metadata: metadata ?? this.metadata,
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'sessionId': sessionId,
        'startedAt': startedAt.toIso8601String(),
        'metadata': metadata,
      };
}

class AiConversationContext implements ContextEntity {
  final String conversationId;
  final int messageCount;
  final Map<String, dynamic> summary;
  const AiConversationContext({
    this.conversationId = '',
    this.messageCount = 0,
    this.summary = const {},
  });
  AiConversationContext copyWith({
    String? conversationId,
    int? messageCount,
    Map<String, dynamic>? summary,
  }) {
    return AiConversationContext(
      conversationId: conversationId ?? this.conversationId,
      messageCount: messageCount ?? this.messageCount,
      summary: summary ?? this.summary,
    );
  }
  @override
  Map<String, dynamic> toMap() => {
        'conversationId': conversationId,
        'messageCount': messageCount,
        'summary': summary,
      };
}

class AiApplicationContext {
  final AiUserContext? userContext;
  final AiProfileContext? profileContext;
  final AiDashboardContext? dashboardContext;
  final AiProgramsContext? programsContext;
  final AiAssignmentsContext? assignmentsContext;
  final AiMessagesContext? messagesContext;
  final AiNotificationsContext? notificationsContext;
  final AiDailyPulseContext? dailyPulseContext;
  final AiScreenContext? currentScreenContext;
  final AiSystemContext? systemContext;
  final AiNavigationContext? navigationContext;
  final AiSessionContext? sessionContext;
  final AiConversationContext? conversationContext;
  final AiAdminDashboardContext? adminDashboardContext;
  final AiAdminContentContext? adminContentContext;
  final AiAdminUsersContext? adminUsersContext;
  final AiAdminSecurityContext? adminSecurityContext;

  const AiApplicationContext({
    this.userContext,
    this.profileContext,
    this.dashboardContext,
    this.programsContext,
    this.assignmentsContext,
    this.messagesContext,
    this.notificationsContext,
    this.dailyPulseContext,
    this.currentScreenContext,
    this.systemContext,
    this.navigationContext,
    this.sessionContext,
    this.conversationContext,
    this.adminDashboardContext,
    this.adminContentContext,
    this.adminUsersContext,
    this.adminSecurityContext,
  });

  AiApplicationContext copyWith({
    AiUserContext? userContext,
    AiProfileContext? profileContext,
    AiDashboardContext? dashboardContext,
    AiProgramsContext? programsContext,
    AiAssignmentsContext? assignmentsContext,
    AiMessagesContext? messagesContext,
    AiNotificationsContext? notificationsContext,
    AiDailyPulseContext? dailyPulseContext,
    AiScreenContext? currentScreenContext,
    AiSystemContext? systemContext,
    AiNavigationContext? navigationContext,
    AiSessionContext? sessionContext,
    AiConversationContext? conversationContext,
    AiAdminDashboardContext? adminDashboardContext,
    AiAdminContentContext? adminContentContext,
    AiAdminUsersContext? adminUsersContext,
    AiAdminSecurityContext? adminSecurityContext,
  }) {
    return AiApplicationContext(
      userContext: userContext ?? this.userContext,
      profileContext: profileContext ?? this.profileContext,
      dashboardContext: dashboardContext ?? this.dashboardContext,
      programsContext: programsContext ?? this.programsContext,
      assignmentsContext: assignmentsContext ?? this.assignmentsContext,
      messagesContext: messagesContext ?? this.messagesContext,
      notificationsContext: notificationsContext ?? this.notificationsContext,
      dailyPulseContext: dailyPulseContext ?? this.dailyPulseContext,
      currentScreenContext: currentScreenContext ?? this.currentScreenContext,
      systemContext: systemContext ?? this.systemContext,
      navigationContext: navigationContext ?? this.navigationContext,
      sessionContext: sessionContext ?? this.sessionContext,
      conversationContext: conversationContext ?? this.conversationContext,
      adminDashboardContext: adminDashboardContext ?? this.adminDashboardContext,
      adminContentContext: adminContentContext ?? this.adminContentContext,
      adminUsersContext: adminUsersContext ?? this.adminUsersContext,
      adminSecurityContext: adminSecurityContext ?? this.adminSecurityContext,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (userContext != null) 'user': userContext!.toMap(),
      if (profileContext != null) 'profile': profileContext!.toMap(),
      if (dashboardContext != null) 'dashboard': dashboardContext!.toMap(),
      if (programsContext != null) 'programs': programsContext!.toMap(),
      if (assignmentsContext != null) 'assignments': assignmentsContext!.toMap(),
      if (messagesContext != null) 'messages': messagesContext!.toMap(),
      if (notificationsContext != null) 'notifications': notificationsContext!.toMap(),
      if (dailyPulseContext != null) 'dailyPulse': dailyPulseContext!.toMap(),
      if (currentScreenContext != null) 'currentScreen': currentScreenContext!.toMap(),
      if (systemContext != null) 'system': systemContext!.toMap(),
      if (navigationContext != null) 'navigation': navigationContext!.toMap(),
      if (sessionContext != null) 'session': sessionContext!.toMap(),
      if (conversationContext != null) 'conversation': conversationContext!.toMap(),
      if (adminDashboardContext != null) 'adminDashboard': adminDashboardContext!.toMap(),
      if (adminContentContext != null) 'adminContent': adminContentContext!.toMap(),
      if (adminUsersContext != null) 'adminUsers': adminUsersContext!.toMap(),
      if (adminSecurityContext != null) 'adminSecurity': adminSecurityContext!.toMap(),
    };
  }
}

