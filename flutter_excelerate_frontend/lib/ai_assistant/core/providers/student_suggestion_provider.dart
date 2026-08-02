import 'dart:math';
import '../../context/ai_context_provider.dart';
import 'suggestion_provider.dart';

class StudentSuggestionProvider implements SuggestionProvider {
  @override
  List<String> generateSuggestions(AiApplicationContext? context, {int limit = 6}) {
    final suggestions = <String>{};

    if (context == null) {
      _addGeneralSuggestions(suggestions);
      return _finalize(suggestions, limit);
    }

    if (context.currentScreenContext != null) {
      _addScreenContextSuggestions(suggestions, context.currentScreenContext!);
    }

    if (context.userContext != null) {
      _addUserContextSuggestions(suggestions, context.userContext!);
    }

    if (context.programsContext != null && context.programsContext!.activePrograms.isNotEmpty) {
      _addProgramSuggestions(suggestions, context.programsContext!);
    }

    if (context.assignmentsContext != null && context.assignmentsContext!.pendingCount > 0) {
      _addAssignmentSuggestions(suggestions, context.assignmentsContext!);
    }

    if (context.dailyPulseContext != null) {
      _addPulseSuggestions(suggestions, context.dailyPulseContext!);
    }

    _addGeneralSuggestions(suggestions);

    return _finalize(suggestions, limit);
  }

  void _addScreenContextSuggestions(Set<String> suggestions, AiScreenContext screen) {
    switch (screen.screenName) {
      case 'dashboard':
      case '/dashboard':
        suggestions.add("Summarize my daily tasks");
        suggestions.add("Show my learning progress");
        break;
      case 'programs':
      case '/programs':
        suggestions.add("Recommend next course");
        suggestions.add("Explain this topic");
        break;
      case 'assignments':
      case '/assignments':
        suggestions.add("Help me with assignment");
        suggestions.add("Create quiz");
        break;
      case 'messages':
      case '/messages':
        suggestions.add("Draft a professional response");
        suggestions.add("Summarize recent messages");
        break;
      case 'profile':
      case '/profile':
        suggestions.add("Update my career goals");
        suggestions.add("Recommend skills to learn");
        break;
    }
  }

  void _addUserContextSuggestions(Set<String> suggestions, AiUserContext user) {
    if (user.role == 'student' || user.role == 'intern') {
      suggestions.add("Generate interview questions");
      suggestions.add("How can I improve my resume?");
    } else if (user.role == 'mentor') {
      suggestions.add("Draft feedback for my mentee");
      suggestions.add("Suggest mentoring topics");
    }
  }

  void _addProgramSuggestions(Set<String> suggestions, AiProgramsContext programs) {
    suggestions.add("Review my active programs");
    suggestions.add("What should I study next?");
  }

  void _addAssignmentSuggestions(Set<String> suggestions, AiAssignmentsContext assignments) {
    suggestions.add("Help me prioritize assignments");
  }

  void _addPulseSuggestions(Set<String> suggestions, AiDailyPulseContext pulse) {
    if (pulse.lastMood.isNotEmpty) {
      suggestions.add("How can I improve my mood today?");
    }
    suggestions.add("Summarize today's goals");
  }

  void _addGeneralSuggestions(Set<String> suggestions) {
    suggestions.addAll([
      "Explain a complex topic",
      "Summarize today's lessons",
      "Help me prepare for an interview",
      "Recommend next course",
      "Create a quick quiz",
    ]);
  }

  List<String> _finalize(Set<String> suggestions, int limit) {
    final list = suggestions.toList();
    list.shuffle(Random());
    return list.take(limit).toList();
  }
}
