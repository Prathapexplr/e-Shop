import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isAuth = false;
  String? _userId;

  bool get isAuth => _isAuth;
  String? get userId => _userId;

  Future<void> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isAuth = true;
      _userId = userCredential.user?.uid;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isAuth = true;
      _userId = userCredential.user?.uid;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void logout() async {
    await _auth.signOut();
    _isAuth = false;
    _userId = null;
    notifyListeners();
  }
}
