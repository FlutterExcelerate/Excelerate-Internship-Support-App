import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_excelerate_frontend/firebase/service/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Web client ID from Firebase (client_type 3 in google-services.json).
const _kGoogleWebClientId =
    '908192292141-rk59unmab4qdafe25mn44nuf8qq00lld.apps.googleusercontent.com';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository instance = AuthRepository._();

  final _googleSignIn = GoogleSignIn(
    serverClientId: _kGoogleWebClientId,
  );

  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await UserService.instance.createUserIfNotExists(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      debugPrint('Google Sign-In repository error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
