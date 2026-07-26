import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ensureCurrentUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw StateError('User is not authenticated');
    }

    final userRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (snapshot.exists) {
      await userRef.update({'lastLogin': FieldValue.serverTimestamp()});
      return;
    }

    await userRef.set({
      'fullName': user.displayName ?? 'Guest User',
      'email': user.email ?? '',
      'role': 'student',
      'profileImage': user.photoURL ?? '',
      'timezone': '',
      'country': '',
      'skills': <String>[],
      'interests': <String>[],
      'batch': '',
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }
}
