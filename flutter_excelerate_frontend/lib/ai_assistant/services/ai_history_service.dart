import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_message.dart';
import '../core/ai_logger.dart';

class AiHistoryService {
  static const String _keyPrefix = 'ai_history_';

  Future<void> saveHistory(String conversationId, List<AiMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$conversationId';
      final jsonList = messages.map((m) => m.toJson()).toList();
      await prefs.setString(key, jsonEncode(jsonList));
      AiLogger.log('Saved ${messages.length} messages for $conversationId', tag: 'History');
    } catch (e) {
      AiLogger.log('Error saving history: $e', tag: 'History');
    }
  }

  Future<List<AiMessage>> loadHistory(String conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$conversationId';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        AiLogger.log('Loaded ${jsonList.length} messages for $conversationId', tag: 'History');
        return jsonList.map((e) => AiMessage.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      AiLogger.log('Error loading history: $e', tag: 'History');
    }
    return [];
  }

  Future<void> clearHistory(String conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$conversationId';
      await prefs.remove(key);
      AiLogger.log('Cleared history for $conversationId', tag: 'History');
    } catch (e) {
      AiLogger.log('Error clearing history: $e', tag: 'History');
    }
  }
}
