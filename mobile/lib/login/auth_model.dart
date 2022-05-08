import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthModel extends ChangeNotifier {
  User _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthModel() {
    final User _currentUser = _auth.currentUser;

    if (_currentUser != null) {
      _user = _currentUser;
      notifyListeners();
    }
  }
  User get user => _user;
  bool get loggedIn => _user != null;
}