import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  CustomTextButton({
    @required this.onPressed,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
