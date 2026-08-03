import 'dart:async';
import 'package:flutter_excelerate_frontend/ai_assistant/context/ai_context_provider.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_conversation.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_message.dart';
import '../services/ai_history_service.dart';

enum ConversationState { initial, active, paused, ended, error }

class ConversationSession {
  final AiConversation conversation;
  final ConversationState state;
  final AiApplicationContext? contextSnapshot;
  final Map<String, dynamic> temporaryMemory;
  final String? summary;

  const ConversationSession({
    required this.conversation,
    this.state = ConversationState.initial,
    this.contextSnapshot,
    this.temporaryMemory = const {},
    this.summary,
  });

  ConversationSession copyWith({
    AiConversation? conversation,
    ConversationState? state,
    AiApplicationContext? contextSnapshot,
    Map<String, dynamic>? temporaryMemory,
    String? summary,
  }) {
    return ConversationSession(
      conversation: conversation ?? this.conversation,
      state: state ?? this.state,
      contextSnapshot: contextSnapshot ?? this.contextSnapshot,
      temporaryMemory: temporaryMemory ?? this.temporaryMemory,
      summary: summary ?? this.summary,
    );
  }
}

class ConversationEngine {
  ConversationSession _session;
  final _sessionController = StreamController<ConversationSession>.broadcast();
  final AiHistoryService _historyService = AiHistoryService();
  bool _historyLoaded = false;

  ConversationEngine({
    required String initialConversationId,
  }) : _session = ConversationSession(
          conversation: AiConversation(
            id: initialConversationId,
            messages: const [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

  Stream<ConversationSession> get sessionStream => _sessionController.stream;
  ConversationSession get currentSession => _session;

  Future<void> loadHistory() async {
    if (_historyLoaded) return;
    final messages = await _historyService.loadHistory(_session.conversation.id);
    if (messages.isNotEmpty) {
      _session = _session.copyWith(
        conversation: _session.conversation.copyWith(
          messages: messages,
          updatedAt: DateTime.now(),
        ),
      );
      _notify();
    }
    _historyLoaded = true;
  }

  void startSession(AiApplicationContext initialContext) {
    _session = _session.copyWith(
      state: ConversationState.active,
      contextSnapshot: initialContext,
    );
    _notify();
  }

  void addMessage(AiMessage message) {
    final updatedMessages = List<AiMessage>.from(_session.conversation.messages)..add(message);

    // Enforce message ordering by timestamp
    updatedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    _session = _session.copyWith(
      conversation: _session.conversation.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      ),
    );
    _historyService.saveHistory(_session.conversation.id, updatedMessages);
    _notify();
  }

  void updateMessage(String messageId, AiMessage updatedMessage) {
    final messages = List<AiMessage>.from(_session.conversation.messages);
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = updatedMessage;
      _session = _session.copyWith(
        conversation: _session.conversation.copyWith(
          messages: messages,
          updatedAt: DateTime.now(),
        ),
      );
      _historyService.saveHistory(_session.conversation.id, messages);
      _notify();
    }
  }

  void updateTemporaryMemory(String key, dynamic value) {
    final newMemory = Map<String, dynamic>.from(_session.temporaryMemory);
    newMemory[key] = value;
    _session = _session.copyWith(temporaryMemory: newMemory);
    _notify();
  }

  void setSummary(String summary) {
    _session = _session.copyWith(summary: summary);
    _notify();
  }

  void setState(ConversationState state) {
    _session = _session.copyWith(state: state);
    _notify();
  }

  void recoverSession(ConversationSession recoveredSession) {
    _session = recoveredSession;
    _notify();
  }

  void resetConversation() {
    _historyService.clearHistory(_session.conversation.id);
    _session = ConversationSession(
      conversation: AiConversation(
        id: _session.conversation.id,
        messages: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      state: ConversationState.initial,
    );
    _notify();
  }

  List<AiMessage> getConversationTimeline() {
    return List.unmodifiable(_session.conversation.messages);
  }

  void _notify() {
    if (!_sessionController.isClosed) {
      _sessionController.add(_session);
    }
  }

  void dispose() {
    _sessionController.close();
  }
}