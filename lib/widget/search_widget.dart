import 'dart:convert';

import 'package:book_store/models/product_model.dart';
import 'package:book_store/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../providers/tab_bar_provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
    required this.updateSearchText,
  }) : super(key: key);

  final Function updateSearchText;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String text = '';
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    TabPageChanger tabPageChanger = Provider.of<TabPageChanger>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 50,
        child: TextField(
          onSubmitted: (value) async {
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            String accessToken = _prefs.getString('access_token') ?? '';
            setState(() {
              isSearching = true;
            });
            try {
              http.Response response = await http.get(
                Uri.parse("$api/api/products/?search=$value"),
                headers: {'Authorization': 'Bearer $accessToken'},
              );
              if (response.statusCode == 200) {
                List<Product> products = (jsonDecode(response.body) as List)
                    .map((e) => Product.fromJson(e))
                    .toList();
                if (products.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('No results found'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                } else {
                  tabPageChanger.setPage(
                    ProductList(
                      title: "Search Result(${products.length})",
                      products: products,
                    ),
                  );
                }
              }
            } catch (e) {
              setState(() {
                isSearching = false;
              });
            }
            setState(() {
              isSearching = false;
            });
          },
          onChanged: (value) => setState(() => text = value),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: "Search",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(
                width: 4,
                color: Theme.of(context).primaryColor,
              ),
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: !isSearching
                ? text.isEmpty
                    ? null
                    : Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isSearching = true;
                            });
                          },
                        ),
                      )
                : const CircularProgressIndicator(strokeWidth: 6),
          ),
        ),
      ),
    );
  }
}
