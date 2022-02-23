import 'package:book_store/models/category_model.dart';
import 'package:book_store/models/product_model.dart';
import 'package:book_store/screens/product_list.dart';
import 'package:flutter/material.dart';

import '../screens/authentication.dart';
import '../screens/base.dart';
import '../screens/product_details.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Authentication());
      case '/login':
        return MaterialPageRoute(builder: (_) => const Authentication());
      case '/home':
        if (settings.arguments is Widget) {
          return MaterialPageRoute(
            builder: (_) => BaseScreen(
              page: settings.arguments as Widget?,
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const BaseScreen());
      case '/product-details':
        if (settings.arguments is Product) {
          return MaterialPageRoute(
            builder: (_) => BaseScreen(
              page: ProductDetails(
                product: settings.arguments as Product,
              ),
            ),
          );
        }
        return _errorRoute(message: "Product is not passed as an argument");
      case '/search-results':
        if (settings.arguments is List<Product>) {
          return MaterialPageRoute(
            builder: (_) => BaseScreen(
              page: ProductList(
                title:
                    "Search Result(${(settings.arguments as List<Product>).length})",
                products: settings.arguments as List<Product>,
              ),
            ),
          );
        }
        return _errorRoute(message: "Products are not passed as an argument");
      case '/category-products':
        if (settings.arguments is Category) {
          return MaterialPageRoute(
            builder: (_) => BaseScreen(
              page: ProductList(
                title: "Category: ${settings.arguments as Category}",
                category: settings.arguments as Category,
              ),
            ),
          );
        }
        return _errorRoute(message: "Category is not passed as an argument");
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(
      {String title = "Error", String message = "Error"}) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      );
    });
  }
}
