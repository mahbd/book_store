import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger extends ChangeNotifier {
  ThemeData _themeData;
  ThemeChanger(this._themeData);

  get getTheme => _themeData;
  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}

// theme = light|dark|pink|blue|green|purple

void loadPreferredTheme(BuildContext context, SharedPreferences prefs) {
  ThemeChanger _themeProvider =
      Provider.of<ThemeChanger>(context, listen: false);
  String theme = prefs.getString('theme') ?? 'light';
  if (theme == 'light') {
    _themeProvider.setTheme(
      ThemeData.light(),
    );
  } else if (theme == 'dark') {
    _themeProvider.setTheme(
      ThemeData.dark(),
    );
  } else if (theme == 'pink') {
    _themeProvider.setTheme(ThemeData.light().copyWith(
      primaryColor: Colors.pink,
    ));
  } else if (theme == 'blue') {
    _themeProvider.setTheme(ThemeData.light().copyWith(
      primaryColor: Colors.blue,
    ));
  } else if (theme == 'green') {
    _themeProvider.setTheme(ThemeData.light().copyWith(
      primaryColor: Colors.green,
    ));
  } else if (theme == 'purple') {
    _themeProvider.setTheme(ThemeData.light().copyWith(
      primaryColor: Colors.purple,
    ));
  }
}
