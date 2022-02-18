import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 50,
        child: TextField(
          onSubmitted: (value) => widget.updateSearchText(value),
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
            suffixIcon: text.isEmpty
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
                        widget.updateSearchText('');
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
