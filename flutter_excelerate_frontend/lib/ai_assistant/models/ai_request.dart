import '../core/ai_cancel_token.dart';

class AiRequest {
  final String systemPrompt;
  final String userPrompt;
  final Map<String, dynamic>? configurationOverrides;
  final Map<String, dynamic>? metadata;
  final AiCancelToken? cancelToken;

  const AiRequest({
    required this.systemPrompt,
    required this.userPrompt,
    this.configurationOverrides,
    this.metadata,
    this.cancelToken,
  });

  AiRequest copyWith({
    String? systemPrompt,
    String? userPrompt,
    Map<String, dynamic>? configurationOverrides,
    Map<String, dynamic>? metadata,
    AiCancelToken? cancelToken,
  }) {
    return AiRequest(
      systemPrompt: systemPrompt ?? this.systemPrompt,
      userPrompt: userPrompt ?? this.userPrompt,
      configurationOverrides: configurationOverrides ?? this.configurationOverrides,
      metadata: metadata ?? this.metadata,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systemPrompt': systemPrompt,
      'userPrompt': userPrompt,
      if (configurationOverrides != null) 'configurationOverrides': configurationOverrides,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AiRequest.fromJson(Map<String, dynamic> json) {
    return AiRequest(
      systemPrompt: json['systemPrompt'] as String? ?? '',
      userPrompt: json['userPrompt'] as String? ?? '',
      configurationOverrides: json['configurationOverrides'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  factory AiRequest.fromPromptBuilder(Map<String, String> promptMap) {
    return AiRequest(
      systemPrompt: promptMap['system'] ?? '',
      userPrompt: promptMap['user'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiRequest &&
        other.systemPrompt == systemPrompt &&
        other.userPrompt == userPrompt;
  }

  @override
  int get hashCode => systemPrompt.hashCode ^ userPrompt.hashCode;
}
