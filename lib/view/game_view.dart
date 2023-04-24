import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game.dart';
import '../logic/rectangle.dart';
import 'game_state_view.dart';
import 'game_timer_view.dart';
import 'game_grid.dart';

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Game>(
        create: (_) =>
            Game(shape: RectangleBoard(10, 10), mineNums: {1: 5, 2: 5, 3: 5}),
        builder: (_, __) => Column(children: const [
              GameTimerView(),
              GameStateView(),
              Expanded(
                  child: SizedBox.expand(child: FittedBox(child: GameGrid())))
            ]));
  }
}
