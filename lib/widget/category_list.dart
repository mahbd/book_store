import '../models/category_model.dart';
import 'package:flutter/material.dart';

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
            child: SizedBox(
              height: 50,
              child: Column(
                children: [
                  categories[index].icon,
                  const SizedBox(height: 10),
                  Text(categories[index].name),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
