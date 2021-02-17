import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_space/utils/constants.dart';

class LoginScreenService {
  LoginScreenService._();

  static Future<String> sendOtp(
    String phoneNumber, {
    void onOtpSent(ConfirmationResult result),
  }) async {
    try {
      ConfirmationResult result =
          await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);

      onOtpSent(result);
      return SUCCESS;
    } catch (e) {
      log('login_screen_service : onOtpSent : $e');

      onOtpSent(null);
      return e;
    }
  }

  static Future<String> confirmOtp(
    String userOTP,
    ConfirmationResult result,
  ) async {
    assert(result != null);

    try {
      await result.confirm(userOTP);
      return SUCCESS;
    } catch (e) {
      log('login_screen_service : confirmOtp : $e');
      return e.toString();
    }
  }
}
