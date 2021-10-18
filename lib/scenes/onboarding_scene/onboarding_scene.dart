import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'onboarding_scene_view_model.dart';

class OnboardingScene extends StatelessWidget {
  const OnboardingScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingSceneViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(38.0),
              child: Text('This is the Onboarding Page'),
            ),
          ],
        ),
      ),
    );
  }
}
