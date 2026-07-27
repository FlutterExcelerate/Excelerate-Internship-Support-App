import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_excelerate_frontend/firebase/models/user_role.dart';

class AdminService {
  AdminService._();

  static final AdminService instance = AdminService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _adminConfig =>
      _firestore.collection('admin_config');

  Future<DocumentSnapshot<Map<String, dynamic>>?> getAdminConfig() async {
    try {
      return await _adminConfig.doc('access').get();
    } on FirebaseException catch (e) {
      print("Firestore permission error fetching admin config: ${e.message}");
      return null;
    }
  }

  Future<bool> verifyAdminCode(String enteredCode) async {
    final doc = await getAdminConfig();

    if (doc == null || !doc.exists) {
      return false;
    }

    final data = doc.data()!;

    final bool active = data['active'] ?? false;
    final String code = data['adminCode'] ?? '';

    if (!active) {
      return false;
    }

    return enteredCode.trim() == code;
  }

  Future<void> promoteCurrentUserToAdmin() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is logged in.");
    }

    await _users.doc(user.uid).update({'role': UserRole.admin.name});
  }

  Future<bool> loginAsAdmin(String enteredCode) async {
    try {
      final valid = await verifyAdminCode(enteredCode);

      if (!valid) {
        return false;
      }
      await promoteCurrentUserToAdmin();

      return true;
    } on FirebaseException catch (e) {
      print("Firestore error during admin login: ${e.message}");
      rethrow;
    }
  }
}
