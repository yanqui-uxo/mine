import 'board_shape.dart';
import 'variants.dart';

class GridInfo {
  final BoardShape shape;
  final Map<int, int> mineNums;
  final NeighborFunction neighbors;
  final GenerationFunction generateBoard;

  GridInfo(
      {required this.shape,
      required this.mineNums,
      required this.neighbors,
      required this.generateBoard});
}
