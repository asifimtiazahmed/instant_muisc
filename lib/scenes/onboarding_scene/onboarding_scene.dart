import 'package:flutter/material.dart';

class OnboardingScene extends StatelessWidget {
  const OnboardingScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
