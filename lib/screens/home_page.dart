import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/product_model.dart';
import '../widget/category_list.dart';
import '../widget/row_product_list.dart';
import '../widget/search_widget.dart';
import '../models/category_model.dart';
import '../widget/featured.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Category _currentCategory = categories[0];

    void _updateSearchText(String value) {}

    void _updateCategory(Category value) {
      setState(() {
        _currentCategory = value;
      });
    }

    SliverPersistentHeader makeCategoriesWidget() {
      return SliverPersistentHeader(
        pinned: true,
        delegate: _SliverAppBarDelegate(
          minHeight: 25.0,
          maxHeight: 45.0,
          child: CategoryList(
            categories: categories,
            changeCategory: _updateCategory,
            currentCategory: _currentCategory,
          ),
        ),
      );
    }

    SliverFixedExtentList makeFixedExtent(Widget child, double height) {
      return SliverFixedExtentList(
        itemExtent: height,
        delegate: SliverChildListDelegate(
          [child],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SearchWidget(updateSearchText: _updateSearchText),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    makeFixedExtent(const SizedBox(height: 15), 15.0),
                    makeFixedExtent(const Featured(), 250.0),
                    makeFixedExtent(const SizedBox(height: 15), 20.0),
                    makeCategoriesWidget(),
                    SliverFixedExtentList(
                      itemExtent: 250,
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return _ProductList(
                          category: categories[index],
                        );
                      }, childCount: categories.length),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  category.showName,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/category-products',
                    arguments: category,
                  );
                },
                child: Text(
                  'See All',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: FutureBuilder(
            future: productListOfCategory(category),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding: const EdgeInsets.all(50),
                  child: const SizedBox(
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (snapshot.hasData) {
                  return RowProductList(
                    products: convertToProductList(snapshot.data!),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Failed to load data',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

List<Product> convertToProductList(dynamic data) {
  List<Product> products = data.map<Product>((e) => e as Product).toList();
  return products;
}
