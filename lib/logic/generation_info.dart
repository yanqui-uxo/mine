import 'dart:math';

import 'package:flutter/foundation.dart';

import 'board_shape.dart';

@immutable
class GenerationInfo {
  final BoardShape boardShape;
  final Map<int, int> mineNums;
  final Point<int> safePoint;

  GenerationInfo(
      {required this.boardShape,
      required this.mineNums,
      required this.safePoint})
      : assert(boardShape.points.contains(safePoint),
            "safePoint not present in boardShape");
}
