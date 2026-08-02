import 'package:flutter/foundation.dart';

class AiContext {
  final String systemPrompt;
  final List<String> documents;
  final Map<String, dynamic>? extraContext;

  const AiContext({
    required this.systemPrompt,
    this.documents = const [],
    this.extraContext,
  });

  AiContext copyWith({
    String? systemPrompt,
    List<String>? documents,
    Map<String, dynamic>? extraContext,
  }) {
    return AiContext(
      systemPrompt: systemPrompt ?? this.systemPrompt,
      documents: documents ?? List.unmodifiable(this.documents),
      extraContext: extraContext ?? this.extraContext,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systemPrompt': systemPrompt,
      'documents': documents,
      if (extraContext != null) 'extraContext': extraContext,
    };
  }

  factory AiContext.fromJson(Map<String, dynamic> json) {
    return AiContext(
      systemPrompt: json['systemPrompt'] as String? ?? '',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      extraContext: json['extraContext'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiContext &&
        other.systemPrompt == systemPrompt &&
        listEquals(other.documents, documents) &&
        mapEquals(other.extraContext, extraContext);
  }

  @override
  int get hashCode => systemPrompt.hashCode ^ documents.hashCode ^ extraContext.hashCode;
}
