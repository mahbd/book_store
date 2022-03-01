import 'package:book_store/constants.dart';
import 'package:book_store/models/category_model.dart';
import 'package:book_store/models/product_model.dart';
import 'package:book_store/screens/orders.dart';
import 'package:book_store/screens/product_list.dart';
import 'package:book_store/screens/profile.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../screens/authentication.dart';
import '../screens/base.dart';
import '../screens/change_theme.dart';
import '../screens/product_details.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == NamedRoutes.base) {
      return MaterialPageRoute(builder: (_) => const Authentication());
    } else if (settings.name == NamedRoutes.login) {
      return MaterialPageRoute(builder: (_) => const Authentication());
    } else if (settings.name == NamedRoutes.home) {
      return MaterialPageRoute(builder: (_) => const BaseScreen());
    } else if (settings.name == NamedRoutes.productDetails) {
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
    } else if (settings.name == NamedRoutes.searchResults) {
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
    } else if (settings.name == NamedRoutes.categoryProducts) {
      if (settings.arguments is Category) {
        return MaterialPageRoute(
          builder: (_) => BaseScreen(
            page: ProductList(
              title: "Category: ${(settings.arguments as Category).showName}",
              category: settings.arguments as Category,
            ),
          ),
        );
      }
      return _errorRoute(message: "Category is not passed as an argument");
    } else if (settings.name == NamedRoutes.orders) {
      return MaterialPageRoute(
        builder: (_) => const BaseScreen(
          page: OrderPage(),
        ),
      );
    } else if (settings.name == NamedRoutes.changeTheme) {
      return MaterialPageRoute(
        builder: (_) => const BaseScreen(
          page: ChangeThemePage(),
        ),
      );
    } else if (settings.name == NamedRoutes.editProfile) {
      if (settings.arguments is User) {
        return MaterialPageRoute(
          builder: (_) => BaseScreen(
            page: EditProfileForm(
              user: settings.arguments as User,
            ),
          ),
        );
      }
      return _errorRoute(message: "User is not passed as an argument");
    } else if (settings.name == NamedRoutes.changePassword) {
      return MaterialPageRoute(
        builder: (_) => const BaseScreen(
          page: ChangePasswordForm(),
        ),
      );
    } else {
      return _errorRoute(message: "Unknown route: ${settings.name}");
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
