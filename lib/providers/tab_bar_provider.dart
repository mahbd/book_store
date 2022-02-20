import 'package:flutter/material.dart';

class TabPageChanger extends ChangeNotifier {
  Widget? _page;
  TabPageChanger(this._page);

  get getPage => _page;
  void setPage(Widget? page) {
    _page = page;
    notifyListeners();
  }
}
