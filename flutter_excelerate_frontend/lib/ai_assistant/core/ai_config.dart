import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AiProvider { 
  gemini, 
  openAi, 
  claude; 

  String toJson() => name;

  static AiProvider fromJson(String json) {
    return AiProvider.values.firstWhere(
      (e) => e.name == json,
      orElse: () => AiProvider.gemini,
    );
  }
}

class AiConfig {
  final AiProvider provider;
  final String modelName;
  final String apiEndpoint;
  final String apiKey;
  final double temperature;
  final int maxOutputTokens;
  final Duration requestTimeout;
  final int retryCount;
  final bool enableStreaming;
  final bool enableLogging;
  final bool debugMode;
  final Duration cacheDuration;
  final String safetyConfiguration;
  final double topP;
  final int topK;

  const AiConfig._internal({
    required this.provider,
    required this.modelName,
    required this.apiEndpoint,
    required this.apiKey,
    required this.temperature,
    required this.maxOutputTokens,
    required this.requestTimeout,
    required this.retryCount,
    required this.enableStreaming,
    required this.enableLogging,
    required this.debugMode,
    required this.cacheDuration,
    required this.safetyConfiguration,
    required this.topP,
    required this.topK,
  });

  factory AiConfig.fromEnvironment({String? apiKey}) {
    final bool isEnvLoaded = dotenv.isInitialized;
    
    String getEnv(String key, String defaultValue) {
      if (isEnvLoaded && dotenv.env.containsKey(key)) {
        return dotenv.env[key] ?? defaultValue;
      }
      return defaultValue;
    }

    final String finalApiKey = (apiKey != null && apiKey.isNotEmpty) 
        ? apiKey 
        : getEnv('GEMINI_API_KEY', '');
        
    debugPrint('[AiConfig] dotenv loaded: $isEnvLoaded');
    debugPrint('[AiConfig] API key exists: ${finalApiKey.isNotEmpty}');
    debugPrint('[AiConfig] API key length: ${finalApiKey.length}');
    debugPrint('[AiConfig] Model name: ${getEnv('GEMINI_MODEL', 'gemini-3.1-flash-lite')}');

    return AiConfig._internal(
      provider: AiProvider.gemini,
      modelName: getEnv('GEMINI_MODEL', 'gemini-3.1-flash-lite'),
      apiEndpoint: 'https://generativelanguage.googleapis.com/v1beta',
      apiKey: finalApiKey,
      temperature: double.tryParse(getEnv('AI_TEMPERATURE', '')) ?? 0.7,
      maxOutputTokens: int.tryParse(getEnv('AI_MAX_OUTPUT_TOKENS', '')) ?? 1024,
      requestTimeout: Duration(seconds: int.tryParse(getEnv('AI_TIMEOUT_SECONDS', '')) ?? 30),
      retryCount: 3,
      enableStreaming: true,
      enableLogging: (getEnv('AI_ENABLE_LOGGING', '').toLowerCase() == 'true'),
      debugMode: false,
      cacheDuration: const Duration(hours: 1),
      safetyConfiguration: 'moderate',
      topP: double.tryParse(getEnv('AI_TOP_P', '')) ?? 0.9,
      topK: int.tryParse(getEnv('AI_TOP_K', '')) ?? 40,
    );
  }
}



