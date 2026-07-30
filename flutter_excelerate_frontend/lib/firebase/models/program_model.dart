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
      color: data['color'] ?? Colors.blue,
      isPublished: data['isPublished'] ?? false,
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'level': level,
      'imageUrl': imageUrl,
      'color': color,
      'isPublished': isPublished,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
