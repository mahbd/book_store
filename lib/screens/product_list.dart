import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    Key? key,
    this.headerChild,
    this.category,
    this.products,
    this.title,
  }) : super(key: key);

  final String? title;
  final Widget? headerChild;
  final Category? category;
  final List<Product>? products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Product List'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          if (headerChild != null) headerChild!,
          if (products != null) _RenderProductList(products: products),
          if (products == null && category != null)
            FutureBuilder(
              future: productListOfCategory(category!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("Waiting for product list");
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData) {
                    return _RenderProductList(
                        products: snapshot.data as List<Product>);
                  } else {
                    return const Center(child: Text('No products found'));
                  }
                }
              },
            ),
        ],
      ),
    );
  }
}

class _RenderProductList extends StatelessWidget {
  const _RenderProductList({Key? key, required this.products})
      : super(key: key);
  final List<Product>? products;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: products?.length ?? 0,
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
                    child: Image.network(
                      products![index].image,
                      fit: BoxFit.cover,
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
                          products![index].name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: Text(
                            products![index].description,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${products![index].price}',
                                style: Theme.of(context).textTheme.headline6,
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
    );
  }
}
