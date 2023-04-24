import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game.dart';
import '../logic/square.dart';
import 'widget_number_view.dart';

// Should return a widget with constrained size
class SquareView extends StatelessWidget {
  final Point<int> point;
  const SquareView(this.point, {Key? key}) : super(key: key);

  Widget blankSquare() => const Icon(Icons.square);

  Widget _build(BuildContext context, Square? square) {
    final game = Provider.of<Game>(context, listen: false);

    if (square == null) {
      return blankSquare();
    }

    if (!square.revealed) {
      return square.flagged
          ? WidgetNumberView(const Icon(Icons.flag), square.flags)
          : blankSquare();
    }

    if (square.mines > 0) {
      return WidgetNumberView(const Icon(Icons.error), square.mines);
    } else {
      final neighborCount = game
          .neighbors(point, game.shape)
          .map((p) => game.board![p]!.mines)
          .reduce((x, y) => x + y);

      if (neighborCount > 0) {
        return Text(neighborCount.toString());
      } else {
        return const SizedBox();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<Square?>(
      builder: (context, square, __) => _build(context, square));
}
