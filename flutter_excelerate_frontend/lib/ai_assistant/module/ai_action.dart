import 'package:flutter/foundation.dart';

@immutable
class AiActionRequest {
  final String type;
  final Map<String, dynamic> payload;

  const AiActionRequest({
    required this.type,
    this.payload = const {},
  });

  // Known action types
  static const String openPrograms = 'openPrograms';
  static const String openProfile = 'openProfile';
  static const String openNotifications = 'openNotifications';
  static const String openDailyPulse = 'openDailyPulse';
  static const String openProgramDetails = 'openProgramDetails';
  static const String returnToDashboard = 'returnToDashboard';

  // Admin Actions
  static const String openContent = 'openContent';
  static const String openUsers = 'openUsers';
  static const String openSecurity = 'openSecurity';
  static const String openDashboard = 'openDashboard';
  static const String openProgram = 'openProgram';
  static const String searchProgram = 'searchProgram';
  static const String searchUser = 'searchUser';
  static const String searchModule = 'searchModule';
  static const String publishProgram = 'publishProgram';
  static const String createProgram = 'createProgram';
  static const String reviewUsers = 'reviewUsers';

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': payload,
      };

  factory AiActionRequest.fromJson(Map<String, dynamic> json) {
    return AiActionRequest(
      type: json['type'] as String? ?? 'unknown',
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiActionRequest &&
          other.type == type &&
          mapEquals(other.payload, payload);

  @override
  int get hashCode => type.hashCode ^ payload.hashCode;
}