import 'dart:convert';

import 'package:book_store/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void reload() {
    setState(() {});
  }

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
                    children: [
                      user.image != null
                          ? CircleAvatar(
                              backgroundImage: Image.network(user.image!).image,
                              radius: 60,
                            )
                          : const CircleAvatar(
                              child: Icon(Icons.person),
                              radius: 60,
                            ),
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
                  _EditProfileTile(user: user, reload: reload),
                  const Divider(
                    thickness: 0.5,
                  ),
                  _ChangePasswordTile(reload: reload),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const _ChangeThemeTile(),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const _OrderTile(),
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

class _OrderTile extends StatelessWidget {
  const _OrderTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(NamedRoutes.orders);
      },
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
            content: const Text('Are you sure you want to logout?'),
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
                  Navigator.of(context).pushReplacementNamed(NamedRoutes.login);
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

class _ChangeThemeTile extends StatelessWidget {
  const _ChangeThemeTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      onTap: () async {
        Navigator.of(context).pushNamed(NamedRoutes.changeTheme);
      },
    );
  }
}

class _EditProfileTile extends StatefulWidget {
  const _EditProfileTile({
    Key? key,
    required this.user,
    required this.reload,
  }) : super(key: key);

  final User user;
  final Function reload;

  @override
  State<_EditProfileTile> createState() => _EditProfileTileState();
}

class _EditProfileTileState extends State<_EditProfileTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await Navigator.of(context).pushNamed(
          NamedRoutes.editProfile,
          arguments: widget.user,
        );
        widget.reload();
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

class _ChangePasswordTile extends StatefulWidget {
  const _ChangePasswordTile({
    Key? key,
    required this.reload,
  }) : super(key: key);

  final Function reload;

  @override
  State<_ChangePasswordTile> createState() => _ChangePasswordTileState();
}

class _ChangePasswordTileState extends State<_ChangePasswordTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await Navigator.of(context).pushNamed(NamedRoutes.changePassword);
        widget.reload();
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

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  bool isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _firstNameController = TextEditingController(
      text: widget.user.firstName,
    );
    final TextEditingController _lastNameController = TextEditingController(
      text: widget.user.lastName,
    );
    final TextEditingController _emailController = TextEditingController(
      text: widget.user.email,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isSubmitting = true;
                });
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                final _accessToken = _prefs.getString('access_token');
                http.Response response = await http.patch(
                  Uri.parse("$api/auth/user/"),
                  headers: {'Authorization': 'Bearer $_accessToken'},
                  body: {
                    'first_name': _firstNameController.text,
                    'last_name': _lastNameController.text,
                    'email': _emailController.text,
                  },
                );
                if (response.statusCode == 200) {
                  setState(() {
                    isSubmitting = false;
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Failed to edit profile'),
                        content: const Text(
                            'Failed to edit profile. Please try again.'),
                        actions: [
                          TextButton(
                            child: const Text('Ok'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                }
                setState(() {
                  isSubmitting = false;
                });
                Navigator.pop(context);
              },
              child: !isSubmitting
                  ? const Text('Save')
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  bool isSubmitting = false;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'Old Password',
              ),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isSubmitting = true;
                });
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                final _accessToken = _prefs.getString('access_token');
                http.Response response = await http.post(
                  Uri.parse("$api/auth/password/change/"),
                  headers: {'Authorization': 'Bearer $_accessToken'},
                  body: {
                    'new_password1': _newPasswordController.text,
                    'new_password2': _confirmPasswordController.text,
                  },
                );
                if (response.statusCode == 200) {
                  setState(() {
                    isSubmitting = false;
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Failed to change password'),
                        content: const Text(
                            'Failed to change password. Please try again.'),
                        actions: [
                          TextButton(
                            child: const Text('Ok'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                }
                setState(() {
                  isSubmitting = false;
                });
                Navigator.pop(context);
              },
              child: !isSubmitting
                  ? const Text('Save')
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
