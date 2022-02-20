import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/product_model.dart';
import '../providers/tab_bar_provider.dart';
import 'product_details.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<List<Product>> _getWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse("$api/api/cart/"), headers: {
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
              title: const Text('Cart List'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
            final List<Product> products = convertToProductList(snapshot.data);
            final TextEditingController _quantityController =
                TextEditingController();
            _quantityController.text = '1';
            int _quantity = 1;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Cart List'),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: ListView.builder(
                itemCount: products.isNotEmpty ? products.length + 1 : 0,
                itemBuilder: (context, index) {
                  if (index == products.length) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          child: const Text('Buy All'),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          height: 40,
                          minWidth: 150,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    );
                  }
                  return _ProductInCart(product: products[index]);
                },
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cart List'),
            ),
            body: const Center(
              child: Text('No products found'),
            ),
          );
        }
      },
    );
  }
}

List<Product> convertToProductList(dynamic data) {
  List<Product> products = data.map<Product>((e) => e as Product).toList();
  return products;
}

class _ProductInCart extends StatefulWidget {
  const _ProductInCart({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  __ProductInCartState createState() => __ProductInCartState();
}

class __ProductInCartState extends State<_ProductInCart> {
  final TextEditingController _quantityController = TextEditingController();
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    TabPageChanger tabPageChanger = Provider.of<TabPageChanger>(context);
    _quantityController.text = _quantity.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 7,
      ),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                tabPageChanger.setPage(
                  ProductDetails(
                    product: widget.product,
                  ),
                );
              },
              child: Container(
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).textTheme.headline6!.color!,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_quantity > 1) {
                                _quantity--;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: TextField(
                          controller: _quantityController,
                          onChanged: (value) {
                            setState(() {
                              _quantity = int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          cursorColor: Colors.transparent,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).textTheme.headline6!.color!,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (_quantity < widget.product.stock) {
                              setState(() {
                                _quantity++;
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Limit Exceed'),
                                    content: const Text(
                                        'You can not add more than the stock'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MaterialButton(
                            onPressed: () {},
                            child: const Text('Buy now'),
                            color: Theme.of(context).backgroundColor,
                            textColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
