import 'package:flutter/foundation.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/ai_chat_state.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/persona/ai_persona.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_action.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_message.dart';
import 'dart:convert';

import '../module/ai_module.dart';
import '../services/ai_repository.dart';
import '../core/ai_error.dart';

class AiChatController extends ValueNotifier<AiChatState> {
  final AiRepositoryImpl _repository;
  final String _conversationId;

  AiChatController({
    required AiRepositoryImpl repository,
    required String conversationId,
  })  : _repository = repository,
        _conversationId = conversationId,
        super(const AiChatState());

  AiChatState get state => value;

  Future<void> loadHistory() async {
    await _repository.conversationEngine.loadHistory();
    value = value.copyWith(
      messages: List.unmodifiable(_repository.conversationEngine.getConversationTimeline()),
    );
  }

  Future<void> sendMessage(String text, {required AiPersona persona, bool retry = false}) async {
    if (text.trim().isEmpty ||
        state.status == AiChatStatus.loading ||
        state.status == AiChatStatus.streaming) {
      return;
    }

    final userMessage = AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: text,
      createdAt: DateTime.now(),
    );

    value = value.copyWith(
      status: AiChatStatus.loading,
      messages: retry ? value.messages : [...value.messages, userMessage],
    ).clearError();

    try {
      final result = await _repository.sendMessage(
        conversationId: _conversationId,
        text: text,
        persona: persona,
        retry: retry,
      );

      result.fold(
        (responseMessage) {
          value = value.copyWith(
            status: AiChatStatus.success,
            messages: [...value.messages, responseMessage],
          );
          _processFinalMessage();
        },
        (error) {
          value = value.copyWith(
            status: AiChatStatus.error,
            error: AiError(message: error.message),
          );
        },
      );
    } catch (e) {
      value = value.copyWith(
        status: AiChatStatus.error,
        error: AiError(message: 'Request failed: $e'),
      );
    }
  }

  Future<void> startStream(String text, {required AiPersona persona, bool retry = false}) async {
    if (text.trim().isEmpty ||
        state.status == AiChatStatus.loading ||
        state.status == AiChatStatus.streaming) {
      return;
    }

    final userMessage = AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: text,
      createdAt: DateTime.now(),
    );

    value = value.copyWith(
      status: AiChatStatus.streaming,
      messages: retry ? value.messages : [...value.messages, userMessage],
    ).clearError();

    try {
      final stream = _repository.streamMessage(
        conversationId: _conversationId,
        text: text,
        persona: persona,
        retry: retry,
      );

      List<AiMessage>? mutableMsgs;

      await for (final result in stream) {
        if (state.status != AiChatStatus.streaming) break;

        result.fold(
          (responseMessage) {
            mutableMsgs ??= List<AiMessage>.from(value.messages);

            final existingIdx = mutableMsgs!.indexWhere((m) => m.id == responseMessage.id);
            if (existingIdx >= 0) {
              mutableMsgs![existingIdx] = responseMessage;
            } else {
              mutableMsgs!.add(responseMessage);
            }

            value = value.copyWith(
              status: AiChatStatus.streaming,
              messages: List<AiMessage>.unmodifiable(mutableMsgs!),
            );
          },
          (error) {
            value = value.copyWith(
              status: AiChatStatus.error,
              error: AiError(message: error.message),
            );
          },
        );
      }
    } catch (e) {
      value = value.copyWith(
        status: AiChatStatus.error,
        error: AiError(message: 'Stream failed: $e'),
      );
    } finally {
      if (value.status == AiChatStatus.streaming) {
        value = value.copyWith(status: AiChatStatus.success);
      }
      _processFinalMessage();
    }
  }

  void _processFinalMessage() {
    if (value.messages.isEmpty) return;
    final lastMsg = value.messages.last;
    if (lastMsg.role != 'assistant') return;

    final text = lastMsg.content;
    final regex = RegExp(r'\[ACTION:\s*(\{.*?\})\s*\]', dotAll: true);
    final match = regex.firstMatch(text);

    if (match != null) {
      final jsonStr = match.group(1);
      if (jsonStr != null) {
        try {
          final jsonObj = jsonDecode(jsonStr);
          final action = AiActionRequest.fromJson(jsonObj);

          final cleanText = text.replaceAll(regex, '').trim();
          final updatedMsgs = List<AiMessage>.from(value.messages);
          updatedMsgs[updatedMsgs.length - 1] = lastMsg.copyWith(content: cleanText);

          value = value.copyWith(messages: List<AiMessage>.unmodifiable(updatedMsgs));

          // Emit action after updating state to prevent race conditions
          importAiModuleAndEmit(action);
        } catch (e) {
          debugPrint('Failed to parse AI action: $e');
        }
      }
    }
  }

  void importAiModuleAndEmit(AiActionRequest action) {
    // Requires ai_module.dart import, we will add it to the top.
    AiModule.instance.emitAction(action);
  }

  void cancelPendingRequests() {
    if (state.status == AiChatStatus.loading || state.status == AiChatStatus.streaming) {
      _repository.cancelPendingRequests();
      value = value.copyWith(
        status: AiChatStatus.success,
      );
    }
  }

  void clearConversation() {
    _repository.deleteConversation(_conversationId);
    value = const AiChatState();
  }

  @override
  void dispose() {
    _repository.cancelPendingRequests();
    super.dispose();
  }
}