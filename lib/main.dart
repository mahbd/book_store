import 'package:book_store/screens/home_page.dart';
import 'package:book_store/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/authentication.dart';
import 'models/product_model.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger(lightTheme)),
      ],
      child: const MaterialAppWithTheme(),
    );
  }
}

List<Product> productList = [];

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.getTheme,
      debugShowCheckedModeBanner: false,
      home: const WishListPage(),
    );
  }
}
