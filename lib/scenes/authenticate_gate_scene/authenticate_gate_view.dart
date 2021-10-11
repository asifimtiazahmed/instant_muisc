import 'package:flutter/material.dart';
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
    final vm = context.watch<FirebaseAuthManager>();

    if (vm.loginState == ApplicationLoginState.loggedIn) {
      return ChangeNotifierProvider(
        create: (context) => RootViewModel(),
        builder: (context, _) => const RootScene(),
      );
    } else {
      return ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
        builder: (context, _) => const LoginScene(),
      );
    }
  }
}
