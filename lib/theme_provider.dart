import 'package:flutter/material.dart';

var darkTheme = ThemeData.dark();
var lightTheme = ThemeData.light();

var loveTheme = ThemeData(
  primarySwatch: Colors.pink,
);

var cartTheme = ThemeData(
  primarySwatch: Colors.green,
);

var profileTheme = ThemeData(
  primarySwatch: Colors.blue,
);

class ThemeChanger extends ChangeNotifier {
  ThemeData _themeData;
  ThemeChanger(this._themeData);

  get getTheme => _themeData;
  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
