import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:instant_music/resources/app_colors.dart';
import 'package:instant_music/resources/app_strings.dart';
import 'package:instant_music/scenes/email_verification/email_verify_scene.dart';
import 'package:instant_music/scenes/root_scene/root_view.dart';
import 'package:instant_music/services/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class LoginViewModel extends ChangeNotifier {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final verifyPasswordTextController = TextEditingController();
  String passwordError = '';
  String verifyPasswordTextFieldError = '';
  String errorText = '';
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isVeryfyPasswordObscured = true;
  bool passwordObscured = true;
  bool isVeryPasswordValid =
      false; //THIS SHOULD NOT BE USED FOR ANY DECISION MAKING IN TERMS OF METHOD
  Color btnBackgroundColor = AppColors.secondaryInactive;
  Color btnTextColor = AppColors.inactiveBtnText;
  String btnTitle = AppStrings.BTN_CONTINUE;
  bool showTagMesssage = true;
  int tagLineFlexValue = 1;
  int buttonFlexValue = 2;
  bool showPasswordTextField = false;
  bool showPasswordVerifyTextField = false;

  final authManager = GetIt.I<FirebaseAuthManager>();
  LoginViewModel() {
    print('auth manager initiated');
    authManager.init();
    print('delaying 2 seconds');
    initialUIUpdate();
  }
  initialUIUpdate() async {
    print('calling update UI');
    await updateUI();
  }

  @override
  dispose() {
    super.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    verifyPasswordTextController.dispose();
  }

  Color getBackgroundColor() {
    if (authManager.loginState == ApplicationLoginState.emailAddress) {
      btnBackgroundColor = AppColors.secondaryInactive;
    }
    if (authManager.loginState == ApplicationLoginState.password) {
      btnBackgroundColor = AppColors.secondaryInactive;
    }
    if (authManager.loginState == ApplicationLoginState.password &&
        isPasswordValid) {
      btnBackgroundColor = AppColors.primary;
    }
    //notifyListeners();
    return btnBackgroundColor;
  }

  void submit(BuildContext context) async {
    //await inputTextOnSubmitted();
    if (authManager.loginState == ApplicationLoginState.loggedIn) {
      print('submit called, trying to log out now');
      logOut();
    } else if (isEmailValid && isPasswordValid) {
      if (authManager.loginState == ApplicationLoginState.register) {
        register(context);
        await updateUI();
      } else if (authManager.loginState == ApplicationLoginState.password) {
        login(context);
        await updateUI();
      } else {
        await updateUI();
      }
      await updateUI();
    }

    print(authManager.loginState);
    notifyListeners();
  }

  Future<void> forContinueButton(value) async {
    var isValid = checkEmail(value);
    if (isValid) {
      await authManager.verifyEmail(value, (e) {});
      if (authManager.loginState == ApplicationLoginState.password) {
        btnBackgroundColor = AppColors.primary;
        btnTextColor = AppColors.btnText;
        btnTitle = AppStrings.BTN_LOGIN;
      } else {
        btnBackgroundColor = AppColors.primary;
        btnTextColor = AppColors.btnText;
        btnTitle = AppStrings.BTN_SIGNUP;
      }
    } else if (emailTextController.text == '') {
      reset();
    } else {
      await updateUI();
      print('${authManager.loginState}');
    }
    notifyListeners();
  }

  Future<void> inputTextOnSubmitted() async {
    await validateEmail(emailTextController.text);
    validatePassword(passwordTextController.text);
    if (authManager.loginState != ApplicationLoginState.password) {
      verifyPassword(verifyPasswordTextController.text);
    }
    print(
        'current status \n isEmailValid: $isEmailValid\n${emailTextController.text}\n\n isPasswordValid: $isPasswordValid\n${passwordTextController.text}\n\n\n\n now calling update UI');
    await updateUI();
  }

  Future<void> updateUI() async {
    print(
        'UI Update called, the current login state is: ${authManager.loginState}');
    //This method should update everything
    //Initial state
    if (authManager.loginState == ApplicationLoginState.emailAddress ||
        authManager.loginState == ApplicationLoginState.loggedOut) {
      //print('initial state + ${authManager.loginState}');
      showTagMesssage = true;
      tagLineFlexValue = 1;
      buttonFlexValue = 2;
      btnBackgroundColor = AppColors.secondaryInactive;
      btnTextColor = AppColors.inactiveBtnText;
      btnTitle = AppStrings.BTN_CONTINUE;
      showPasswordTextField = false;
      showPasswordVerifyTextField = false;
      //Typed in Email (regcoglized as a past user) but not password or Password not valid
    }
    if (authManager.loginState == ApplicationLoginState.password &&
        !isPasswordValid) {
      // print(
      //     'Typed in Email (regcoglized as a past user) but not password or Password not valid  + ${authManager.loginState}');
      showTagMesssage = false;
      tagLineFlexValue = 1;
      buttonFlexValue = 4;
      btnBackgroundColor = AppColors.secondaryInactive;
      btnTextColor = AppColors.inactiveBtnText;
      btnTitle = AppStrings.BTN_LOGIN;
      showPasswordTextField = true;
      showPasswordVerifyTextField = false;
      //User recognized, new need a valid passowrd
    }
    if (authManager.loginState == ApplicationLoginState.password &&
        isPasswordValid &&
        isEmailValid) {
      // print(
      //     'User recognized, new need a valid passowrd  + ${authManager.loginState}');
      showTagMesssage = false;
      tagLineFlexValue = 1;
      buttonFlexValue = 4;
      btnBackgroundColor =
          (isEmailValid && isPasswordValid && isVeryPasswordValid)
              ? AppColors.primary
              : AppColors.secondaryInactive;
      btnTextColor = (isEmailValid && isPasswordValid)
          ? AppColors.btnText
          : AppColors.inactiveBtnText;
      btnTitle = AppStrings.BTN_LOGIN;
      showPasswordVerifyTextField = false;
    }
    if (authManager.loginState == ApplicationLoginState.register) {
      // print('just application state is register + ${authManager.loginState}');
      showTagMesssage = false;
      tagLineFlexValue = 1;
      buttonFlexValue = 4;
      btnBackgroundColor = (isEmailValid && isPasswordValid)
          ? AppColors.primary
          : AppColors.secondaryInactive;
      btnTextColor = (isEmailValid && isPasswordValid)
          ? AppColors.btnText
          : AppColors.inactiveBtnText;
      btnTitle = AppStrings.BTN_SIGNUP;
      showPasswordTextField = true;
      showPasswordVerifyTextField = true;
      //If user recognized and need to put in password
    }
    if (authManager.loginState == ApplicationLoginState.password) {
      showTagMesssage = false;
      tagLineFlexValue = 1;
      buttonFlexValue = 4;
      btnBackgroundColor = (isEmailValid && isPasswordValid)
          ? AppColors.primary
          : AppColors.secondaryInactive;
      btnTextColor = (isEmailValid && isPasswordValid)
          ? AppColors.btnText
          : AppColors.inactiveBtnText;
      btnTitle = AppStrings.BTN_LOGIN;
      showPasswordTextField = true;
      showPasswordVerifyTextField = false;
    }
    if (authManager.loginState == ApplicationLoginState.register &&
        !isEmailValid) {
      tagLineFlexValue = 1;
      buttonFlexValue = 4;
      //print('register + valid email + ${authManager.loginState}');
      showPasswordTextField = false;
      showPasswordVerifyTextField = false;
      btnBackgroundColor =
          (isEmailValid && isPasswordValid && isVeryPasswordValid)
              ? AppColors.primary
              : AppColors.secondaryInactive;
      btnTextColor = (isEmailValid && isPasswordValid)
          ? AppColors.btnText
          : AppColors.inactiveBtnText;
      btnTitle = AppStrings.BTN_SIGNUP;
    }
    //User Known and login
    if (authManager.loginState == ApplicationLoginState.register &&
        isEmailValid) {
      showTagMesssage = false;
      tagLineFlexValue = 1;
      buttonFlexValue = 4;
      btnBackgroundColor = (isEmailValid && isPasswordValid)
          ? AppColors.primary
          : AppColors.secondaryInactive;
      btnTextColor = (isEmailValid && isPasswordValid)
          ? AppColors.btnText
          : AppColors.inactiveBtnText;
      btnTitle = AppStrings.BTN_SIGNUP;
      showPasswordTextField = true;
      showPasswordVerifyTextField = true;
    }
    if (authManager.loginState == ApplicationLoginState.loggedIn) {
      btnTitle = AppStrings.BTN_LOGOUT;
      btnBackgroundColor = AppColors.primary;
      btnTextColor = AppColors.btnText;
      tagLineFlexValue = 1;
      buttonFlexValue = 2;
      showPasswordTextField = false;
    }
    notifyListeners();
  }

