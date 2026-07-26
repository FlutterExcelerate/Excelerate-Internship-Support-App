import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/auth/service/repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> signInWithGoogle() async {
    final credential = await signInWithGoogleCredential();

    return credential != null;
  }

  Future<UserCredential?> signInWithGoogleCredential() async {
    _isLoading = true;
    notifyListeners();

    try {
      final credential = await _repository.signInWithGoogle();

      _isLoading = false;
      notifyListeners();

      return credential;
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      rethrow;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }
}
