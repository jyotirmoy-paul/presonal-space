import 'package:flutter/material.dart';

class TextSettings extends ChangeNotifier {
  static const CHANGE_VALUE = 0.50;
  static const LOWER_LIMIT = 5.0;
  static const UPPER_LIMIT = 40.0;

  double _fontSize;
  bool _darkTheme;

  /* default settings */
  TextSettings() {
    this._fontSize = 20.0;
    this._darkTheme = false;
  }

  double get fontSize => _fontSize;

  bool get darkTheme => _darkTheme;

  set fontSize(double size) {
    if (size == LOWER_LIMIT || size == UPPER_LIMIT) return;

    if (_fontSize == size) return;

    _fontSize = size;
    notifyListeners();
  }

  set darkTheme(bool showDarkTheme) {
    if (_darkTheme == showDarkTheme) return;

    _darkTheme = showDarkTheme;
    notifyListeners();
  }
}