//This method is verifying the first password field
  void validatePassword(value) {
    if (value == null || value == '') {
      passwordError = AppStrings.PASSWORD_CANNOT_BLANK;
    } else if (value.length < 6) {
      passwordError = AppStrings.PASSWORD_MUST_BE_SIX;
    } else if (value.length >= 6) {
      passwordError = '';
      isPasswordValid = true;
    }
    notifyListeners();
  }

//This method is for the verifying of secondary password field
  void verifyPassword(value) {
    if (value == null || value == '') {
      verifyPasswordTextFieldError = AppStrings.PASSWORD_CANNOT_BLANK;
      isPasswordValid = false;
    } else if (value.length < 6) {
      verifyPasswordTextFieldError = AppStrings.PASSWORD_MUST_BE_SIX;
      isPasswordValid = false;
    } else if (value != passwordTextController.text) {
      verifyPasswordTextFieldError = AppStrings.PASSWORD_MUST_MATCH;
      isPasswordValid = false;
    } else if (value == passwordTextController.text && value.length >= 6) {
      verifyPasswordTextFieldError = '';
      isPasswordValid = true;
      isVeryPasswordValid = true;
    }
    notifyListeners();
  }

// This chceks the TextField input form to see if the email is a valid email format
  bool checkEmail(value) {
    return isEmailValid = EmailValidator.validate(value);
    //print('from check email -> $isEmailValid');
  }

  //This also checks the TextField input form to see if the email is valid using regExpt
  Future<void> validateEmail(value) async {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern.toString());
    if (value == null || value == '') {
      errorText = 'The email field cannot be empty';
      isEmailValid = false;
      //authManager.setLoginState(ApplicationLoginState.emailAddress);
    } else if (!regex.hasMatch(value) || value == null) {
      errorText = 'Please enter a valid email address';
      isEmailValid = false;
      //  authManager.setLoginState(ApplicationLoginState.emailAddress);
      // } else if (authManager.loginState == ApplicationLoginState.password) {
      //   errorText = 'User with that email already exists';
      //   isEmailValid = false;
      //  authManager.setLoginState(ApplicationLoginState.emailAddress);
    } else if (regex.hasMatch(value) && checkEmail(value)) {
      errorText = '';
      isEmailValid = true;
      //print('verify email called from validateEmail method');
      await authManager.verifyEmail(value, (e) {
        print(e);
      });
    }
    notifyListeners();
  }

  Future<void> facebookSignIn() async {
    await authManager.facebookLogin();
  }

  Future<void> googleSignIn() async {
    await authManager.googleLogin();
    notifyListeners();
  }

