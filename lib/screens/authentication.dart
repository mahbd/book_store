import 'dart:convert';
import 'package:book_store/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'base.dart';
import 'splash.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  Future<String?> _loginUser(LoginData data) async {
    String username = data.customLoginData!['username'] ?? '';
    String password = data.customLoginData!['password'] ?? '';
    try {
      http.Response response = await http.post(Uri.parse("$api/auth/login/"),
          body: {"username": username, "password": password});
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String accessToken = responseData['access_token'];
        String refreshToken = responseData['refresh_token'];
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('access_token', accessToken);
        _prefs.setString('refresh_token', refreshToken);
        Navigator.of(context).pushReplacementNamed(NamedRoutes.home);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> body = json.decode(response.body);
        String message = "Invalid username or password";
        body.forEach((key, value) {
          message = value[0].toString();
        });
        return message;
      } else {
        return "An error occurred. Please try again later. Code: ${response.statusCode}";
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('An error occurred. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return e.toString();
    }
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    String username = data.customLoginData!['username'] ?? '';
    String password = data.customLoginData!['password'] ?? '';
    String email = data.additionalSignupData!['email'] ?? '';
    String firstName = data.additionalSignupData!['firstName'] ?? '';
    String lastName = data.additionalSignupData!['lastName'] ?? '';
    try {
      http.Response response =
          await http.post(Uri.parse("$api/users/register/"), body: {
        "username": username,
        "password": password,
        "password_confirm": password,
        "email": email,
        "first_name": firstName,
        "last_name": lastName
      });
      if (response.statusCode == 201) {
        LoginData loginData = LoginData(
          name: username,
          password: password,
          customLoginData: {
            'username': username,
            'password': password,
          },
        );
        return _loginUser(loginData);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> body = json.decode(response.body);
        String message = "Invalid username or password";
        body.forEach((key, value) {
          message = "$key: ${value[0]}";
        });
        return message;
      } else {
        return "An error occurred. Please try again later. Code: ${response.statusCode}";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> _checkLoginStatus(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    loadPreferredTheme(context, _prefs);
    String? accessToken = _prefs.getString('access_token');
    String? refreshToken = _prefs.getString('refresh_token');
    if (accessToken != null && refreshToken != null) {
      try {
        http.Response response = await http.post(
          Uri.parse("$api/auth/token/verify/"),
          body: {"token": accessToken},
          headers: {'Authorization': 'Bearer $accessToken'},
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('No connection'),
                content: const Text(
                    'We are sorry but we could not connect to the server. You will be redirected to the login screen.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
        return false;
      }
    } else {
      return Future.delayed(const Duration(seconds: 1)).then((_) {
        return false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkLoginStatus(context),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SplashScreen(),
            );
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              return const BaseScreen();
            }
            return FlutterLogin(
              hideForgotPasswordButton: true,
              passwordValidator: (value) {
                if (value != null && value.length < 4) {
                  return 'Password must be at least 4 characters long';
                }
                return null;
              },
              logo: 'assets/images/books.png',
              title: 'Book Store',
              onLogin: _loginUser,
              onSignup: _signupUser,
              additionalSignupFields: const [
                UserFormField(
                  keyName: 'email',
                  displayName: 'Email Address',
                  icon: Icon(Icons.email),
                  userType: LoginUserType.email,
                ),
                UserFormField(
                  keyName: 'firstName',
                  displayName: 'First Name',
                  icon: Icon(Icons.person),
                  userType: LoginUserType.name,
                ),
                UserFormField(
                  keyName: 'lastName',
                  displayName: 'Last Name',
                  icon: Icon(Icons.person),
                  userType: LoginUserType.name,
                ),
              ],
              loginFields: const [
                UserFormField(
                  keyName: 'username',
                  displayName: 'Username',
                  icon: Icon(Icons.person),
                  userType: LoginUserType.name,
                ),
                UserFormField(
                    keyName: 'password',
                    displayName: 'Password',
                    icon: Icon(Icons.lock),
                    userType: LoginUserType.password),
              ],
            );
          }
        }));
  }
}
