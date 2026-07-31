import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProgramModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final String level;
  final String imageUrl;
  final String mentorName;
  final String mentorEmail;
  final String applicationDeadline;
  final String schedule;
  final int capacity;
  final List<String> outcomes;
  final List<String> prerequisites;
  final int color;
  final bool isPublished;
  final String createdBy;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.level,
    required this.imageUrl,
    this.mentorName = '',
    this.mentorEmail = '',
    this.applicationDeadline = '',
    this.schedule = '',
    this.capacity = 0,
    this.outcomes = const [],
    this.prerequisites = const [],
    required this.color,
    required this.isPublished,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgramModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return ProgramModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      duration: data['duration'] ?? '',
      level: data['level'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      mentorName: data['mentorName'] ?? '',
      mentorEmail: data['mentorEmail'] ?? '',
      applicationDeadline: data['applicationDeadline'] ?? '',
      schedule: data['schedule'] ?? '',
      capacity: (data['capacity'] as num?)?.toInt() ?? 0,
      outcomes: List<String>.from(data['outcomes'] ?? const []),
      prerequisites: List<String>.from(data['prerequisites'] ?? const []),
      color: (data['color'] as num?)?.toInt() ?? Colors.blue.toARGB32(),
      isPublished: data['isPublished'] ?? false,
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Color get colorValue => Color(color);
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'level': level,
      'imageUrl': imageUrl,
      'mentorName': mentorName,
      'mentorEmail': mentorEmail,
      'applicationDeadline': applicationDeadline,
      'schedule': schedule,
      'capacity': capacity,
      'outcomes': outcomes,
      'prerequisites': prerequisites,
      'color': color,
      'isPublished': isPublished,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
