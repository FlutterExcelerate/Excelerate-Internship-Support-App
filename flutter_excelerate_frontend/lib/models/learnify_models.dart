import 'package:flutter/material.dart';

class CourseSummary {
  const CourseSummary({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final double progress;
  final IconData icon;
  final Color accent;
}

class Program {
  const Program({
    required this.title,
    required this.category,
    required this.description,
    required this.duration,
    required this.level,
    required this.progress,
    required this.modules,
    required this.color,
  });

  final String title;
  final String category;
  final String description;
  final String duration;
  final String level;
  final double progress;
  final List<ProgramModule> modules;
  final Color color;
}

class ProgramModule {
  const ProgramModule({
    required this.title,
    required this.summary,
    required this.duration,
    required this.isComplete,
  });

  final String title;
  final String summary;
  final String duration;
  final bool isComplete;
}

class LearnifyNotification {
  const LearnifyNotification({
    required this.title,
    required this.message,
    required this.category,
    required this.time,
    required this.icon,
    required this.color,
    this.requiresAction = false,
  });

  final String title;
  final String message;
  final String category;
  final String time;
  final IconData icon;
  final Color color;
  final bool requiresAction;
}
