import 'package:flutter/material.dart';

class CreateModel extends ChangeNotifier {
  bool time = false;
  
  void change() async {
    if (time == true) {
      print("OK");
    }
    notifyListeners();
  }
}
