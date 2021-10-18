import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instant_music/resources/app_strings.dart';
import 'package:instant_music/scenes/authenticate_gate_scene/authenticate_gate_view.dart';
import 'package:instant_music/services/firebase_auth.dart';

class EmailVerifyViewModel extends ChangeNotifier {
  //FIELDS:
  bool isVerified = false;
  bool sentEmail = false;
  late Timer timer;
  late Timer timer2;

  late BuildContext ctx;
  int timerWait = 60;
  String btnText = AppStrings.BTN_RESEND;

  //HELPER:
  final authManager = GetIt.I<FirebaseAuthManager>();
  //INIT:
  EmailVerifyViewModel() {
    authManager.checkEmailVerification();
    startChecking();
  }
  sendEmailVerification() {
    print('send email verification called');
    if (!sentEmail) {
      authManager.sendEmailVerificationEmail();
    }
    sentEmail = true;
    startWaitForReSendEmail();
    notifyListeners();
  }

  startWaitForReSendEmail() {
    int toWait = timerWait;
    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      //if email has been sent
      if (sentEmail) {
        if (toWait >= 1) {
          toWait -= 1;
          btnText = 'Please wait $toWait secs';
          notifyListeners();
        }
        if (toWait <= 0) {
          //check if conditions are met then stop the timer
          sentEmail = false;
          timer2.cancel();
          print('timer2 cancelled');
          btnText = AppStrings.BTN_RESEND;
          notifyListeners();
        }
      }
    });
  }

  void startChecking() {
    //Something of a loop here
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
  }

  Future<void> checkEmailVerified() async {
    print('checking email veridied from emailVerifiedViewModel\n');
    if (authManager.loginState == ApplicationLoginState.loggedIn) {
      await authManager.firebaseUser?.reload();
      if (authManager.firebaseUser!.emailVerified) {
        isVerified = true;
        notifyListeners();
        Navigator.pushReplacementNamed(ctx, AuthenticationGateView.routeName);
        timer.cancel();
        print('timer1 cancelled');
      }
    }
  }
}
