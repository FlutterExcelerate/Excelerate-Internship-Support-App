import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String photo;
  final String role;
  final bool isActive;
  final String phone;
  final String cohort;
  final String location;
  final String headline;
  final List<String> skills;
  final String adminDepartment;
  final String adminAccessLevel;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.photo,
    required this.role,
    required this.isActive,
    this.phone = '',
    this.cohort = '',
    this.location = '',
    this.headline = '',
    this.skills = const [],
    this.adminDepartment = '',
    this.adminAccessLevel = 'standard',
    this.createdAt,
    this.lastLogin,
  });

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return AppUser(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photo: data['photo'] ?? '',
      role: data['role'] ?? 'student',
      isActive: data['isActive'] ?? true,
      phone: data['phone'] ?? '',
      cohort: data['cohort'] ?? '',
      location: data['location'] ?? '',
      headline: data['headline'] ?? '',
      skills: List<String>.from(data['skills'] ?? const []),
      adminDepartment: data['adminDepartment'] ?? '',
      adminAccessLevel: data['adminAccessLevel'] ?? 'standard',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photo': photo,
      'role': role,
      'isActive': isActive,
      'phone': phone,
      'cohort': cohort,
      'location': location,
      'headline': headline,
      'skills': skills,
      'adminDepartment': adminDepartment,
      'adminAccessLevel': adminAccessLevel,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }

  AppUser copyWith({
    String? name,
    String? phone,
    String? cohort,
    String? location,
    String? headline,
    List<String>? skills,
    String? adminDepartment,
    String? adminAccessLevel,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email,
      photo: photo,
      role: role,
      isActive: isActive,
      phone: phone ?? this.phone,
      cohort: cohort ?? this.cohort,
      location: location ?? this.location,
      headline: headline ?? this.headline,
      skills: skills ?? this.skills,
      adminDepartment: adminDepartment ?? this.adminDepartment,
      adminAccessLevel: adminAccessLevel ?? this.adminAccessLevel,
      createdAt: createdAt,
      lastLogin: lastLogin,
    );
  }
}
