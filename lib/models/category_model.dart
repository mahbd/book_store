import 'package:flutter/material.dart';

class Category {
  final String name;
  final String showName;
  final Image icon;

  const Category({
    required this.name,
    required this.showName,
    required this.icon,
  });
}

List<Category> categories = [
  Category(
    name: 'history',
    showName: 'History',
    icon: Image.asset('assets/category/history.jpeg', height: 50),
  ),
  Category(
    name: 'poetry',
    showName: 'Poetry',
    icon: Image.asset('assets/category/poetry.jpeg', height: 50),
  ),
  Category(
    name: 'fiction',
    showName: 'Fiction',
    icon: Image.asset('assets/category/fiction.jpeg', height: 50),
  ),
  Category(
    name: 'nonfiction',
    showName: 'Non-Fiction',
    icon: Image.asset('assets/category/earth.jpeg', height: 50),
  ),
  Category(
    name: 'biography',
    showName: 'Biography',
    icon: Image.asset('assets/category/biography.jpeg', height: 50),
  ),
];

Category getCategory(String name) {
  return categories.firstWhere((category) => category.name == name);
}
