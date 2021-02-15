import 'package:flutter/material.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/screens/login_screen.dart';
import 'package:personal_space/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

enum LoginScreenState {
  LOADING,
  ERROR,
  OTP_SENT,
  WRONG_OTP,
  SUCCESS,
  NONE,
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListenableProvider<ValueNotifier<LoginScreenState>>(
          create: (_) => ValueNotifier<LoginScreenState>(LoginScreenState.NONE),
          builder: (context, _) => Center(
            child: Card(
              elevation: 10.0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.50,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /* title text */
                    Text(
                      'Welcome to Personal Space',
                      style: kTextStyle30,
                    ),
                    kDivider20,

                    /* user phone number input */
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText:
                            'Your contact no. where you can receive an OTP',
                      ),
                    ),
                    kDivider20,

                    /* submit otp button */
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CustomTextButton(
                        text: 'Send OTP',
                        onPressed: () => LoginScreenUtils.onSendOtpPressed(
                          _controller.text,
                          context,
                        ),
                      ),
                    ),

                    /* widget to show status of OTP verification */
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 800,
                      ),
                      child: LoginScreenUtils.buildAnimatedSwitcherChild(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
