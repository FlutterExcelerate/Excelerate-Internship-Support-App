import 'package:flutter/material.dart';

class AdminUserActivity {
  const AdminUserActivity({
    required this.user,
    required this.action,
    required this.status,
    required this.time,
    required this.color,
  });

  final String user;
  final String action;
  final String status;
  final String time;
  final Color color;
}
