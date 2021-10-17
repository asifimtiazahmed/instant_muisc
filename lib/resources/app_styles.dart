import 'package:flutter/material.dart';
import 'package:instant_music/resources/app_colors.dart';

class AppStyles {
  static final title =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.7);
  static final subTitle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.25);
  static final bodyText =
      TextStyle(fontSize: 16, height: 1.27, color: AppColors.text);
  static const subBodyText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.25);
  static const subBodyTextInactive = TextStyle(fontSize: 14, height: 1.25);
  static const hintInfo = TextStyle(fontSize: 12, height: 15);
  static const hintInfoActive =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.15);
  static const navigationText =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w500, height: 1.15);
  static const buttonText =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.27);
}
