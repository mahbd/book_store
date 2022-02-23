import 'package:book_store/constants.dart';
import 'package:flutter/material.dart';

import '../models/category_model.dart';

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
                Navigator.of(context).pushNamed(
                  NamedRoutes.categoryProducts,
                  arguments: categories[index],
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
