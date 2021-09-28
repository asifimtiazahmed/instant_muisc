import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instant_music/resources/app_colors.dart';
import 'package:instant_music/resources/app_strings.dart';
import 'package:instant_music/resources/app_styles.dart';
import 'package:instant_music/widgets/button.dart';
import 'package:provider/provider.dart';

import 'login_view_model.dart';

class LoginScene extends StatelessWidget {
  LoginScene({Key? key}) : super(key: key);
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.1, bottom: 0.05),
                        child: Center(
                          child: Container(
                            width: 166,
                            height: 48,
                            child: Image.asset(AppStrings.HORIZONTAL_LOGO),
                          ),
                        ),
                      ),
                      Container(
                          height: 54,
                          width: 232,
                          child: Text(
                            AppStrings.TAG_LINE,
                            style: AppStyles.bodyText
                                .copyWith(color: AppColors.text),
                            maxLines: 2,
                          )),
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
