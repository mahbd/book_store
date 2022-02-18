import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Icon icon;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
  });
}

List<Category> categories = const [
  Category(
    id: 'fiction',
    name: 'Fiction',
    icon: Icon(Icons.book),
  ),
  Category(
    id: 'nonfiction',
    name: 'Non-Fiction',
    icon: Icon(Icons.book),
  ),
  Category(
    id: 'biography',
    name: 'Biography',
    icon: Icon(Icons.book),
  ),
  Category(
    id: 'history',
    name: 'History',
    icon: Icon(Icons.book),
  ),
  Category(
    id: 'poetry',
    name: 'Poetry',
    icon: Icon(Icons.book),
  ),
  Category(
    id: 'art',
    name: 'Art',
    icon: Icon(Icons.book),
  ),
];
