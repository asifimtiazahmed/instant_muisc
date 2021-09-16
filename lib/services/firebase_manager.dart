import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

enum ApplicationState { loggedIn, loggedOut, emailAddress, register, password }

class FirebaseAuthManager extends ChangeNotifier {
//FIELDS
  ApplicationState _loginState = ApplicationState.loggedOut;
  String? _email;

  //METHODS
  FirebaseAuthManager() {
    init();
  }

  init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationState.loggedIn;
      } else {
        _loginState = ApplicationState.loggedOut;
      }
      notifyListeners();
    });
  }

  //GETTERS
  ApplicationState get loginState => _loginState;
  String? get email => _email;

  void startLoginFlow() {
    _loginState = ApplicationState.emailAddress;
  }

  void verifyEmail(String email,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationState.password;
      } else {
        _loginState = ApplicationState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(String email, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationState.emailAddress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void sighOut() {
    FirebaseAuth.instance.signOut();
    _loginState = ApplicationState.loggedOut;
    notifyListeners();
  }
}
