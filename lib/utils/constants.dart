import 'package:flutter/material.dart';

const kLightGray = const Color(0xfff0f0f0);
const kGray = const Color(0xffa0a0a0);
const kDarkGray = const Color(0xff707070);

const kDividerVert20 = SizedBox(height: 20);
const kDividerHor20 = SizedBox(width: 20);

const kEmptyWidget = SizedBox.shrink();

const kTextStyle30 = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontSize: 30.0,
);

const kTextStyle25 = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontSize: 25.0,
);

const kErrorTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 20.0,
);

const kSuccessTextStyle = TextStyle(
  color: Colors.green,
  fontSize: 20.0,
);

const ERROR = 'ERROR';
const SUCCESS = 'SUCCESS';

const kContentPaddingVertical20 = const EdgeInsets.symmetric(
  vertical: 20.0,
);