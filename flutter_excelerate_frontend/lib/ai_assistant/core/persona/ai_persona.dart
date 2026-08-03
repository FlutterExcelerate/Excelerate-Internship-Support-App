abstract class AiPersona {
  String get systemPrompt;
  String get welcomeTitle;
  String get welcomeDescription;

  List<String> getSuggestions(dynamic context);

  const AiPersona();
}
