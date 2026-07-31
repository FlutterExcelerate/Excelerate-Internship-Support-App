import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String category;
  final int color;
  final String icon;
  final bool requiresAction;
  final Timestamp createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.color,
    required this.icon,
    required this.requiresAction,
    required this.createdAt,
  });

  factory NotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      category: data['category'] ?? '',
      color: data['color'] ?? 0,
      icon: data['icon'] ?? 'campaign',
      requiresAction: data['requiresAction'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'message': message,
      'category': category,
      'color': color,
      'icon': icon,
      'requiresAction': requiresAction,
      'createdAt': createdAt,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? category,
    int? color,
    String? icon,
    bool? requiresAction,
    Timestamp? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      category: category ?? this.category,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      requiresAction: requiresAction ?? this.requiresAction,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
