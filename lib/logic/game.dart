import 'dart:math';

import 'package:flutter/foundation.dart';

import 'game_grid.dart';
import 'game_timer.dart';
import 'grid_info.dart';
import 'square.dart';

enum GameState { notStarted, started, paused, lose, win }

typedef Board = Map<Point<int>, Square>;

class Game with ChangeNotifier {
  GameState _gameState = GameState.notStarted;
  GameState get gameState => _gameState;

  final GameGrid grid;

  final GameTimer timer = GameTimer();

  Game(GridInfo info) : grid = GameGrid(info);

  void _generate(Point<int> safePoint) {
    assert(gameState == GameState.notStarted);

    grid.generate(safePoint);

    _gameState = GameState.started;

    timer.start();

    notifyListeners();
  }

  bool _lossTest() {
    if (grid.mineRevealed) {
      _gameState = GameState.lose;

      for (Point p in grid.info.shape.points) {
        grid.board![p]!.reveal();
      }

      timer.stop();

      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  void _reveal(Point<int> p) {
    assert(gameState == GameState.started);

    grid.reveal(p);

    if (_lossTest()) {
      return;
    } else if (!grid.board!.values.any((s) => s.mines == 0 && !s.revealed)) {
      _gameState = GameState.win;

      timer.stop();

      notifyListeners();
    }
  }

  void _chord(Point<int> p) {
    assert(gameState == GameState.started);

    grid.chord(p);

    _lossTest();
  }

  void leftClick(Point<int> p) {
    switch (_gameState) {
      case GameState.notStarted:
        _generate(p);
        _reveal(p);
        break;
      case GameState.started:
        final s = grid.board![p]!;
        if (!s.flagged) {
          if (s.revealed) {
            _chord(p);
          } else {
            _reveal(p);
          }
        }
        break;
      default:
        break;
    }
  }

  void rightClick(Point<int> p) {
    if (_gameState == GameState.started) {
      grid.board![p]!.flag();
    }
  }

  void pause() {
    _gameState = GameState.paused;
    timer.stop();
    notifyListeners();
  }
}
