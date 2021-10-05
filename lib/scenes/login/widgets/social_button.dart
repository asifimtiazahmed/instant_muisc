import 'package:flutter/material.dart';
import 'package:instant_music/resources/app_colors.dart';
import 'package:instant_music/resources/app_styles.dart';

class SocialButton extends StatelessWidget {
  const SocialButton(
      {Key? key,
      required this.text,
      required this.imageAsset,
      required this.onTap})
      : super(key: key);
  final String imageAsset;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          const BorderSide(color: AppColors.primary, width: 1),
        ),
        shape: MaterialStateProperty.all(const StadiumBorder()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SizedBox(
          width: 280,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageAsset, width: 20, height: 20),
              const SizedBox(width: 10),
              Text(
                text,
                style: AppStyles.buttonText.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
