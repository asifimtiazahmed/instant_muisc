import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instant_music/routes/app_router.dart';
import 'package:instant_music/scenes/authenticate_gate_scene/authenticate_gate_view.dart';
import 'package:instant_music/scenes/login/login_scene.dart';
import 'package:instant_music/scenes/login/login_view_model.dart';
import 'package:instant_music/services/app_config.dart';
import 'package:provider/provider.dart';

void main() async {
  await AppConfig.configure(); //Setup all the get it manager instances here
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LoginViewModel(),
          )
        ],
        builder: (context, child) {
          return MaterialApp(
            title: 'Instant Music',
            theme: ThemeData(
              textTheme: GoogleFonts.quicksandTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AuthenticationGateView.routeName,
            home: const LoginScene(),
          );
        });
  }
}
