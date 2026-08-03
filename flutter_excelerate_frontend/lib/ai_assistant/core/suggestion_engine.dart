import 'package:flutter_excelerate_frontend/ai_assistant/core/persona/admin_persona.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/persona/ai_persona.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/persona/student_persona.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/provider/admin_suggestion_provider.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/provider/student_suggestion_provider.dart';

import '../context/ai_context_provider.dart';

class SuggestionEngine {
  const SuggestionEngine._();

  static List<String> generateSuggestions(
    AiApplicationContext? context, {
    int limit = 6,
  }) {
    if (context?.systemContext?.isAdmin == true) {
      return AdminSuggestionProvider().generateSuggestions(
        context,
        limit: limit,
      );
    }
    return StudentSuggestionProvider().generateSuggestions(
      context,
      limit: limit,
    );
  }

  static AiPersona getPersona(AiApplicationContext? context) {
    if (context?.systemContext?.isAdmin == true) {
      return const AdminPersona();
    }
    return const StudentPersona();
  }
}
