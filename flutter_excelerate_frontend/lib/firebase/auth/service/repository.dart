import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  AuthRepository._();

  static final instance = AuthRepository._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> initialize() async {
    await _googleSignIn.initialize();
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.authenticate();
      final auth = account.authentication;

      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();

    await _auth.signOut();
  }
}
