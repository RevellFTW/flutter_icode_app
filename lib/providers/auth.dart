import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//todo add firebase here
class Auth extends ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth {
    if (_user == null) return false;
    return true;
  }

  Future<void> authenticate(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
    }
  }

  Future<bool> tryLogin() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    _user = user;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
