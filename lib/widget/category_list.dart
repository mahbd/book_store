import 'package:book_store/screens/product_list.dart';

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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductList()),
                  );
                },
                child: Column(
                  children: [
                    categories[index].icon,
                    const SizedBox(height: 10),
                    Text(
                      categories[index].showName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline1!.color,
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
