import 'dart:math';
import '../../context/ai_context_provider.dart';
import 'suggestion_provider.dart';

class AdminSuggestionProvider implements SuggestionProvider {
  @override
  List<String> generateSuggestions(AiApplicationContext? context, {int limit = 6}) {
    final suggestions = <String>{};

    if (context != null) {
      final tab = context.adminDashboardContext?.currentSelectedTab?.toLowerCase() ?? '';

      switch (tab) {
        case 'overview':
        case 'dashboard':
          suggestions.addAll([
            "Summarize Dashboard",
            "Platform Health Check",
            "Show Today's Insights",
          ]);
          break;
        case 'content':
          suggestions.addAll([
            "Review Published Courses",
            "Find Draft Programs",
            "Show Expiring Courses",
            "Analyze Course Performance",
          ]);
          break;
        case 'users':
          suggestions.addAll([
            "Review Active Users",
            "Find Inactive Students",
            "Show User Statistics",
            "Review User Activity",
          ]);
          break;
        case 'security':
          suggestions.addAll([
            "Review Security Status",
            "Check Admin Permissions",
            "Show Security Recommendations",
            "Analyze Access Rules",
          ]);
          break;
      }
    }

    // Add fallback/general admin suggestions
    suggestions.addAll([
      "Show Dashboard Summary",
      "Analyze Platform Statistics",
      "Review Active Programs",
      "Find Expiring Programs",
      "Show Pending Deadlines",
      "Review Student Activity",
      "List Inactive Users",
      "Review Notifications",
      "Open Security Overview",
      "Check Admin Access",
      "Show Course Analytics",
      "Find Draft Programs",
      "Review Published Courses",
      "Suggest Platform Improvements",
      "Detect System Issues",
      "Summarize Today's Admin Activity",
    ]);

    final list = suggestions.toList();
    list.shuffle(Random());
    return list.take(limit).toList();
  }
}
