import 'dart:math';

import 'board_shape.dart';
import 'game.dart' show Board;
import 'generation_info.dart';
import 'square.dart';

typedef NeighborFunction = Set<Point<int>> Function(Point<int>, BoardShape);

typedef GenerationFunction = Board Function(GenerationInfo);

class BoardGenerationException implements Exception {
  String message;
  BoardGenerationException(this.message);
}

final Set<Point<int>> mooreOffsets = {
  const Point<int>(-1, -1),
  const Point<int>(0, -1),
  const Point<int>(1, -1),
  const Point<int>(-1, 0),
  const Point<int>(1, 0),
  const Point<int>(-1, 1),
  const Point<int>(0, 1),
  const Point<int>(1, 1)
};

NeighborFunction offsetNeighborFunction(Set<Point<int>> offsets) {
  Set<Point<int>> neighbors(Point<int> p, BoardShape boardShape) =>
      offsets.map((o) => p + o).where(boardShape.points.contains).toSet();

  return neighbors;
}

NeighborFunction mooreNeighborhood = offsetNeighborFunction(mooreOffsets);
NeighborFunction doubleMoore =
    offsetNeighborFunction(mooreOffsets.map((o) => o * 2).toSet());

final Set<Point<int>> twoRadiusOffsets = {
  const Point<int>(-1, -2),
  const Point<int>(0, -2),
  const Point<int>(1, -2),
  const Point<int>(-2, -1),
  const Point<int>(2, -1),
  const Point<int>(-2, 0),
  const Point<int>(2, 0),
  const Point<int>(-2, 1),
  const Point<int>(2, 1),
  const Point<int>(-1, 2),
  const Point<int>(0, 2),
  const Point<int>(1, 2)
};
NeighborFunction twoRadius = offsetNeighborFunction(twoRadiusOffsets);

Map<Point<int>, Square> simpleGenerateBoard(GenerationInfo info) {
  final ps = info.boardShape.points.toList();
  ps.remove(info.safePoint);

  final List<int> expandedNums = [];

  for (MapEntry<int, int> e in info.mineNums.entries) {
    for (int i = 0; i < e.value; i++) {
      expandedNums.add(e.key);
    }
  }

  while (expandedNums.length < ps.length) {
    expandedNums.add(0);
  }

  expandedNums.shuffle();

  final pointsToMines = Map.fromIterables(ps, expandedNums);
  pointsToMines[info.safePoint] = 0;

  return pointsToMines.map((k, v) =>
      MapEntry(k, Square(mines: v, point: k, mineNums: info.mineNums)));
}
