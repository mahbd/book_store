import 'package:book_store/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/tab_bar_provider.dart';
import 'home_page.dart';
import 'product_list.dart';
import 'profile.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _tabIndex = 0;
  List<Widget> children = [
    const HomePage(),
    const WishListPage(),
    const ProductList(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeProvider = Provider.of<ThemeChanger>(context);
    TabPageChanger _newPage = Provider.of<TabPageChanger>(context);

    if (_newPage.getPage != null) {
      if (children.length == 4) {
        children.add(_newPage.getPage);
        setState(() {
          _tabIndex = 4;
        });
      } else if (children.length == 5) {
        if (children[4] != _newPage.getPage) {
          children[4] = _newPage.getPage;
          setState(() {
            _tabIndex = 4;
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: children[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).selectedRowColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        showUnselectedLabels: true,
        elevation: 5,
        currentIndex: _tabIndex < 4 ? _tabIndex : 0,
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
