import 'dart:math';

import 'package:flutter/foundation.dart';

@immutable
abstract class BoardShape {
  Set<Point<int>> get points;

  Rectangle<int> get boundingBox;

  static Rectangle<int> generateBoundingBox(Set<Point<int>> points) {
    Point<int>? topLeft;
    Point<int>? bottomRight;

    for (final p in points) {
      topLeft ??= p;
      bottomRight ??= p;

      if (p.x < topLeft.x) {
        topLeft = Point(p.x, topLeft.y);
      }
      if (p.y < topLeft.y) {
        topLeft = Point(topLeft.x, p.y);
      }
      if (p.x > bottomRight.x) {
        bottomRight = Point(p.x, bottomRight.y);
      }
      if (p.y > bottomRight.y) {
        bottomRight = Point(bottomRight.x, p.y);
      }
    }

    return Rectangle.fromPoints(topLeft!, bottomRight!);
  }
}
