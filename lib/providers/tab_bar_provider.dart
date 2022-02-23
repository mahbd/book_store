import 'package:flutter/material.dart';

class TabPageChanger extends ChangeNotifier {
  int _tabIndex = 0;
  TabPageChanger(this._tabIndex);

  get getTabIndex => _tabIndex;
  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}
