import 'package:flutter/material.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/screens/login_screen_utils.dart';
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
                    kDividerVert20,

                    /* user phone number input */
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText:
                            'Your contact no. where you can receive an OTP',
                      ),
                    ),
                    kDividerVert20,

                    /* submit / resend otp button */
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Consumer<ValueNotifier<LoginScreenState>>(
                        builder: (_, vnLoginScreenState, __) =>
                            CustomTextButton(
                          text: LoginScreenUtils.confirmButtonText(
                            vnLoginScreenState.value,
                          ),
                          onPressed: () =>
                              LoginScreenUtils.onConfirmButtonPress(
                            _controller.text,
                            context,
                            vnLoginScreenState.value,
                          ),
                        ),
                      ),
                    ),

                    /* widget to show status of OTP verification */
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 800,
                      ),
                      child: LoginScreenUtils.buildAnimatedSwitcherChild(
                        context,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
