import 'package:book_store/widget/category_list.dart';
import 'package:book_store/widget/row_product_list.dart';
import 'package:book_store/widget/search_widget.dart';
import 'package:flutter/material.dart';

import '../model/category_model.dart';
import '../widget/featured.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String _searchText = '';
    Category _currentCategory = categories[0];

    void _updateSearchText(String value) {
      setState(() {
        _searchText = value;
      });
    }

    void _updateCategory(Category value) {
      setState(() {
        _currentCategory = value;
      });
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
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Featured(),
                    const SizedBox(height: 20),
                    CategoryList(
                      categories: categories,
                      changeCategory: _updateCategory,
                      currentCategory: _currentCategory,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('New Arrivals',
                              style: Theme.of(context).textTheme.headline4),
                          Text('See All',
                              style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const RowProductList(),
                    const SizedBox(height: 20),
                    const ProductList(),
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

class ProductList extends StatelessWidget {
  const ProductList({
    Key? key,
  }) : super(key: key);

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
              Text('New Arrivals',
                  style: Theme.of(context).textTheme.headline4),
              Text('See All', style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const RowProductList(),
        const SizedBox(height: 20),
      ],
    );
  }
}
