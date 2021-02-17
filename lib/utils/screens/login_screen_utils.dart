import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_space/screens/auth/login_screen.dart';
import 'package:personal_space/services/screens/login_screen_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class LoginScreenUtils {
  LoginScreenUtils._();

  static ConfirmationResult _confirmationResult;

  static String confirmButtonText(LoginScreenState loginScreenState) {
    switch (loginScreenState) {
      case LoginScreenState.LOADING:
        return 'Please wait';
      case LoginScreenState.ERROR:
        return 'Retry';
      case LoginScreenState.OTP_SENT:
        return 'Re-send OTP';
      case LoginScreenState.WRONG_OTP:
        return 'Retry';
      case LoginScreenState.SUCCESS:
        return '';
      case LoginScreenState.NONE:
        return 'Send OTP';
    }

    return 'Send OTP';
  }

  static void _setLoginScreenState(
          BuildContext context, LoginScreenState state) =>
      Provider.of<ValueNotifier<LoginScreenState>>(
        context,
        listen: false,
      ).value = state;

  static void _sendOTP(
    BuildContext context,
    String phoneNumber,
  ) {
    _setLoginScreenState(context, LoginScreenState.LOADING);

    LoginScreenService.sendOtp(
      phoneNumber,
      onOtpSent: (ConfirmationResult confirmationResult) {
        /* if confirmationResult is null something went wrong and we could not send the OTP */
        if (confirmationResult == null)
          return _setLoginScreenState(context, LoginScreenState.ERROR);

        /* else, we have sent the OTP, and now prompt the user */
        _confirmationResult = confirmationResult;
        _setLoginScreenState(context, LoginScreenState.OTP_SENT);
      },
    );
  }

  static void onConfirmButtonPress(
    String phoneNumber,
    BuildContext context,
    LoginScreenState loginScreenState,
  ) {
    switch (loginScreenState) {
      case LoginScreenState.LOADING:
        return null;

      case LoginScreenState.ERROR:
        return _sendOTP(context, phoneNumber);

      case LoginScreenState.OTP_SENT:
        return _sendOTP(context, phoneNumber);

      case LoginScreenState.WRONG_OTP:
        /* in case of wrong OTP, ask the user for another prompt */
        return _setLoginScreenState(context, LoginScreenState.OTP_SENT);

      case LoginScreenState.SUCCESS:
        return null;

      case LoginScreenState.NONE:
        return _sendOTP(context, phoneNumber);
    }
  }

  static void _onOtpSubmit(BuildContext context, String otp) async {
    assert(_confirmationResult != null);

    _setLoginScreenState(context, LoginScreenState.LOADING);

    String status = await LoginScreenService.confirmOtp(
      otp,
      _confirmationResult,
    );

    if (status != SUCCESS)
      _setLoginScreenState(context, LoginScreenState.WRONG_OTP);
  }

  static Widget buildAnimatedSwitcherChild(BuildContext context) =>
      Consumer<ValueNotifier<LoginScreenState>>(
        builder: (_, vnLoginScreenState, __) {
          switch (vnLoginScreenState.value) {
            case LoginScreenState.LOADING:
              return Padding(
                padding: kContentPaddingVertical20,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            case LoginScreenState.ERROR:
              return Padding(
                padding: kContentPaddingVertical20,
                child: Text(
                  'You have successfully managed to pull the wrong strings in my system, and something went wrong, may be your phone number? May be your otp? Or, may be you?',
                  textAlign: TextAlign.center,
                  style: kErrorTextStyle,
                ),
              );

            case LoginScreenState.OTP_SENT:
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: PinCodeTextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textStyle: TextStyle(
                    fontSize: 15.0,
                  ),
                  keyboardType: TextInputType.number,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  beforeTextPaste: (text) => false,
                  backgroundColor: Colors.white,
                  onCompleted: (otp) => _onOtpSubmit(context, otp),
                  onChanged: (_) => null,
                ),
              );

            case LoginScreenState.WRONG_OTP:
              return Padding(
                padding: kContentPaddingVertical20,
                child: Text(
                  'The OTP you entered, is incorrect. Please check again. Or are you trying to guess someone else\'s OTP, Well, good luck doing that.',
                  textAlign: TextAlign.center,
                  style: kErrorTextStyle,
                ),
              );

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
