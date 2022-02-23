import 'package:flutter/material.dart';

class TabPageChanger extends ChangeNotifier {
  Widget? _page;
  int _tabIndex = 0;
  TabPageChanger(this._page, this._tabIndex);

  get getPage => _page;
  void setPage(Widget? page) {
    _page = page;
    notifyListeners();
  }

  get getTabIndex => _tabIndex;
  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}
