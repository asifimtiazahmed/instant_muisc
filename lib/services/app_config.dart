import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'firebase_auth.dart';

class AppConfig {
  static Future<void> configure() async {
    WidgetsFlutterBinding.ensureInitialized();
    GestureBinding.instance?.resamplingEnabled =
        true; //Might help with Jank see flutter 1.22 release notes

    // Register your Singletons

    GetIt.I.registerSingleton<FirebaseAuthManager>(
        FirebaseAuthManager()); // It has to be the first because other Singletons might use it.
//    GetIt.I.registerSingleton<AuthManager>(AuthManager());
//    GetIt.I.registerSingleton<DataManager>(DataManager());
//    GetIt.I.registerSingleton<LanguageManager>(LanguageManager());
  }
}
