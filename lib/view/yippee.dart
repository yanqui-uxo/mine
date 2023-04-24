import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game.dart';
import 'game_grid_view.dart';

class Yippee extends StatelessWidget {
  final File loseFile = File('imgs/fuck.gif');
  final File winFile = File('imgs/winner.gif');

  Yippee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
        child: const GameGridView(),
        builder: (_, game, grid) {
          switch (game.gameState) {
            case GameState.win:
              return Stack(children: [grid!, Image.file(winFile)]);
            case GameState.lose:
              return Stack(children: [grid!, Image.file(loseFile)]);
            default:
              return grid!;
          }
        });
  }
}
