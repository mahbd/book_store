import 'package:book_store/models/category_model.dart';
import 'package:book_store/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tab_bar_provider.dart';

Product product = Product(
  id: 1,
  name: "The Lean Startup",
  category: categories[0],
  image:
      "https://images-na.ssl-images-amazon.com/images/I/51Zymoq7UnL._SX325_BO1,204,203,200_.jpg",
  createdAt: DateTime.now(),
  description:
      "This book is a startup guide for small business owners. It's a practical guide to how to get started, grow your business, and become a successful entrepreneur.",
  price: 25.99,
  isWishlisted: 0,
  isInCart: 0,
  stock: 10,
  isFeatured: 0,
);

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  TextEditingController _quantityController = TextEditingController();
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    TabPageChanger _tabPageChanger = Provider.of<TabPageChanger>(context);
    _quantityController.text = _quantity.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Image.network(
                  product.image,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price: ${product.price}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                      ),
                      Text(
                        "Stock: ${product.stock}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.favorite,
                    size: 35,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Description', style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: 10),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).textTheme.headline6!.color!,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) {
                            _quantity--;
                          }
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: _quantityController,
                      onChanged: (value) {
                        setState(() {
                          _quantity = int.parse(value);
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      cursorColor: Colors.transparent,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).textTheme.headline6!.color!,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (_quantity < product.stock) {
                          setState(() {
                            _quantity++;
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: const Text('Add to cart'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                        'Buy now ${(_quantity * product.price).toStringAsFixed(2)}'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
