import 'dart:convert';
import 'package:book_store/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/product_model.dart';
import '../providers/tab_bar_provider.dart';
import 'product_details.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<List<Order>> _getWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse("$api/api/orders/"), headers: {
      'Authorization': 'Bearer $accessToken',
    });
    final List<Order> orderList = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var item in data) {
        Product? product = await productFromHttp(item['item']);
        Order order = Order(
          id: item['id'],
          product: product,
          quantity: item['quantity'],
          price: double.parse(item['total_price']),
          status: item['status'],
        );
        orderList.add(order);
      }
    } else {
      throw Exception('Failed to load orderlist');
    }
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _getWishList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Order List'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
            final List<Order> orders = snapshot.data!;
            final TextEditingController _quantityController =
                TextEditingController();
            _quantityController.text = '1';
            return Scaffold(
              appBar: AppBar(
                title: const Text('Order List'),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return _RenderOrder(order: orders[index]);
                },
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Order List'),
            ),
            body: const Center(
              child: Text('No orders found'),
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

class _RenderOrder extends StatefulWidget {
  const _RenderOrder({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  _RenderOrderState createState() => _RenderOrderState();
}

class _RenderOrderState extends State<_RenderOrder> {
  @override
  Widget build(BuildContext context) {
    TabPageChanger tabPageChanger = Provider.of<TabPageChanger>(context);
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
                    product: widget.order.product,
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
                  widget.order.product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.order.product.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text("Quantity: ${widget.order.quantity}",
                      style: Theme.of(context).textTheme.subtitle1),
                  Text("Price: ${widget.order.price}",
                      style: Theme.of(context).textTheme.subtitle1),
                  Text("Order Status: ${widget.order.status}",
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
