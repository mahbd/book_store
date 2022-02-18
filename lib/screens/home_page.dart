import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Text(
          'Home',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        showUnselectedLabels: true,
        elevation: 5,
        currentIndex: _tabIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'WishList',
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: 'Cart',
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Theme.of(context).backgroundColor,
          ),
        ],
        onTap: (int index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }
}
