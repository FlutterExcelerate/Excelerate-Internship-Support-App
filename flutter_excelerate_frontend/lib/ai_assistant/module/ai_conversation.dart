import 'package:flutter/foundation.dart';
import 'ai_message.dart';

class AiConversation {
  final String id;
  final String? title;
  final List<AiMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const AiConversation({
    required this.id,
    this.title,
    this.messages = const [],
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  AiConversation copyWith({
    String? id,
    String? title,
    List<AiMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return AiConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? List.unmodifiable(this.messages),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AiConversation.fromJson(Map<String, dynamic> json) {
    return AiConversation(
      id: json['id'] as String? ?? '',
      title: json['title'] as String?,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => AiMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiConversation &&
        other.id == id &&
        other.title == title &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        listEquals(other.messages, messages) &&
        mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
