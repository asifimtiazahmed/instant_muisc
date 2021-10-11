import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'email_verify_view_model.dart';

class EmailVerifyScene extends StatelessWidget {
  static const String routeName = 'emailVerifyScene';

  const EmailVerifyScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailVerifyViewModel>(builder: (context, vm, child) {
      return const Scaffold(
        body: SafeArea(
          child: Text('email veirfy model'),
        ),
      );
    });
  }
}
