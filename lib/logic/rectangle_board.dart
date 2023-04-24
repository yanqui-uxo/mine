import 'dart:math';

import 'board_shape.dart';

class RectangleBoard implements BoardShape {
  final int width;
  final int height;

  @override
  Rectangle<int> get boundingBox => Rectangle(0, 0, width - 1, height - 1);

  @override
  late final Set<Point<int>> points;

  RectangleBoard(this.width, this.height) {
    assert(width > 0, "Non-positive width");
    assert(height > 0, "Non-positive height");

    Set<Point<int>> ps = {};
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        ps.add(Point<int>(x, y));
      }
    }

    points = Set.unmodifiable(ps);
  }
}
