import 'package:flutter/material.dart';
import 'package:instant_music/scenes/login/login_scene.dart';
import 'package:instant_music/scenes/login/login_view_model.dart';
import 'package:provider/provider.dart';

void main() {
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
              primarySwatch: Colors.blue,
            ),
            home: LoginScene(),
          );
        });
  }
}
