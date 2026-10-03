import 'dart:async';

import 'package:flutter/material.dart';

/// Manages the state and animation of the home page.
class HomePageProvider extends ChangeNotifier {

  /// Stores the current offset of each marquee.
  final Map<String, double> _offsets = {};

  /// Stores how far each marquee needs to move.
  final Map<String, double> _overflows = {};

  /// Stores the movement speed of each marquee.
  final Map<String, double> _speeds = {};

  /// Stores the active timer for each marquee.
  final Map<String, Timer> _timers = {};

  /// Stores the pause timer for each marquee.
  final Map<String, Timer> _pauseTimers = {};

  /// Returns the current offset of a marquee.
  double getOffset(String id) {
    return _offsets[id] ?? 0;
  }

  /// Starts a marquee when its text is wider than its container.
  void initializeMarquee({
    required String id,
    required double textWidth,
    required double availableWidth,
    double speed = 40,
  }) {
    if (textWidth <= availableWidth) {
      _stopMarquee(id);
      _offsets[id] = 0;
      notifyListeners();
      return;
    }

    final overflow = textWidth - availableWidth;

    if (_overflows[id] == overflow &&
        _speeds[id] == speed &&
        _timers[id]?.isActive == true) {
      return;
    }

    _stopMarquee(id);

    _overflows[id] = overflow;
    _speeds[id] = speed;
    _offsets[id] = 0;

    _startMarquee(id);
  }

  /// Starts moving the text from left to right.
  void _startMarquee(String id) {
    final overflow = _overflows[id];
    final speed = _speeds[id];

    if (overflow == null || speed == null) {
      return;
    }

    _timers[id]?.cancel();

    const interval = Duration(milliseconds: 16);

    _timers[id] = Timer.periodic(
      interval,
          (_) {
        final currentOffset = _offsets[id] ?? 0;
        final movement = speed * 0.016;
        final nextOffset = currentOffset + movement;

        if (nextOffset >= overflow) {
          _offsets[id] = overflow;
          notifyListeners();

          _timers[id]?.cancel();
          _timers.remove(id);

          _startPause(id);
          return;
        }

        _offsets[id] = nextOffset;
        notifyListeners();
      },
    );
  }

  /// Waits before restarting the marquee.
  void _startPause(String id) {
    _pauseTimers[id]?.cancel();

    _pauseTimers[id] = Timer(
      const Duration(milliseconds: 700),
          () {
        if (!hasListeners) {
          return;
        }

        _offsets[id] = 0;
        notifyListeners();

        _startMarquee(id);
      },
    );
  }

  /// Stops all timers associated with one marquee.
  void _stopMarquee(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);

    _pauseTimers[id]?.cancel();
    _pauseTimers.remove(id);
  }

  /// Stops a marquee and resets its position.
  void stopMarquee(String id) {
    _stopMarquee(id);

    _offsets[id] = 0;
    _overflows.remove(id);
    _speeds.remove(id);
  }

  @override
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }

    for (final timer in _pauseTimers.values) {
      timer.cancel();
    }

    _timers.clear();
    _pauseTimers.clear();

    super.dispose();
  }
}