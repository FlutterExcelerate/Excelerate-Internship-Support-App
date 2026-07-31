import 'package:cloud_firestore/cloud_firestore.dart';

class ModuleModel {
  final String id;
  final String title;
  final String summary;
  final String duration;
  final bool isComplete;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const ModuleModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.duration,
    required this.isComplete,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModuleModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return ModuleModel(
      id: doc.id,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      duration: data['duration'] ?? '',
      isComplete: data['isComplete'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'duration': duration,
      'isComplete': isComplete,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
