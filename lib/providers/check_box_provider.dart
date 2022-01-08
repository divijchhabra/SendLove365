import 'package:flutter/foundation.dart';

class CheckBoxProvider extends ChangeNotifier {
  bool _checked = false;

  bool get checked => _checked;

  void changeCheck() {
    _checked = !_checked;

    notifyListeners();
  }
}
