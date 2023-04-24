import 'dart:math';

import 'package:flutter/foundation.dart';

import 'generation_info.dart';
import 'grid_info.dart';
import 'square.dart';

typedef Board = Map<Point<int>, Square>;

class GameGrid with ChangeNotifier {
  final GridInfo info;

  Board? board;

  bool _mineRevealed = false;
  bool get mineRevealed => _mineRevealed;

  GameGrid(this.info)
      : assert(!info.mineNums.containsKey(0)),
        assert(info.mineNums.values.every((x) => x > 0));

  void generate(Point<int> safePoint) {
    assert(
        info.mineNums.keys.reduce((x, y) => x + y) < info.shape.points.length,
        "Too many mines");
    assert(info.shape.points.contains(safePoint),
        "Board does not contain safePoint");

    final genInfo = GenerationInfo(
        boardShape: info.shape, mineNums: info.mineNums, safePoint: safePoint);

    board = Map.unmodifiable(info.generateBoard(genInfo));
    final generatedPoints = board!.keys.toSet();

    assert(generatedPoints.difference(info.shape.points).isEmpty,
        "Generated point outside of shape");
    assert(info.shape.points.length == generatedPoints.length,
        "Not all points in shape generated");
  }

  void reveal(Point<int> p, {bool notify = true}) {
    final sq = board![p]!;

    if (sq.revealed || sq.flagged) return;

    sq.reveal();

    if (sq.mines > 0) {
      _mineRevealed = true;
    }

    final ns = info.neighbors(p, info.shape);
    if (ns.every((p) => board![p]!.mines == 0)) {
      for (final p in ns) {
        reveal(p, notify: false);
      }
    }

    if (notify) notifyListeners();
  }

  void chord(Point<int> p) {
    assert(board![p]!.revealed);

    final neighborPoints = info.neighbors(p, info.shape);
    final neighborSquares = neighborPoints.map((p) => board![p]!);
    final neighborMines =
        neighborSquares.map((s) => s.mines).reduce((x, y) => x + y);
    final neighborFlags =
        neighborSquares.map((s) => s.flags).reduce((x, y) => x + y);

    if (neighborMines == neighborFlags) {
      for (final p in neighborPoints) {
        reveal(p, notify: false);
      }
    }

    notifyListeners();
  }

  void flag(Point<int> p) {
    board![p]!.flag();

    notifyListeners();
  }
}
