import 'package:flutter/material.dart';
import 'package:personal_space/screens/auth/login_screen.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';

class LoginScreenUtils {
  LoginScreenUtils._();

  static void onSendOtpPressed(String phoneNumber, BuildContext context) {}

  static Widget buildAnimatedSwitcherChild() =>
      Consumer<ValueNotifier<LoginScreenState>>(
        builder: (_, vnLoginScreenState, __) {
          switch (vnLoginScreenState.value) {
            case LoginScreenState.LOADING:
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            case LoginScreenState.ERROR:
              return Text(
                'You have successfully managed to pull the wrong strings in my system, and something went wrong, may be your phone number? May be your otp? Or, may be you?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                ),
              );

            case LoginScreenState.OTP_SENT:
              // TODO: Handle this case.
              break;

            case LoginScreenState.WRONG_OTP:
              // TODO: Handle this case.
              break;

            case LoginScreenState.SUCCESS:
              /* don't need to show anything, as the user is
              automatically redirected to the main screen */
              return kEmptyWidget;

            case LoginScreenState.NONE:
              return kEmptyWidget;
          }

          return kEmptyWidget;
        },
      );
}
