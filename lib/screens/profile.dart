import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.red,
              ),
            ],
          ),
          Text(
            'Mahmudul Alam',
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            'mahmudula2000@gmail.com',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 20),
                ListTile(
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
                ),
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
                ListTile(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
