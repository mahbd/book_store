import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'category_model.dart';
import '../constants.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String image;
  final int stock;
  final Category category;
  final int isFeatured;
  int isWishlisted;
  int isInCart;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.stock,
    required this.category,
    required this.isFeatured,
    required this.isWishlisted,
    required this.isInCart,
    required this.createdAt,
  });

  // from json
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
      description: json['description'],
      image: json['image'],
      stock: json['stock'] as int,
      category: getCategory(json['category']),
      isFeatured: json['is_featured'] as bool ? 1 : 0,
      isWishlisted: json['is_wish_listed'] as bool ? 1 : 0,
      isInCart: json['is_in_cart'] as bool ? 1 : 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

Future<List<Product>> productListOfCategory(Category category) async {
  // get access token from shared preferences
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  final String accessToken = _prefs.getString('access_token') ?? '';
  http.Response response = await http.get(
    Uri.parse("$api/api/products/?category=${category.name}"),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((product) => Product.fromJson(product))
        .toList();
  } else {
    print("Failed to load. Status code: ${response.statusCode}");
    throw Exception('Failed to load products');
  }
}

Future<Product> productFromHttp(int id) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String accessToken = _prefs.getString('access_token') ?? '';
  http.Response response =
      await http.get(Uri.parse("$api/api/products/$id/"), headers: {
    'Authorization': 'Bearer $accessToken',
  });
  if (response.statusCode == 200) {
    return Product.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load product');
  }
}
