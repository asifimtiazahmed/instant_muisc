import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instant_music/scenes/authenticate_gate_scene/authenticate_gate_view.dart';
import 'package:instant_music/scenes/dashboard/dashboard_scene.dart';
import 'package:instant_music/scenes/dashboard/dashboard_scene_view_model.dart';
import 'package:instant_music/scenes/email_verification/email_verify_scene.dart';
import 'package:instant_music/scenes/email_verification/email_verify_view_model.dart';
import 'package:instant_music/scenes/login/login_scene.dart';
import 'package:instant_music/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final FirebaseAuthManager? _authManager = GetIt.I<FirebaseAuthManager>();

    switch (settings.name) {
      case LoginScene.routeName:
        return MaterialPageRoute(
          builder: (context) => const LoginScene(),
        );
      case AuthenticationGateView.routeName:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: _authManager,
            builder: (context, _) => const AuthenticationGateView(),
          ),
        );
      case EmailVerifyScene.routeName:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: EmailVerifyViewModel(),
            builder: (context, _) => const EmailVerifyScene(),
          ),
        );
      case DashboardScene.routeName:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: DashboardViewModel(),
            builder: (context, _) => const DashboardScene(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: _authManager,
            builder: (context, _) => const AuthenticationGateView(),
          ),
        );
    }
  }
}
