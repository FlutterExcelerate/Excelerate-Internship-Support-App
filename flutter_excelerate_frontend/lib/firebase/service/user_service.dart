import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_excelerate_frontend/firebase/models/app_user.dart';

class UserService {
  UserService._();

  static final UserService instance = UserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<void> createUserIfNotExists(User firebaseUser) async {
    final docRef = _users.doc(firebaseUser.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.update({'lastLogin': FieldValue.serverTimestamp()});

      return;
    }

    // New user - create profile
    await docRef.set({
      'uid': firebaseUser.uid,
      'name': firebaseUser.displayName,
      'email': firebaseUser.email,
      'photo': firebaseUser.photoURL,
      'role': 'student',
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    return AppUser.fromFirestore(doc);
  }

  Stream<AppUser?> userStream(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      return AppUser.fromFirestore(doc);
    });
  }
}
