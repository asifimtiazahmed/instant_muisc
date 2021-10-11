import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:instant_music/resources/app_colors.dart';
import 'package:instant_music/resources/app_strings.dart';
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
    authManager.init();
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

  void submit() async {
    //await inputTextOnSubmitted();
    if (authManager.loginState == ApplicationLoginState.loggedIn) {
      print('submit called, trying to log out now');
      logOut();
    } else if (isEmailValid && isPasswordValid) {
      if (authManager.loginState == ApplicationLoginState.register) {
        register();
      } else if (authManager.loginState == ApplicationLoginState.password) {
        login();
      } else {
        await updateUI();
      }
    }

    print(authManager.loginState);
    notifyListeners();
  }

  Future<void> forContinueButton(value) async {
    var isValid = checkEmail(value);
    if (isValid) {
      print('valid');
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
    } else {
      await updateUI();
      print('${authManager.loginState}');
    }
    notifyListeners();
  }

  Future<void> inputTextOnSubmitted() async {
    await validateEmail(emailTextController.text);
    validatePassword(passwordTextController.text);
    verifyPassword(verifyPasswordTextController.text);
    print(
        'current status \n isEmailValid: $isEmailValid\n${emailTextController.text}\n\n isPasswordValid: $isPasswordValid\n${passwordTextController.text}\n\n\n\n now calling update UI');
    await updateUI();
  }

  Future<void> updateUI() async {
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
      buttonFlexValue = 3;
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
      buttonFlexValue = 3;
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
      buttonFlexValue = 3;
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
      buttonFlexValue = 3;
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
      buttonFlexValue = 3;
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
      buttonFlexValue = 3;
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

  bool checkEmail(value) {
    return isEmailValid = EmailValidator.validate(value);
    //print('from check email -> $isEmailValid');
  }

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
  }

  void login() async {
    //  print('login function called');
    if (isEmailValid &&
        isPasswordValid &&
        emailTextController.text.isNotEmpty &&
        passwordTextController.text.isNotEmpty) {
      authManager.signInWithEmailAndPassword(
          emailTextController.text, passwordTextController.text, (e) {
        print(e);
      });
    }
    await reset();
    notifyListeners();
  }

  Future<void> reset() async {
    emailTextController.clear();
    passwordTextController.clear();
    passwordError = '';
    showPasswordVerifyTextField = false;
    showPasswordTextField = false;
    isEmailValid = false;
    isPasswordValid = false;
    await updateUI();

    notifyListeners();
  }

  void viewObscured() {
    (passwordObscured) ? passwordObscured = false : passwordObscured = true;
    notifyListeners();
  }

  void register() {
    print('register function called');
    if (isEmailValid &&
        isPasswordValid &&
        emailTextController.text.isNotEmpty &&
        passwordTextController.text.isNotEmpty) {
      authManager.registerAccount(
          emailTextController.text,
          emailTextController.text.split('@')[0],
          passwordTextController.text, (e) {
        print(e);
      });
    }
    reset();
    notifyListeners();
  }

  void logOut() async {
    if (authManager.loginState == ApplicationLoginState.loggedIn) {
      print('signing out user');
      authManager.sighOut();
      await reset();
      notifyListeners();
    }
  }
}
