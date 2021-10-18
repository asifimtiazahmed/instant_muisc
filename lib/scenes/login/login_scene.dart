import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instant_music/resources/app_assets.dart';
import 'package:instant_music/resources/app_colors.dart';
import 'package:instant_music/resources/app_strings.dart';
import 'package:instant_music/resources/app_styles.dart';
import 'package:instant_music/scenes/login/widgets/social_button.dart';
import 'package:instant_music/services/firebase_auth.dart';
import 'package:instant_music/widgets/button.dart';
import 'package:provider/provider.dart';
import 'login_view_model.dart';

class LoginScene extends StatelessWidget {
  const LoginScene({Key? key}) : super(key: key);
  static const String routeName = 'loginScene';

  @override
  Widget build(BuildContext context) {
    final scrSize = MediaQuery.of(context).size;
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) {
        vm.ctx =
            context; //sending off the context copy for routing through the view model
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    //mainAxisSize: ,
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
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: vm.showTagMesssage ? 166 : 166 * 1.30,
                                  height: vm.showTagMesssage ? 48 : 48 * 1.30,
                                  child: Image.asset(
                                    AppAssets.HORIZONTAL_LOGO,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            //TEXT TAG LINE
                            if (vm.showTagMesssage)
                              SizedBox(
                                height: 100,
                                width: 232,
                                child: Text(
                                  AppStrings.TAG_LINE,
                                  style: AppStyles.bodyText.copyWith(
                                      color: AppColors.text, height: 1.6),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
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
                            if (vm.showTagMesssage)
                              Padding(
                                padding:
                                    EdgeInsets.only(top: scrSize.height * 0.05),
                                child: Text(
                                  AppStrings.LOGIN_TITLE,
                                  style: AppStyles.subTitle
                                      .copyWith(color: AppColors.primary),
                                ),
                              ),
                            const SizedBox(height: 10),
                            //EMAIL
                            if (vm.authManager.loginState !=
                                ApplicationLoginState.loggedIn)
                              TextField(
                                autocorrect: false,
                                onChanged: (value) async {
                                  await vm.forContinueButton(value);
                                },
                                controller: vm.emailTextController,
                                onSubmitted: (value) {
                                  vm.inputTextOnSubmitted();
                                  // vm.validateEmail(value);
                                  // vm.updateUI();
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: AppStrings.EMAIL,
                                  hintStyle: const TextStyle(
                                      color: AppColors.inactiveBtnText),
                                  errorText: (vm.errorText == '')
                                      ? null
                                      : vm.errorText,
                                  errorStyle: const TextStyle(
                                    color: AppColors.accentBusy,
                                  ),
                                ),
                              ),
                            //PASSWORD
                            Visibility(
                              visible: vm.showPasswordTextField,
                              child: TextField(
                                //PASSWORD
                                autocorrect: false,
                                controller: vm.passwordTextController,
                                onSubmitted: (_) {
                                  vm.inputTextOnSubmitted();
                                },
                                onChanged: (_) {
                                  vm.inputTextOnSubmitted();
                                },
                                decoration: InputDecoration(
                                  suffix: IconButton(
                                    icon: Icon(vm.passwordObscured
                                        ? FluentIcons.eye_hide_20_regular
                                        : FluentIcons.eye_show_20_regular),
                                    onPressed: () {
                                      vm.viewObscured('password');
                                    },
                                  ),
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
                                obscureText: vm.passwordObscured,
                              ),
                            ),
                            //TODO: Add a forgot password? option here
                            //VERIFY PASSWORD
                            Visibility(
                              visible: vm.showPasswordVerifyTextField,
                              child: TextField(
                                autocorrect: false,
                                obscureText: vm.isVeryfyPasswordObscured,
                                controller: vm.verifyPasswordTextController,
                                onSubmitted: (_) {
                                  vm.inputTextOnSubmitted();
                                },
                                onChanged: (_) {
                                  vm.inputTextOnSubmitted();
                                },
                                decoration: InputDecoration(
                                  suffix: IconButton(
                                    icon: Icon(vm.isVeryfyPasswordObscured
                                        ? FluentIcons.eye_hide_24_regular
                                        : FluentIcons.eye_show_24_regular),
                                    onPressed: () {
                                      vm.viewObscured('verifyPassword');
                                    },
                                  ),
                                  hintText: AppStrings.RE_PASSWORD,
                                  hintStyle: const TextStyle(
                                      color: AppColors.inactiveBtnText),
                                  errorText:
                                      (vm.verifyPasswordTextController.text ==
                                              '')
                                          ? null
                                          : vm.verifyPasswordTextFieldError,
                                  errorStyle: const TextStyle(
                                    color: AppColors.accentBusy,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            //CONTINUE/SUBMIT BUTTON
                            ActiveButton(
                              title: vm.btnTitle,
                              width: 225,
                              onPressed: () async {
                                if (vm.authManager.loginState !=
                                    ApplicationLoginState.loggedIn) {
                                  await vm.inputTextOnSubmitted();
                                }
                                vm.submit(context);
                                //vm.submit
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
                              onTap: () async {
                                print('trying google sign in');
                                await vm.googleSignIn();
                              },
                              text: AppStrings.SIGN_IN_GOOGLE,
                            ),
                            const SizedBox(height: 15),
                            //Facebook Sign-in Button
                            SocialButton(
                              imageAsset: AppAssets.FACEBOOK_LOGO,
                              onTap: () async {
                                print('trying to login to fb');
                                await vm.facebookSignIn();
                              },
                              text: AppStrings.SIGN_IN_FACEBOOK,
                            ),
                            const SizedBox(height: 15),
                            SocialButton(
                              imageAsset: AppAssets.APPLE_LOGO,
                              onTap: () async {
                                print('trying to login with Apple');
                              },
                              text: AppStrings.SIGN_IN_APPLE,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
