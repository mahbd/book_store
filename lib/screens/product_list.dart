import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key, this.headerChild}) : super(key: key);
  final Widget? headerChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          if (headerChild != null) headerChild!,
          Expanded(
            child: ListView.builder(
              itemCount: 30,
              // itemExtent: 100,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 7,
                  ),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                                'Product Name',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                'Product Description',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$100',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.favorite),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.shopping_cart),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
