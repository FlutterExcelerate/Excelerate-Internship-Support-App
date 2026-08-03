import 'package:flutter/foundation.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_message.dart';
import '../core/ai_error.dart';

enum AiChatStatus { idle, loading, streaming, success, error }

@immutable
class AiChatState {
  final AiChatStatus status;
  final List<AiMessage> messages;
  final AiError? error;

  const AiChatState({
    this.status = AiChatStatus.idle,
    this.messages = const [],
    this.error,
  });

  AiChatState copyWith({
    AiChatStatus? status,
    List<AiMessage>? messages,
    AiError? error,
  }) {
    return AiChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }

  AiChatState clearError() {
    return AiChatState(status: status, messages: messages, error: null);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiChatState &&
        other.status == status &&
        listEquals(other.messages, messages) &&
        other.error == error;
  }

  @override
  int get hashCode => status.hashCode ^ messages.hashCode ^ error.hashCode;
}
