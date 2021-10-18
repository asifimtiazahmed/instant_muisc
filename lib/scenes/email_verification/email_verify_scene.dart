import 'package:flutter/material.dart';
import 'package:instant_music/resources/app_assets.dart';
import 'package:instant_music/resources/app_colors.dart';
import 'package:instant_music/resources/app_strings.dart';
import 'package:instant_music/resources/app_styles.dart';
import 'package:instant_music/scenes/login/login_scene.dart';
import 'package:instant_music/services/firebase_auth.dart';
import 'package:instant_music/widgets/button.dart';
import 'package:provider/provider.dart';

import 'email_verify_view_model.dart';

class EmailVerifyScene extends StatelessWidget {
  static const String routeName = 'emailVerifyScene';

  const EmailVerifyScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailVerifyViewModel>(builder: (context, vm, child) {
      vm.ctx =
          context; //Passing the context of the page here so that we can navigate from here using the view moderl
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.VERIFY_EMAIL,
                    style: AppStyles.title.copyWith(color: AppColors.primary)),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  child: Text(
                    AppStrings.VERIFY_EMAIL_MSG,
                    style: AppStyles.bodyText,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(
                  height: 30,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(AppAssets.EMAIL_IMAGE),
                ),
                const SizedBox(height: 30),
                Text(
                  AppStrings.DID_NOT_RECV,
                  style: AppStyles.hintInfoActive
                      .copyWith(color: AppColors.secondaryInactive),
                ),
                //RE-SEND BUTTON
                ActiveButton(
                    title: vm.btnText,
                    backgroundColor: (!vm.sentEmail)
                        ? AppColors.primary
                        : AppColors.secondaryInactive,
                    customTextColor: AppColors.btnText,
                    isCustomBgColor: true,
                    width: 220,
                    onPressed: () {
                      //if the sent email is false, means email has not been sent. So let the button work
                      if (!vm.sentEmail) {
                        vm.sendEmailVerification();
                      }
                    }),
                const SizedBox(height: 30),
                Text(
                  (vm.authManager.loginState == ApplicationLoginState.loggedIn)
                      ? 'Not ${vm.authManager.firebaseUser?.email}?'
                      : '',
                  style: AppStyles.hintInfoActive
                      .copyWith(color: AppColors.secondaryInactive),
                ),
                ActiveButton(
                  title: AppStrings.BTN_LOGOUT,
                  isOutlined: true,
                  customTextColor: AppColors.primary,
                  onPressed: () {
                    vm.authManager.sighOut();
                    Navigator.pushNamed(context, LoginScene.routeName);
                  },
                  width: 220,
                ),
                const SizedBox(
                  height: 20,
                ),
                if (!vm.isVerified)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(AppStrings.CHECKING,
                            style: AppStyles.subBodyText
                                .copyWith(color: AppColors.secondaryInactive)),
                        const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            )),
                      ]),
              ],
            ),
          ),
        ),
      );
    });
  }
}
