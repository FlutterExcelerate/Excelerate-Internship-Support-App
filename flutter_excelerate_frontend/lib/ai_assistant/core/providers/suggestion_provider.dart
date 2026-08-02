import '../../context/ai_context_provider.dart';

abstract class SuggestionProvider {
  List<String> generateSuggestions(AiApplicationContext? context, {int limit = 6});
}
