import 'dart:convert';
import 'package:book_store/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/product_model.dart';
import '../providers/tab_bar_provider.dart';
import 'future_image.dart';

class Featured extends StatelessWidget {
  const Featured({
    Key? key,
  }) : super(key: key);

  Future<List<Product>> _getFeaturedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    try {
      http.Response response = await http.get(
        Uri.parse("$api/api/featured/"),
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((data) => Product.fromJson(data))
            .toList();
      } else {
        print("Status code: ${response.statusCode}");
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    TabPageChanger _tabPageChanger = Provider.of<TabPageChanger>(context);
    return FutureBuilder(
        future: _getFeaturedProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              ),
            );
          } else {
            if (snapshot.hasData) {
              var products = convertToProductList(snapshot.data);
              return SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _tabPageChanger.setPage(
                          ProductDetails(
                            product: products[index],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: SizedBox(
                          width: 150,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                child: FutureImage(url: products[index].image),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        products[index].name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .selectedRowColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "TK: ${products[index].price}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .selectedRowColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const SizedBox(
                height: 250,
                child: Center(
                  child: Text(
                    'Failed to load products',
                    style: TextStyle(fontSize: 25, color: Colors.red),
                  ),
                ),
              );
            }
          }
        });
  }
}

List<Product> convertToProductList(dynamic data) {
  List<Product> products = data.map<Product>((e) => e as Product).toList();
  return products;
}
