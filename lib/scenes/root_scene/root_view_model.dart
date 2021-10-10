import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:instant_music/services/firebase_auth.dart';

enum ContentToShow { dashboard, onboarding }

class RootViewModel extends ChangeNotifier {
  ContentToShow contentShowing = ContentToShow.onboarding;
  //MARK: Helpers
  final _authManager = GetIt.I<FirebaseAuthManager>();

  //MARK: Init
  RootViewModel() {
    contentShowing = _authManager.hasCompletedOnboarding
        ? ContentToShow.dashboard
        : ContentToShow.onboarding;
  }
}
