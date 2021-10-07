import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instant_music/resources/app_assets.dart';
import 'package:instant_music/resources/app_colors.dart';
import 'package:instant_music/resources/app_strings.dart';
import 'package:instant_music/resources/app_styles.dart';
import 'package:instant_music/scenes/login/widgets/social_button.dart';
import 'package:instant_music/widgets/button.dart';
import 'package:provider/provider.dart';

import 'login_view_model.dart';

class LoginScene extends StatelessWidget {
  const LoginScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrSize = MediaQuery.of(context).size;
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Expanded(
                    flex: vm.tagLineFlexValue,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //IMAGE LOGO
                        Padding(
                          padding: EdgeInsets.only(
                              top: scrSize.height * 0.1,
                              bottom: scrSize.height * 0.02),
                          child: Center(
                            child: SizedBox(
                              width: 166,
                              height: 48,
                              child: Image.asset(AppAssets.HORIZONTAL_LOGO),
                            ),
                          ),
                        ),
                        //TEXT TAG LINE
                        if (vm.showTagMesssage)
                          SizedBox(
                            height: 54,
                            width: 232,
                            child: Text(
                              AppStrings.TAG_LINE,
                              style: AppStyles.bodyText
                                  .copyWith(color: AppColors.text, height: 1.6),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: vm.buttonFlexValue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: scrSize.height * 0.05),
                          child: Text(
                            AppStrings.LOGIN_TITLE,
                            style: AppStyles.subTitle
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vm.emailTextController,
                          onSubmitted: (value) {
                            vm.inputTextOnSubmitted();
                            // vm.validateEmail(value);
                            // vm.updateUI();
                          },
                          decoration: InputDecoration(
                            hintText: AppStrings.EMAIL,
                            hintStyle: const TextStyle(
                                color: AppColors.inactiveBtnText),
                            errorText:
                                (vm.errorText == '') ? null : vm.errorText,
                            errorStyle: const TextStyle(
                              color: AppColors.accentBusy,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: vm.showPasswordTextField,
                          child: TextField(
                            //PASSWORD
                            controller: vm.passwordTextController,
                            onSubmitted: (_) {
                              vm.inputTextOnSubmitted();
                            },
                            onChanged: (_) {
                              vm.inputTextOnSubmitted();
                            },
                            decoration: InputDecoration(
                              hintText: AppStrings.PASSWORD,
                              hintStyle: const TextStyle(
                                  color: AppColors.inactiveBtnText),
                              errorText: (vm.passwordError == '')
                                  ? null
                                  : vm.passwordError,
                              errorStyle: const TextStyle(
                                color: AppColors.accentBusy,
                              ),
                            ),
                            obscureText: true,
                          ),
                        ),
                        Visibility(
                          visible: vm.showPasswordVerifyTextField,
                          child: TextField(
                            controller: vm.verifyPasswordTextController,
                            onSubmitted: (_) {
                              vm.inputTextOnSubmitted();
                            },
                            onChanged: (_) {
                              vm.inputTextOnSubmitted();
                            },
                            decoration: InputDecoration(
                              hintText: AppStrings.RE_PASSWORD,
                              hintStyle: const TextStyle(
                                  color: AppColors.inactiveBtnText),
                              errorText:
                                  (vm.verifyPasswordTextController.text == '')
                                      ? null
                                      : vm.verifyPasswordTextFieldError,
                              errorStyle: const TextStyle(
                                color: AppColors.accentBusy,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ActiveButton(
                          title: vm.btnTitle,
                          width: 225,
                          onPressed: () {
                            vm.inputTextOnSubmitted();
                          },
                          customTextColor: vm.btnTextColor,
                          backgroundColor: vm.btnBackgroundColor,
                          isCustomBgColor: true,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 1,
                                width: scrSize.width * 0.30,
                                color: Colors.black38),
                            SizedBox(width: scrSize.width * 0.05),
                            const Text(AppStrings.OR),
                            SizedBox(width: scrSize.width * 0.05),
                            Container(
                                height: 1,
                                width: scrSize.width * 0.30,
                                color: Colors.black38),
                          ],
                        ),
                        const SizedBox(height: 30),
                        //Google Sign-in Button
                        SocialButton(
                          imageAsset: AppAssets.GOOGLE_LOGO,
                          onTap: () {},
                          text: AppStrings.SIGN_IN_GOOGLE,
                        ),
                        const SizedBox(height: 20),
                        //Facebook Sign-in Button
                        SocialButton(
                          imageAsset: AppAssets.FACEBOOK_LOGO,
                          onTap: () async {
                            print('trying to login to fb');
                            await vm.facebookSignIn();
                          },
                          text: AppStrings.SIGN_IN_FACEBOOK,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
