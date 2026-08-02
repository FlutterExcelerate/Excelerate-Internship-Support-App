import '../context/ai_context_provider.dart';
import 'providers/admin_suggestion_provider.dart';
import 'providers/student_suggestion_provider.dart';
import 'personas/ai_persona.dart';
import 'personas/student_persona.dart';
import 'personas/admin_persona.dart';

class SuggestionEngine {
  const SuggestionEngine._();

  static List<String> generateSuggestions(AiApplicationContext? context, {int limit = 6}) {
    if (context?.systemContext?.isAdmin == true) {
      return AdminSuggestionProvider().generateSuggestions(context, limit: limit);
    }
    return StudentSuggestionProvider().generateSuggestions(context, limit: limit);
  }

  static AiPersona getPersona(AiApplicationContext? context) {
    if (context?.systemContext?.isAdmin == true) {
      return const AdminPersona();
    }
    return const StudentPersona();
  }
}


