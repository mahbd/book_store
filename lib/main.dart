import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product_model.dart';
import 'providers/theme_provider.dart';
import 'providers/tab_bar_provider.dart';
import 'widget/route_generator.dart';

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
        ChangeNotifierProvider(create: (_) => ThemeChanger(ThemeData.light())),
        ChangeNotifierProvider(create: (_) => TabPageChanger(0)),
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
      title: "Ecommerce App",
      theme: theme.getTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
    );
  }
}
