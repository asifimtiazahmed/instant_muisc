import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instant_music/scenes/login/login_scene.dart';
import 'package:instant_music/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final FirebaseAuthManager? _authManager = GetIt.I<FirebaseAuthManager>();

    switch (settings.name) {
      case LoginScene.routeName:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: _authManager,
            builder: (context, _) => const LoginScene(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const LoginScene(),
        );
    }
  }
}
