import 'package:book_store/screens/product_details.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import 'package:flutter/material.dart';

import 'future_image.dart';
import '../providers/tab_bar_provider.dart';

class RowProductList extends StatelessWidget {
  const RowProductList({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    TabPageChanger tabPageChanger = Provider.of<TabPageChanger>(context);
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: GestureDetector(
              onTap: () {
                tabPageChanger.setPage(
                  ProductDetails(product: products[index]),
                );
              },
              child: SizedBox(
                width: 100,
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
                        height: 40,
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).selectedRowColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "TK: ${products[index].price}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).selectedRowColor,
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
  }
}