//this method logs in existing user, and checks if the email has been validated or not
// if not it will send you to the email validation page
  void login(BuildContext context) async {
    //  print('login function called');
    if (isEmailValid &&
        isPasswordValid &&
        emailTextController.text.isNotEmpty &&
        passwordTextController.text.isNotEmpty) {
      await authManager.signInWithEmailAndPassword(
          emailTextController.text, passwordTextController.text, (e) {
        print(e);
      });
    }
    print('logged in now resetting from login function');
    await reset();
    nextRoute(context);
  }

  Future<void> reset() async {
    emailTextController.clear();
    passwordTextController.clear();
    passwordError = '';
    showPasswordVerifyTextField = false;
    showPasswordTextField = false;
    isEmailValid = false;
    isPasswordValid = false;
    showTagMesssage = true;
    await updateUI();

    //notifyListeners();
  }

  void viewObscured(String whichField) {
    if (whichField == 'password') {
      (passwordObscured) ? passwordObscured = false : passwordObscured = true;
    } else if (whichField == 'verifyPassword') {
      (isVeryfyPasswordObscured)
          ? isVeryfyPasswordObscured = false
          : isVeryfyPasswordObscured = true;
    }
    notifyListeners();
  }

  void register(BuildContext context) async {
    print('register function called');
    if (isEmailValid &&
        isPasswordValid &&
        emailTextController.text.isNotEmpty &&
        passwordTextController.text.isNotEmpty) {
      await authManager.registerAccount(
          emailTextController.text,
          emailTextController.text.split('@')[0],
          passwordTextController.text, (e) {
        print(e);
      });
    }
    await reset();
    nextRoute(context);
  }

  //This method will see if the method that was logged in was
  //using plain email, and if so, the if the email has not been
  // verified then it will send to email verification page
  //else send to RootAccess
  void nextRoute(BuildContext context) {
    print('nextRoute called');
    if (authManager.loginState == ApplicationLoginState.loggedIn &&
        authManager.whichLoginMethod() != 'Email') {
      print('not email');
      Navigator.pushNamed(context, RootScene.routeName);
    } else if (authManager.loginState == ApplicationLoginState.loggedIn &&
        authManager.whichLoginMethod() == 'Email' &&
        !authManager.emailVerified) {
      print('email');
      Navigator.pushNamed(context, EmailVerifyScene.routeName);
    }
  }

  void logOut() async {
    if (authManager.loginState == ApplicationLoginState.loggedIn) {
      print('signing out user');
      await authManager.sighOut();
      await reset();
      await updateUI();
    }
  }
}
