import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instant_music/scenes/email_verification/email_verify_scene.dart';
import 'package:instant_music/scenes/email_verification/email_verify_view_model.dart';
import 'package:instant_music/scenes/login/login_scene.dart';
import 'package:instant_music/scenes/login/login_view_model.dart';
import 'package:instant_music/scenes/root_scene/root_view.dart';
import 'package:instant_music/scenes/root_scene/root_view_model.dart';
import 'package:instant_music/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class AuthenticationGateView extends StatelessWidget {
  static const routeName = '/';

  const AuthenticationGateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authManager =
        GetIt.I<FirebaseAuthManager>(); //context.watch<FirebaseAuthManager>();

    if (authManager.loginState == ApplicationLoginState.loggedIn &&
        authManager.emailVerified == true) {
      print(
          'Authentication gate view, routing to RootViewModel email verified is true');
      return ChangeNotifierProvider(
        create: (context) => RootViewModel(),
        builder: (context, _) => const RootScene(),
      );
    } else if (authManager.loginState == ApplicationLoginState.loggedIn &&
        authManager.emailVerified == false) {
      print(
          'Authentication gate view, routing to RootViewModel email verified is FALSE');
      return ChangeNotifierProvider(
        create: (context) => EmailVerifyViewModel(),
        builder: (context, _) => const EmailVerifyScene(),
      );
    } else {
      print('Authentication gate view, routing to LoginViewModel');
      return ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
        builder: (context, _) => const LoginScene(),
      );
    }
  }
}
