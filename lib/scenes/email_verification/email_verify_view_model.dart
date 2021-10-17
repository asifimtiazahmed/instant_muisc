import 'package:flutter/material.dart';

class EmailVerifyViewModel extends ChangeNotifier {
  bool isVerified = false;
}
//TODO: Init this view model to check if the user is logged in through firebase email option, then send a validation email, and check constantly if email has been verified or not
