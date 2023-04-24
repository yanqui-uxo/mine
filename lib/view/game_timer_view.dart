import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game.dart';

class GameTimerView extends StatelessWidget {
  const GameTimerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Game game = Provider.of<Game>(context, listen: false);

    return AnimatedBuilder(
        animation: game.timer,
        builder: (_, __) => Text(game.timer.elapsed.toString()));
  }
}
