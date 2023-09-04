import 'package:flutter/material.dart';

class AddressChanger extends ChangeNotifier {
  int counter = 0;
  int get count => counter;

  showSelectedAddress(dynamic newValue) {
    counter = newValue;
    notifyListeners();
  }
}
