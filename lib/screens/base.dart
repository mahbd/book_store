import 'package:book_store/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _tabIndex = 0;
  final List<Widget> _children = const [
    HomePage(),
    Text('Page 2'),
    Text('Page 3'),
    Text('Page 4'),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeProvider = Provider.of<ThemeChanger>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _children[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).selectedRowColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        showUnselectedLabels: true,
        elevation: 5,
        currentIndex: _tabIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'WishList',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: 'Cart',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            _themeProvider.setTheme(lightTheme);
          } else if (index == 1) {
            _themeProvider.setTheme(loveTheme);
          } else if (index == 2) {
            _themeProvider.setTheme(cartTheme);
          } else if (index == 3) {
            _themeProvider.setTheme(profileTheme);
          }
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }
}
