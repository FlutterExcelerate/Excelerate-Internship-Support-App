import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_excelerate_frontend/ai_assistant/core/persona/ai_persona.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_message.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_response.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/prompt/prompt_builder.dart';

import '../context/context_manager.dart';
import '../core/ai_logger.dart';
import '../core/conversation_engine.dart';
import '../core/ai_exceptions.dart';
import '../core/ai_config.dart';

class AiRepositoryImpl {
  final AiConfig _config;
  final HttpClient _client;
  final ContextManager _contextManager;
  final ConversationEngine conversationEngine;
  HttpClientRequest? _activeRequest;

  AiRepositoryImpl({
    required AiConfig config,
    HttpClient? client,
    required ContextManager contextManager,
    required this.conversationEngine,
  }) : _config = config,
       _client = client ?? HttpClient(),
       _contextManager = contextManager {
    AiLogger.log(
      'Gemini client initialized with API key length: ${_config.apiKey.length}',
      tag: 'Init',
    );
  }

  Future<AiResult<AiMessage>> sendMessage({
    required String conversationId,
    required String text,
    required AiPersona persona,
    bool retry = false,
  }) async {
    AiLogger.log('Sending message: $text (retry: )', tag: 'Network');
    try {
      final currentContext = _contextManager.currentContext;

      if (!retry) {
        final userMessage = AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: 'user',
          content: text,
          createdAt: DateTime.now(),
        );
        conversationEngine.addMessage(userMessage);
      }

      if (_config.apiKey.trim().isEmpty) {
        final responseMessage = AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: 'assistant',
          content: 'Gemini API Key not configured.',
          createdAt: DateTime.now(),
        );
        conversationEngine.addMessage(responseMessage);
        return AiResult.success(responseMessage);
      }

      final systemPrompt = PromptBuilder.buildSystemPrompt(
        appContext: currentContext,
        basePrompt: persona.systemPrompt,
      );

      final userPrompt = PromptBuilder.buildUserPrompt(
        userInput: text,
        appContext: currentContext,
      );

      final payload = _buildPayload(systemPrompt, userPrompt);
      final response = await _generateResponse(payload);

      conversationEngine.addMessage(response.message);

