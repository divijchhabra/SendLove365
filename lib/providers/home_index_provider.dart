import 'package:flutter/foundation.dart';

class HomeIndexProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void changeIndex(ind) {
    _index = ind;
    notifyListeners();
    print(_index);
  }
}
