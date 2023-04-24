import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game.dart';
import '../logic/square.dart';
import 'square_view.dart';

class GameGrid extends StatelessWidget {
  static const double squareWidth = 25;
  static const double squareHeight = 25;

  const GameGrid({Key? key}) : super(key: key);

  Widget _build(BuildContext context) {
    final game = Provider.of<Game>(context, listen: false);

    final box = game.shape.boundingBox;

    final List<TableRow> rows = [];
    for (int y = box.top; y <= box.bottom; y++) {
      final List<Widget> rowChildren = [];
      for (int x = box.left; x <= box.right; x++) {
        final p = Point(x, y);
        if (game.shape.points.contains(p)) {
          final square = game.board != null ? game.board![p] : null;

          rowChildren.add(GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => game.leftClick(p),
            onSecondaryTap: () => game.rightClick(p),
            child: SizedBox(
                width: squareWidth,
                height: squareHeight,
                child: FittedBox(
                  child: ChangeNotifierProvider<Square?>.value(
                      value: square, builder: (_, __) => SquareView(p)),
                )),
          ));
        } else {
          rowChildren
              .add(const SizedBox(width: squareWidth, height: squareHeight));
        }
      }

      rows.add(TableRow(children: rowChildren));
    }

    return Table(
        border: TableBorder.all(width: 1),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: rows);
  }

  @override
  Widget build(BuildContext context) => Selector<Game, Board?>(
      selector: (_, game) => game.board,
      builder: (context, game, _) => _build(context));
}
