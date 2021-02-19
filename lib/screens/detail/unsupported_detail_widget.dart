import 'package:flutter/material.dart';

/* TODO: build this screen, also let allow user to choose the FILE TYPE */

class UnsupportedDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'File format not supported',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, color: Colors.red),
      ),
    );
  }
}
