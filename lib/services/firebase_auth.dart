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
  bool isFacebookSignedIn = false;
  bool isGoogleSignedIn = false;
  bool isAppleSignedIn = false;
  bool isEmailSignedIn = false;
  bool isEmailVerified = false;
  bool hasCompletedOnboarding = true;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  late User? firebaseUser;

  //METHODS
  FirebaseAuthManager() {
    init();
  }

  //Get which method was used to signIn
  String whichLoginMethod() {
    if (isEmailSignedIn) {
      print('authManage: signed in with email');
      return 'Email';
    } else if (isGoogleSignedIn) {
      print('authManage: signed in with goolge');
      return 'Google';
    } else if (isFacebookSignedIn) {
      print('authManage: signed in with facebook');
      return 'Facebook';
    } else if (isAppleSignedIn) {
      print('authManage: signed in with apple');
      return 'Apple';
    } else {
      print('authManage: signed in with unknown');
      return 'unknown';
    }
  }

  //Checks to see if the users email was verified or not
  bool get emailVerified => FirebaseAuth.instance.currentUser!.emailVerified;

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      print('checking if user exists');
      if (user != null) {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        _loginState = ApplicationLoginState.loggedIn;
        print('user found $user');
        //Checking if the email has been verified and setting the value
        checkEmailVerification();
        firebaseUser = user;
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
    final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    print('google cred => $credential\n');
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      _loginState = ApplicationLoginState.loggedIn;
      isGoogleSignedIn = true;
      print(_loginState);
      print('${googleUser.displayName}');
    } catch (e) {
      print('could not sign in with goodle creds, and heres why: \n $e');
      isGoogleSignedIn = false;
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
//ALSO NEED TO SAY THAT isAppleSignedIn = true
    print(credential);
  }

  Future<void> facebookLogin() async {
    late LoginResult result;
    try {
      result = await FacebookAuth.instance.login();
    } catch (e) {
      print('could not login to facebook and this is why: \n $e');
    }
    // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      _loginState = ApplicationLoginState.loggedIn;
      isFacebookSignedIn = true;
      print('SUCCESS!! FB Login');
      accessToken = result.accessToken!;
    } else {
      print(result.status);
      print(result.message);
      isFacebookSignedIn = false;
    }
    notifyListeners();
  }

  Future<void> checkFacebookLoggedIn() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
// or FacebookAuth.i.accessToken
    if (accessToken != null) {
      isFacebookSignedIn = true; // user is logged
    } else {
      isFacebookSignedIn = false;
    }
    notifyListeners();
  }

  Future<void> facebookLogOut() async {
    await FacebookAuth.instance.logOut();
    isFacebookSignedIn = false;
  }

  Future<void> signInWithEmailAndPassword(String email, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isEmailSignedIn = true;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      isEmailSignedIn = false;
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void sendEmailVerificationEmail() {
    final cUser = FirebaseAuth.instance.currentUser;
    try {
      print('${cUser?.emailVerified}');
      if (cUser?.emailVerified == false) {
        cUser?.sendEmailVerification();
      }
    } catch (e) {
      print(e);
    }
  }

  void checkEmailVerification() {
    final cUser = FirebaseAuth.instance.currentUser;
    (cUser?.emailVerified == false)
        ? isEmailVerified = false
        : isEmailVerified = true;
    print('email verification status == ${cUser?.emailVerified}');
    //notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      isEmailSignedIn = true;
      //Send for email verfication
      sendEmailVerificationEmail();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      isEmailSignedIn = false;
    }
  }

  Future<void> sighOut() async {
    FirebaseAuth.instance.signOut();
    isGoogleSignedIn = false;
    isFacebookSignedIn = false;
    isAppleSignedIn = false;
    isEmailSignedIn = false;
    try {
      await checkFacebookLoggedIn();
      isFacebookSignedIn ? facebookLogOut() : null;
    } catch (e) {
      print(e);
    }

    _loginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }
}
