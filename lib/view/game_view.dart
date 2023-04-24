import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game.dart';
import '../logic/grid_info.dart';
import '../logic/rectangle_board.dart';
import '../logic/variants.dart';
import 'game_state_view.dart';
import 'game_timer_view.dart';
import 'game_grid_view.dart';

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Game>(
        create: (_) => Game(GridInfo(
            shape: RectangleBoard(10, 10),
            mineNums: {1: 5, 2: 5, 3: 5},
            generateBoard: simpleGenerateBoard,
            neighbors: mooreNeighborhood)),
        builder: (_, __) => Column(children: const [
              GameTimerView(),
              GameStateView(),
              Expanded(
                  child:
                      SizedBox.expand(child: FittedBox(child: GameGridView())))
            ]));
  }
}