      return AiResult.success(response.message);
    } catch (e, st) {
      AiLogger.error('sendMessage failed', e, st);
      return AiResult.failure(
        e is AiException ? e : NetworkException(e.toString()),
      );
    }
  }

  Stream<AiResult<AiMessage>> streamMessage({
    required String conversationId,
    required String text,
    required AiPersona persona,
    bool retry = false,
  }) async* {
    try {
      final currentContext = _contextManager.currentContext;

      if (!retry) {
        final userMessage = AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: 'user',
          content: text,
          createdAt: DateTime.now(),
        );
        conversationEngine.addMessage(userMessage);
      }

      if (_config.apiKey.trim().isEmpty) {
        final responseMessage = AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: 'assistant',
          content: 'Gemini API Key not configured.',
          createdAt: DateTime.now(),
        );
        conversationEngine.addMessage(responseMessage);
        yield AiResult.success(responseMessage);
        return;
      }

      final systemPrompt = PromptBuilder.buildSystemPrompt(
        appContext: currentContext,
        basePrompt: persona.systemPrompt,
      );

      final userPrompt = PromptBuilder.buildUserPrompt(
        userInput: text,
        appContext: currentContext,
      );

      final payload = _buildPayload(systemPrompt, userPrompt);
      final stream = _generateResponseStream(payload);

      String aggregatedText = '';
      AiMessage? lastMessage;

      await for (final response in stream) {
        aggregatedText += response.message.content;
        lastMessage = response.message.copyWith(content: aggregatedText);
        yield AiResult.success(lastMessage);
      }

      if (lastMessage != null) {
        conversationEngine.addMessage(lastMessage);
      }
    } catch (e, st) {
      AiLogger.error('streamMessage failed', e, st);
      yield AiResult.failure(
        e is AiException ? e : NetworkException(e.toString()),
      );
    }
  }

  Future<AiResponse> _generateResponse(Map<String, dynamic> payload) async {
    final uri = Uri.parse(
      '${_config.apiEndpoint}/models/${_config.modelName}:generateContent',
    );

    try {
      final request = await _client
          .postUrl(uri)
          .timeout(const Duration(seconds: 15));
      _activeRequest = request;
      request.headers.contentType = ContentType.json;
      request.headers.set('x-goog-api-key', _config.apiKey);
      request.write(jsonEncode(payload));

      final httpResponse = await request.close().timeout(
        const Duration(seconds: 45),
      );
      final responseBody = await httpResponse.transform(utf8.decoder).join();

      if (httpResponse.statusCode != 200) {
        _handleApiError(httpResponse.statusCode, responseBody);
      }

      return _mapResponse(jsonDecode(responseBody) as Map<String, dynamic>);
    } on TimeoutException catch (e, st) {
      throw NetworkException('Request timed out', stackTrace: st);
    } on SocketException catch (e, st) {
      throw NetworkException('Network error: $e', stackTrace: st);
    } finally {
      _activeRequest = null;
    }
  }

  Stream<AiResponse> _generateResponseStream(
    Map<String, dynamic> payload,
  ) async* {
    final uri = Uri.parse(
      '${_config.apiEndpoint}/models/${_config.modelName}:streamGenerateContent?alt=sse',
    );

    try {
      final request = await _client
          .postUrl(uri)
          .timeout(const Duration(seconds: 15));
      _activeRequest = request;
      request.headers.contentType = ContentType.json;
      request.headers.set('x-goog-api-key', _config.apiKey);
      request.write(jsonEncode(payload));

      final httpResponse = await request.close().timeout(
        const Duration(seconds: 45),
      );
      if (httpResponse.statusCode != 200) {
        _handleApiError(
          httpResponse.statusCode,
          await httpResponse.transform(utf8.decoder).join(),
        );
      }

      final stream = httpResponse
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data.isNotEmpty) {
            yield _mapResponse(jsonDecode(data) as Map<String, dynamic>);
          }
        }
      }
    } on TimeoutException catch (e, st) {
      throw NetworkException('Request timed out', stackTrace: st);
    } on SocketException catch (e, st) {
      throw NetworkException('Network error: $e', stackTrace: st);
    } finally {
      _activeRequest = null;
    }
  }

  void _handleApiError(int statusCode, String responseBody) {
    String message = 'Gemini API Error ($statusCode)';
    try {
      final errorJson = jsonDecode(responseBody);
      if (errorJson['error']?['message'] != null) {
        message = '$message: ${errorJson['error']['message']}';
      }
    } catch (_) {
      message = '$message: $responseBody';
    }
    throw AiServiceException(
      message,
      providerName: 'gemini',
      statusCode: statusCode,
    );
  }

  Map<String, dynamic> _buildPayload(String systemPrompt, String userPrompt) =>
      {
        "system_instruction": {
          "parts": [
            {"text": systemPrompt},
          ],
        },
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": userPrompt},
            ],
          },
        ],
        "generationConfig": {
          "temperature": _config.temperature,
          "maxOutputTokens": _config.maxOutputTokens,
          "topP": _config.topP,
          "topK": _config.topK,
        },
      };

  AiResponse _mapResponse(Map<String, dynamic> rawData) {
    final candidates = rawData['candidates'] as List<dynamic>? ?? [];
    final first = candidates.isNotEmpty
        ? candidates.first as Map<String, dynamic>
        : {};
    final content = first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>? ?? [];
    final text = parts.isNotEmpty ? (parts.first['text'] as String? ?? '') : '';

    return AiResponse(
      message: AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: text,
        createdAt: DateTime.now(),
      ),
      finishReason: first['finishReason'] as String? ?? 'unknown',
      usageStats: rawData['usageMetadata'] as Map<String, dynamic>?,
      rawData: rawData,
    );
  }

  void deleteConversation(String conversationId) {
    conversationEngine.resetConversation();
  }

  void cancelPendingRequests() {
    try {
      _activeRequest?.abort();
      _activeRequest = null;
    } catch (_) {}
  }
}

class AiResult<T> {
  final T? _data;
  final AiException? _error;

  AiResult.success(T data) : _data = data, _error = null;
  AiResult.failure(AiException error) : _data = null, _error = error;

  void fold(Function(T) onSuccess, Function(AiException) onFailure) {
    if (_error != null) {
      onFailure(_error);
    } else {
      onSuccess(_data as T);
    }
  }
}
