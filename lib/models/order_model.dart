import 'package:book_store/models/product_model.dart';

class Order {
  final int id;
  final Product product;
  final int quantity;
  final double price;
  final String status;

  Order({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.status,
  });
}
