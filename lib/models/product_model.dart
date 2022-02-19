import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:book_store/models/category_model.dart';

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
  final int isWishlisted;
  final int isInCart;
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

  factory Product.fromHttp(int id) {
    http.get(Uri.parse("$api/products/$id")).then((response) {
      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    }).catchError((onError) {
      throw Exception('Failed to load product');
    });
    throw Exception('Failed to load product');
  }
}

List<Product> fromHttpList(Category category) {
  http
      .get(Uri.parse("$api/products/?category=${category.name}"))
      .then((response) {
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }).catchError((onError) {
    throw Exception('Failed to load products');
  });
  throw Exception('Failed to load products');
}
