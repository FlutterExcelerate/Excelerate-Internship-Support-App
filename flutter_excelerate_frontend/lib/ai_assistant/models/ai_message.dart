import 'package:flutter/foundation.dart';

class AiMessage {
  final String id;
  final String role;
  final String content;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const AiMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.metadata,
  });

  AiMessage copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return AiMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiMessage &&
        other.id == id &&
        other.role == role &&
        other.content == content &&
        other.createdAt == createdAt &&
        mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return id.hashCode ^ 
           role.hashCode ^ 
           content.hashCode ^ 
           createdAt.hashCode;
  }
}
