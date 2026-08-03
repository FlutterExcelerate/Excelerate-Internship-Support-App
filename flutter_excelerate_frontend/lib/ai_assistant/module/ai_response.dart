import 'package:flutter/foundation.dart';
import 'ai_message.dart';

class AiResponse {
  final AiMessage message;
  final String finishReason;
  final Map<String, dynamic>? usageStats;
  final Map<String, dynamic>? rawData;

  const AiResponse({
    required this.message,
    this.finishReason = 'unknown',
    this.usageStats,
    this.rawData,
  });

  AiResponse copyWith({
    AiMessage? message,
    String? finishReason,
    Map<String, dynamic>? usageStats,
    Map<String, dynamic>? rawData,
  }) {
    return AiResponse(
      message: message ?? this.message,
      finishReason: finishReason ?? this.finishReason,
      usageStats: usageStats ?? this.usageStats,
      rawData: rawData ?? this.rawData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message.toJson(),
      'finishReason': finishReason,
      if (usageStats != null) 'usageStats': usageStats,
      if (rawData != null) 'rawData': rawData,
    };
  }

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      message: AiMessage.fromJson(json['message'] as Map<String, dynamic>),
      finishReason: json['finishReason'] as String? ?? 'unknown',
      usageStats: json['usageStats'] as Map<String, dynamic>?,
      rawData: json['rawData'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiResponse &&
        other.message == message &&
        other.finishReason == finishReason &&
        mapEquals(other.usageStats, usageStats) &&
        mapEquals(other.rawData, rawData);
  }

  @override
  int get hashCode => message.hashCode ^ finishReason.hashCode;
}
