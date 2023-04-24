import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

class GameTimer with ChangeNotifier {
  static const tickMilliseconds = 50;
  final Stopwatch _stopwatch = Stopwatch();
  RestartableTimer? _timer;

  bool get active => _stopwatch.isRunning;

  Duration get elapsed => _stopwatch.elapsed;

  GameTimer() {
    _timer = RestartableTimer(
        const Duration(milliseconds: tickMilliseconds), notifyListeners);
  }

  void start() {
    _stopwatch.start();
    _timer ??= RestartableTimer(
        const Duration(milliseconds: tickMilliseconds), notifyListeners);
    _timer!.reset();
  }

  void stop() {
    _stopwatch.stop();
    _timer!.cancel();
    notifyListeners();
  }
}
