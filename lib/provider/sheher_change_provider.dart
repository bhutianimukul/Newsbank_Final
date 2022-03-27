import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheherChangeProvider with ChangeNotifier {
  String sheher = "";
  String getSheher() {
    // notifyListeners();

    return sheher;
  }

  void updateSheher(String s) {
    this.sheher = s;
    notifyListeners();
  }
}
