import 'package:flutter/foundation.dart';

abstract class AiDomainContract {
  Map<String, dynamic> toMap();
}

@immutable
class AiAuthContract implements AiDomainContract {
  final bool isAuthenticated;
  final String authProvider;
  final DateTime? lastLogin;

  const AiAuthContract({
    required this.isAuthenticated,
    required this.authProvider,
    this.lastLogin,
  });

  @override
  Map<String, dynamic> toMap() => {
    'isAuthenticated': isAuthenticated,
    'authProvider': authProvider,
    'lastLogin': lastLogin?.toIso8601String(),
  };
}

@immutable
class AiUserContract implements AiDomainContract {
  final String userId;
  final String role;
  final String email;
  final String displayName;

  const AiUserContract({
    required this.userId,
    required this.role,
    required this.email,
    required this.displayName,
  });

  @override
  Map<String, dynamic> toMap() => {
    'userId': userId,
    'role': role,
    'email': email,
    'displayName': displayName,
  };
}

@immutable
class AiProfileContract implements AiDomainContract {
  final List<String> skills;
  final List<String> interests;
  final String bio;
  final String linkedInUrl;

  const AiProfileContract({
    required this.skills,
    required this.interests,
    required this.bio,
    this.linkedInUrl = '',
  });

  @override
  Map<String, dynamic> toMap() => {
    'skills': skills,
    'interests': interests,
    'bio': bio,
    'linkedInUrl': linkedInUrl,
  };
}

@immutable
class AiProgramsContract implements AiDomainContract {
  final List<String> activeProgramIds;
  final List<String> completedProgramIds;
  final int totalCredits;

  const AiProgramsContract({
    required this.activeProgramIds,
    required this.completedProgramIds,
    required this.totalCredits,
  });

  @override
  Map<String, dynamic> toMap() => {
    'activeProgramIds': activeProgramIds,
    'completedProgramIds': completedProgramIds,
    'totalCredits': totalCredits,
  };
}

@immutable
class AiProgramDetailsContract implements AiDomainContract {
  final String programId;
  final String title;
  final List<String> currentModules;
  final double completionPercentage;

  const AiProgramDetailsContract({
    required this.programId,
    required this.title,
    required this.currentModules,
    required this.completionPercentage,
  });

  @override
  Map<String, dynamic> toMap() => {
    'programId': programId,
    'title': title,
    'currentModules': currentModules,
    'completionPercentage': completionPercentage,
  };
}

@immutable
class AiAssignmentsContract implements AiDomainContract {
  final int pendingCount;
  final int completedCount;
  final DateTime? nextDeadline;
  final List<String> upcomingAssignmentTitles;

  const AiAssignmentsContract({
    required this.pendingCount,
    required this.completedCount,
    this.nextDeadline,
    required this.upcomingAssignmentTitles,
  });

  @override
  Map<String, dynamic> toMap() => {
    'pendingCount': pendingCount,
    'completedCount': completedCount,
    'nextDeadline': nextDeadline?.toIso8601String(),
    'upcomingAssignmentTitles': upcomingAssignmentTitles,
  };
}

@immutable
class AiDailyPulseContract implements AiDomainContract {
  final bool hasSubmittedToday;
  final String currentMood;
  final List<String> topBlockers;

  const AiDailyPulseContract({
    required this.hasSubmittedToday,
    required this.currentMood,
    required this.topBlockers,
  });

  @override
  Map<String, dynamic> toMap() => {
    'hasSubmittedToday': hasSubmittedToday,
    'currentMood': currentMood,
    'topBlockers': topBlockers,
  };
}

@immutable
class AiNotificationsContract implements AiDomainContract {
  final int unreadCount;
  final List<String> recentAlerts;

  const AiNotificationsContract({
    required this.unreadCount,
    required this.recentAlerts,
  });

  @override
  Map<String, dynamic> toMap() => {
    'unreadCount': unreadCount,
    'recentAlerts': recentAlerts,
  };
}

@immutable
class AiDashboardContract implements AiDomainContract {
  final List<String> quickActions;
  final Map<String, dynamic> personalizedWidgets;

  const AiDashboardContract({
    required this.quickActions,
    required this.personalizedWidgets,
  });

  @override
  Map<String, dynamic> toMap() => {
    'quickActions': quickActions,
    'personalizedWidgets': personalizedWidgets,
  };
}

@immutable
class AiMessagesContract implements AiDomainContract {
  final int unreadMessagesCount;
  final List<String> activeConversations;

  const AiMessagesContract({
    required this.unreadMessagesCount,
    required this.activeConversations,
  });

  @override
  Map<String, dynamic> toMap() => {
    'unreadMessagesCount': unreadMessagesCount,
    'activeConversations': activeConversations,
  };
}

@immutable
class AiAdminContract implements AiDomainContract {
  final bool isAdmin;
  final List<String> adminPermissions;
  final Map<String, dynamic> activeSystemAlerts;

  const AiAdminContract({
    required this.isAdmin,
    required this.adminPermissions,
    required this.activeSystemAlerts,
  });

  @override
  Map<String, dynamic> toMap() => {
    'isAdmin': isAdmin,
    'adminPermissions': adminPermissions,
    'activeSystemAlerts': activeSystemAlerts,
  };
}

@immutable
class AiThemeContract implements AiDomainContract {
  final String currentThemeMode;
  final bool isHighContrast;
  final String primaryColorHex;

  const AiThemeContract({
    required this.currentThemeMode,
    required this.isHighContrast,
    required this.primaryColorHex,
  });

  @override
  Map<String, dynamic> toMap() => {
    'currentThemeMode': currentThemeMode,
    'isHighContrast': isHighContrast,
    'primaryColorHex': primaryColorHex,
  };
}

@immutable
class AiNavigationContract implements AiDomainContract {
  final String currentRoute;
  final Map<String, dynamic> routeArguments;
  final List<String> backStack;

  const AiNavigationContract({
    required this.currentRoute,
    required this.routeArguments,
    required this.backStack,
  });

  @override
  Map<String, dynamic> toMap() => {
    'currentRoute': currentRoute,
    'routeArguments': routeArguments,
    'backStack': backStack,
  };
}

@immutable
class AiLearningProgressContract implements AiDomainContract {
  final double overallGpa;
  final Map<String, double> skillProficiencies;
  final List<String> recentMilestones;

  const AiLearningProgressContract({
    required this.overallGpa,
    required this.skillProficiencies,
    required this.recentMilestones,
  });

  @override
  Map<String, dynamic> toMap() => {
    'overallGpa': overallGpa,
    'skillProficiencies': skillProficiencies,
    'recentMilestones': recentMilestones,
  };
}
