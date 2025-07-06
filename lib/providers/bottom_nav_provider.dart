import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final List<Widget> body = [];

  void updateSelectedIndex(int newIndex) {
    debugPrint("The Selected Index before update is: $_selectedIndex");
    _selectedIndex = newIndex;
    debugPrint("The selected Index now is: $_selectedIndex");
    notifyListeners();
  }

  bool _showBottomNavBar = true;
  bool get showBottomNavBar => _showBottomNavBar;

  void updateShowBottomNav(bool showBottomNav) {
    // Future.delayed(const Duration(milliseconds: 500), () {
    // Do something
    _showBottomNavBar = showBottomNav;
    notifyListeners();
    // });
  }

  int _selectedCardMoreCard = 0;
  int get selectedMoreCard => _selectedCardMoreCard;

  void updateSelectedCardMoreCard(int index) {
    _selectedCardMoreCard = index;
    notifyListeners();
  }
}
