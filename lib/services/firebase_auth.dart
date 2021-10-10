import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum ApplicationLoginState {
  loggedIn,
  loggedOut,
  emailAddress,
  register,
  password
}

class FirebaseAuthManager extends ChangeNotifier {
//FIELDS
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  String? _email;
  late AccessToken accessToken;
  bool isFacebookLoggedIn = false;
  bool isGoogleSignedIn = false;
  bool isAppleSignedIn = false;
  bool hasCompletedOnboarding = false;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  //METHODS
  FirebaseAuthManager() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      print('checking if user exists');
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        print('user found');
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        print('user not found');
      }
      notifyListeners();
    });
  }

  Future<void> googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      print('no google user??');
      return;
    }
    _user = googleUser;
    _loginState = ApplicationLoginState.emailAddress;

    final googleAuth = await googleUser.authentication;
    final credential =
        GoogleAuthProvider.credential(accessToken: googleAuth.idToken);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      _loginState = ApplicationLoginState.loggedIn;
    } catch (e) {
      print('could not sign in with goodle creds, and heres why: \n $e');
    }
    notifyListeners();
  }

  //GETTERS
  ApplicationLoginState get loginState => _loginState;
  String? get email => _email;

  //SETTERS
  void setLoginState(ApplicationLoginState x) => _loginState = x;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> verifyEmail(String email,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
        //print('Application state change to password');
      } else {
        _loginState = ApplicationLoginState.register;
        //print('Application state change to register');
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

//THIS METHOD IS CURRENTLY UNUSED, BECAUSE IT WILL REQUIRE A PAID
// MEMBERSHIP TO APPLE, THEN GOTO THE API DPCS FOR THIS PLUGIN AND
// GET THE REMAINING IMPLEMENTATION DONE FROM THERE.
  Future<void> appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print(credential);
  }

  Future<void> facebookLogin() async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      _loginState = ApplicationLoginState.loggedIn;
      print('SUCCESS!! FB Login');
      accessToken = result.accessToken!;
    } else {
      print(result.status);
      print(result.message);
    }
    notifyListeners();
  }

  Future<void> checkFacebookLoggedIn() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
// or FacebookAuth.i.accessToken
    if (accessToken != null) {
      isFacebookLoggedIn = true; // user is logged
    } else {
      isFacebookLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> facebookLogOut() async {
    await FacebookAuth.instance.logOut();
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
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void sighOut() async {
    FirebaseAuth.instance.signOut();

    try {
      await checkFacebookLoggedIn();
      isFacebookLoggedIn ? facebookLogOut() : null;
    } catch (e) {
      print(e);
    }

    _loginState = ApplicationLoginState.loggedOut;
  }
}
