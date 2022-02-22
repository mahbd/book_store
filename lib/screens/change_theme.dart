import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';

class ChangeThemePage extends StatefulWidget {
  const ChangeThemePage({Key? key}) : super(key: key);

  @override
  _ChangeThemePageState createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends State<ChangeThemePage> {
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeProvider = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Theme'),
      ),
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              SharedPreferences prefs = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text('Light'),
                      tileColor: Colors.white,
                      onTap: () {
                        prefs.setString('theme', 'light');
                        _themeProvider.setTheme(ThemeData.light());
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text('Dark'),
                      tileColor: Colors.black,
                      textColor: Colors.white,
                      onTap: () {
                        prefs.setString('theme', 'dark');
                        _themeProvider.setTheme(ThemeData.dark());
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text('Pink'),
                      tileColor: Colors.pink,
                      onTap: () {
                        prefs.setString('theme', 'pink');
                        _themeProvider.setTheme(ThemeData(
                          primarySwatch: Colors.pink,
                        ));
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text('Blue'),
                      tileColor: Colors.blue,
                      onTap: () {
                        prefs.setString('theme', 'blue');
                        _themeProvider.setTheme(ThemeData(
                          primarySwatch: Colors.blue,
                        ));
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text('Green'),
                      tileColor: Colors.green,
                      onTap: () {
                        prefs.setString('theme', 'green');
                        _themeProvider.setTheme(ThemeData(
                          primarySwatch: Colors.green,
                        ));
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text('Purple'),
                      tileColor: Colors.purple,
                      onTap: () {
                        prefs.setString('theme', 'purple');
                        _themeProvider.setTheme(ThemeData(
                          primarySwatch: Colors.purple,
                        ));
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Error'));
            }
          }
        },
      ),
    );
  }
}
