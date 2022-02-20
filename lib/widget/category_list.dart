import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_list.dart';
import '../models/category_model.dart';
import '../providers/tab_bar_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList(
      {Key? key,
      required this.categories,
      required this.changeCategory,
      required this.currentCategory})
      : super(key: key);

  final List<Category> categories;
  final Category? currentCategory;
  final Function changeCategory;

  @override
  Widget build(BuildContext context) {
    TabPageChanger _tabPageChanger = Provider.of<TabPageChanger>(context);
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: MaterialButton(
              minWidth: 100,
              shape: const StadiumBorder(),
              color: Colors.black,
              onPressed: () {
                _tabPageChanger.setPage(
                  ProductList(
                    title: categories[index].showName,
                    category: categories[index],
                  ),
                );
              },
              child: Text(
                categories[index].name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
