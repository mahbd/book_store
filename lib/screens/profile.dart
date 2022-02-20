import 'dart:convert';

import 'package:book_store/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  Future<User> getUserDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String accessToken = _prefs.getString('access_token') ?? '';
    http.Response response = await http.get(
      Uri.parse("$api/auth/user/"),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load user");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder<User>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text("Fetching user information")
                ],
              ),
            );
          } else {
            if (snapshot.hasData) {
              final User user = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(radius: 60, backgroundColor: Colors.red),
                    ],
                  ),
                  Center(
                    child: Text(
                      '${user.firstName} ${user.lastName}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Center(
                    child: Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  _EditProfileTile(user: user),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const _ChangePasswordTile(),
                  const Divider(
                    thickness: 0.5,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Theme.of(context).primaryColor,
                    leading: const Icon(Icons.lock),
                    title: Text(
                      'Change Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    subtitle: Text(
                      'Change your theme',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Theme.of(context).primaryColor,
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    subtitle: Text(
                      'See list of books you have ordered',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const _LogoutTile(),
                  const SizedBox(height: 100),
                ],
              );
            } else {
              return const Center(
                child: Text('Failed to fetch user information.'),
              );
            }
          }
        },
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text(
                'Are you sure you want to logout?\nThe app will be closed to remove saved data.'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Logout'),
                onPressed: () async {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  await _prefs.remove('access_token');
                  await _prefs.remove('refresh_token');
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tileColor: Theme.of(context).primaryColor,
      leading: const Icon(Icons.exit_to_app),
      title: Text(
        'Logout',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
      subtitle: Text(
        'Logout from the app',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}

class _EditProfileTile extends StatelessWidget {
  const _EditProfileTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              final _firstNameController = TextEditingController(
                text: user.firstName,
              );
              final _lastNameController = TextEditingController(
                text: user.lastName,
              );
              final _emailController = TextEditingController(
                text: user.email,
              );
              return AlertDialog(
                title: const Text('Edit Profile'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      controller: _firstNameController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                      controller: _lastNameController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      controller: _emailController,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tileColor: Theme.of(context).primaryColor,
      leading: const Icon(Icons.edit),
      title: Text(
        'Edit Profile',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
      subtitle: Text(
        'Edit your profile information',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}

class _ChangePasswordTile extends StatelessWidget {
  const _ChangePasswordTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            final _oldPasswordController = TextEditingController();
            final _newPasswordController = TextEditingController();
            final _confirmPasswordController = TextEditingController();
            return AlertDialog(
              title: const Text('Change Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Old Password',
                    ),
                    controller: _oldPasswordController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    controller: _newPasswordController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    controller: _confirmPasswordController,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tileColor: Theme.of(context).primaryColor,
      leading: const Icon(Icons.lock),
      title: Text(
        'Change Password',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
      subtitle: Text(
        'Change your password',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}
