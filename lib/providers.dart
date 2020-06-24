import 'package:flutter/material.dart';

class ViewNotifier extends ChangeNotifier {
  var show = {
    'startMeasuring': true,
    'stopMeasuring': false,
    'buildChart': false,
  };

  void switchView(String index) {
    print(index);
    if (show[index] == true) {
      show[index] = false;
      notifyListeners();
    } else if (show[index] == false) {
      show[index] = true;
      notifyListeners();
    }
  }
}