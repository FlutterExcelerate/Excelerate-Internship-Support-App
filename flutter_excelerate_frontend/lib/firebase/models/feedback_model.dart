import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String uid;
  final String userName;
  final String userEmail;
  final int? rating;
  final String message;
  final String category;
  final Timestamp createdAt;

  const FeedbackModel({
    required this.id,
    required this.uid,
    required this.userName,
    required this.userEmail,
    this.rating,
    required this.message,
    required this.category,
    required this.createdAt,
  });

  factory FeedbackModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return FeedbackModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      rating: data['rating'] ?? 0,
      message: data['message'] ?? '',
      category: data['category'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'userName': userName,
      'userEmail': userEmail,
      'rating': rating,
      'message': message,
      'category': category,
      'createdAt': createdAt,
    };
  }

  FeedbackModel copyWith({
    String? id,
    String? uid,
    String? userName,
    String? userEmail,
    int? rating,
    String? title,
    String? message,
    String? category,
    String? status,
    Timestamp? createdAt,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      rating: rating ?? this.rating,
      message: message ?? this.message,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
