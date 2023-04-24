import 'dart:math';

import 'package:flutter/foundation.dart';

class Square with ChangeNotifier {
  final int mines;
  final Point<int> point;

  final List<int> flagNums;
  int? _flagIndex;

  int get flags => _flagIndex != null ? flagNums[_flagIndex!] : 0;
  bool get flagged => flags != 0;

  bool _revealed = false;
  bool get revealed => _revealed;

  Square(
      {required this.mines,
      required this.point,
      required Map<int, int> mineNums})
      : flagNums = List.unmodifiable(mineNums.keys.toList()..sort());

  void reveal() {
    if (revealed) return;

    _flagIndex = null;
    _revealed = true;
    notifyListeners();
  }

  void flag() {
    if (_flagIndex == null) {
      _flagIndex = 0;
    } else {
      _flagIndex = _flagIndex! + 1;
      if (_flagIndex! >= flagNums.length) {
        _flagIndex = null;
      }
    }

    notifyListeners();
  }
}
