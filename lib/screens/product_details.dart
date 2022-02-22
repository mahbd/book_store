import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tab_bar_provider.dart';
import '../models/product_model.dart';
import '../widget/functions.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final TextEditingController _quantityController = TextEditingController();
  int _quantity = 1;
  bool isCarting = false;
  bool isOrdering = false;
  @override
  Widget build(BuildContext context) {
    TabPageChanger _tabPageChanger = Provider.of<TabPageChanger>(context);
    _quantityController.text = _quantity.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
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
                  widget.product.image,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.name,
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
                        "Price: ${widget.product.price}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                      ),
                      Text(
                        "Stock: ${widget.product.stock}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6!.color,
                        ),
                      ),
                    ],
                  ),
                  // const Icon(
                  //   Icons.favorite_border,
                  //   size: 35,
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Description', style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: 10),
              Text(
                widget.product.description,
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
                        if (_quantity < widget.product.stock) {
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
                    onPressed: () async {
                      setState(() {
                        isCarting = true;
                      });
                      bool res = await addToCart(widget.product.id, _quantity);
                      if (res) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text('Added to cart'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Something went wrong'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                      setState(() {
                        isCarting = false;
                      });
                    },
                    child: !isCarting
                        ? const Text('Add to cart')
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    onPressed: () async {
                      setState(() {
                        isOrdering = true;
                      });
                      bool res = await addToOrder(widget.product.id, _quantity,
                          widget.product.price * _quantity);
                      if (res) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Success'),
                            content: const Text('Ordered Successfully'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Something went wrong'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                      setState(() {
                        isOrdering = false;
                      });
                    },
                    child: !isOrdering
                        ? Text(
                            'Buy now ${(_quantity * widget.product.price).toStringAsFixed(2)}')
                        : const CircularProgressIndicator(),
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
