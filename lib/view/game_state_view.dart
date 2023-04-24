import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game.dart';

class GameStateView extends StatelessWidget {
  const GameStateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<Game>(builder: (_, game, __) {
        final String txt;

        switch (game.gameState) {
          case GameState.lose:
            txt = "u r loes :(";
            break;
          case GameState.win:
            txt = "ur win!!! :)";
            break;
          default:
            return const SizedBox();
        }

        return Text(txt);
      });
}
