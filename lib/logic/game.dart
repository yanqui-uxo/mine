import 'dart:math';

import 'package:flutter/foundation.dart';

import 'board_shape.dart';
import 'game_timer.dart';
import 'generation_info.dart';
import 'square.dart';
import 'variants.dart';

enum GameState { notStarted, started, paused, lose, win }

typedef Board = Map<Point<int>, Square>;

class Game with ChangeNotifier {
  GameState _gameState = GameState.notStarted;
  GameState get gameState => _gameState;

  final BoardShape shape;
  final Map<int, int> mineNums;
  final NeighborFunction neighbors;
  final GenerationFunction _generateBoard;

  final GameTimer timer = GameTimer();

  // Nullable, because no board makes sense prior to generation
  Board? _board;
  Board? get board => _board;

  Game(
      {required this.shape,
      required this.mineNums,
      NeighborFunction? neighbors,
      generateBoard = simpleGenerateBoard})
      : assert(!mineNums.containsKey(0)),
        assert(mineNums.values.every((x) => x > 0)),
        neighbors = neighbors ?? mooreNeighborhood,
        _generateBoard = generateBoard;

  void _generate(Point<int> safePoint) {
    assert(gameState == GameState.notStarted);
    assert(mineNums.keys.reduce((x, y) => x + y) < shape.points.length,
        "Too many mines");
    assert(
        shape.points.contains(safePoint), "Board does not contain safePoint");

    final info = GenerationInfo(
        boardShape: shape, mineNums: mineNums, safePoint: safePoint);

    _board = Map.unmodifiable(_generateBoard(info));
    final generatedPoints = _board!.keys.toSet();

    assert(generatedPoints.difference(shape.points).isEmpty,
        "Generated point outside of shape");
    assert(shape.points.length == generatedPoints.length,
        "Not all points in shape generated");

    _gameState = GameState.started;

    timer.start();

    notifyListeners();
  }

  void _reveal(Point<int> p) {
    assert(gameState == GameState.started);

    final sq = _board![p]!;

    if (sq.revealed) return;

    sq.reveal();

    if (sq.mines > 0) {
      _gameState = GameState.lose;

      for (Point p in shape.points) {
        _board![p]!.reveal();
      }

      timer.stop();

      notifyListeners();
      return;
    } else if (!board!.values.any((s) => s.mines == 0 && !s.revealed)) {
      _gameState = GameState.win;

      timer.stop();

      notifyListeners();
    }

    final ns = neighbors(p, shape);
    if (ns.every((p) => _board![p]!.mines == 0)) {
      ns.forEach(_reveal);
    }
  }

  void _chord(Point<int> p) {
    assert(gameState == GameState.started);

    assert(board![p]!.revealed);

    final neighborPoints = neighbors(p, shape);
    final neighborSquares = neighborPoints.map((p) => board![p]!);
    final neighborMines =
        neighborSquares.map((s) => s.mines).reduce((x, y) => x + y);
    final neighborFlags =
        neighborSquares.map((s) => s.flags).reduce((x, y) => x + y);

    if (neighborMines == neighborFlags) {
      neighborPoints.where((p) => !board![p]!.flagged).forEach(_reveal);
    }
  }

  void leftClick(Point<int> p) {
    switch (_gameState) {
      case GameState.notStarted:
        _generate(p);
        _reveal(p);
        break;
      case GameState.started:
        final s = board![p]!;
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
      board![p]!.flag();
    }
  }

  void pause() {
    _gameState = GameState.paused;
    timer.stop();
    notifyListeners();
  }
}
