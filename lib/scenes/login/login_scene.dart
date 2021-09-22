import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instant_music/resources/app_strings.dart';
import 'package:instant_music/widgets/button.dart';
import 'package:provider/provider.dart';

import 'login_view_model.dart';

class LoginScene extends StatelessWidget {
  LoginScene({Key? key}) : super(key: key);
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Image.asset(AppStrings.SQUARE_LOGO),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(AppStrings.LOGIN_TITLE),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailTextController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ActiveButton(
                        title: 'Continue',
                        onPressed: () => print('button pressed'),
                        customTextColor: Colors.black,
                        backgroundColor: Colors.amber,
                        isCustomBgColor: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              height: 2, width: 50, color: Colors.black38),
                          const SizedBox(width: 20),
                          const Text('Or'),
                          const SizedBox(width: 20),
                          Container(
                              height: 2, width: 50, color: Colors.black38),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
