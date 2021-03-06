import 'dart:convert';
import 'package:book_store/widget/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/product_model.dart';

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
    final List<Product> cartList = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var item in data) {
        Product? product = await productFromHttp(item['item']);
        product.isInCart = item['quantity'];
        cartList.add(product);
      }
    } else {
      throw Exception('Failed to load wishlist');
    }
    return cartList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
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
            final List<Product> products = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Cart List'),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _ProductInCart(
                    product: products[index],
                    quantity: products[index].isInCart,
                    reload: reload,
                  );
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

  void reload() {
    setState(() {});
  }
}

class _ProductInCart extends StatefulWidget {
  _ProductInCart({Key? key, required this.product, required this.reload, required this.quantity})
      : super(key: key);
  int quantity;
  final Product product;
  final Function reload;

  @override
  __ProductInCartState createState() => __ProductInCartState();
}

class __ProductInCartState extends State<_ProductInCart> {
  final TextEditingController _quantityController = TextEditingController();
  bool _isRemoving = false;
  bool _isOrdering = false;
  @override
  Widget build(BuildContext context) {
    _quantityController.text = widget.quantity.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 7,
      ),
      child: Container(
        height: 130,
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
                Navigator.of(context).pushNamed(
                  NamedRoutes.productDetails,
                  arguments: widget.product,
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
                              if (widget.quantity > 1) {
                                widget.quantity--;
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
                              widget.quantity = int.parse(value);
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
                            if (widget.quantity < widget.product.stock) {
                              setState(() {
                                widget.quantity++;
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
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              _isRemoving = true;
                            });
                            bool res = await removeFromCart(widget.product.id);
                            setState(() {
                              _isRemoving = false;
                            });
                            if (res) {
                              widget.reload();
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Something went wrong, please try again'),
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
                          icon: _isRemoving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Icon(Icons.delete)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${(widget.product.price * widget.quantity).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MaterialButton(
                            onPressed: () async {
                              setState(() {
                                _isOrdering = true;
                              });
                              bool res = await addToOrder(
                                widget.product.id,
                                widget.quantity,
                                widget.product.price * widget.quantity,
                              );
                              res = await removeFromCart(widget.product.id);
                              if (res) {
                                widget.reload();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Something went wrong, please try again'),
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
                              setState(() {
                                _isOrdering = false;
                              });
                            },
                            child: !_isOrdering
                                ? const Text('Buy now')
                                : const CircularProgressIndicator(),
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
