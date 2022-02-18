import 'package:book_store/widget/search_widget.dart';
import 'package:flutter/material.dart';

import '../widget/featured.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String _searchText = '';

    void _updateSearchText(String value) {
      setState(() {
        _searchText = value;
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(updateSearchText: _updateSearchText),
              const Featured(),
            ],
          ),
        ),
      ),
    );
  }
}
