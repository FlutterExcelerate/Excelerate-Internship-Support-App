import 'package:cloud_firestore/cloud_firestore.dart';

class DailyPulseModel {
  const DailyPulseModel({
    required this.id,
    required this.userId,
    required this.mood,
    required this.moodLabel,
    required this.reflection,
    required this.tags,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final int mood;
  final String moodLabel;
  final String reflection;
  final List<String> tags;
  final Timestamp createdAt;

  factory DailyPulseModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return DailyPulseModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      mood: (data['mood'] as num?)?.toInt() ?? 3,
      moodLabel: data['moodLabel'] ?? 'Steady',
      reflection: data['reflection'] ?? '',
      tags: List<String>.from(data['tags'] ?? const []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mood': mood,
      'moodLabel': moodLabel,
      'reflection': reflection,
      'tags': tags,
      'createdAt': createdAt,
    };
  }
}
