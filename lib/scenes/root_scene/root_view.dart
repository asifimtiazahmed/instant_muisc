import 'package:flutter/material.dart';
import 'package:instant_music/scenes/dashboard/dashboard_scene.dart';
import 'package:instant_music/scenes/dashboard/dashboard_scene_view_model.dart';
import 'package:instant_music/scenes/onboarding_scene/onboarding_scene.dart';
import 'package:instant_music/scenes/onboarding_scene/onboarding_scene_view_model.dart';
import 'package:instant_music/scenes/root_scene/root_view_model.dart';
import 'package:provider/provider.dart';

class RootScene extends StatelessWidget {
  const RootScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RootViewModel>();

    if (vm.contentShowing == ContentToShow.dashboard) {
      return ChangeNotifierProvider(
        create: (_) => DashboardViewModel(),
        builder: (_, __) => const DashboardScene(),
      );
    } else if (vm.contentShowing == ContentToShow.onboarding) {
      return ChangeNotifierProvider(
        create: (_) => OnboardingSceneViewModel(),
        builder: (_, __) => const OnboardingScene(),
      );
    } else {
      return const Text("Unsupported");
    }
  }
}
