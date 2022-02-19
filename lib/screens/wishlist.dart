import 'dart:convert';

import 'package:book_store/constants.dart';
import 'package:book_store/models/product_model.dart';
import 'package:book_store/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  Future<List<Product>> _getWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse("$api/api/wishlist/"), headers: {
      'Authorization': 'Bearer $accessToken',
    });
    final List<Product> wishList = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var item in data) {
        Product? product = await productFromHttp(item['item']);
        wishList.add(product);
      }
    } else {
      throw Exception('Failed to load wishlist');
    }
    return wishList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getWishList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Wish List'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasData) {
              return ProductList(
                products: snapshot.data! as List<Product>,
                title: 'Wish List',
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('Wish List'),
              ),
              body: const Center(
                child: Text('No products found'),
              ),
            );
          }
        });
  }
}
