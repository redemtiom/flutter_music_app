import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier {
  bool _playing = false;
  late AnimationController controller;
  Duration _songDuration = Duration(milliseconds: 0);
  Duration _current = Duration(milliseconds: 0);

  bool get playing => _playing;
  Duration get songDuration => _songDuration;
  Duration get current => _current;
  String get songTotalDuration => printDuration(_songDuration);
  String get currentSecond => printDuration(_current);

  double get percent => (_songDuration.inSeconds > 0)
      ? _current.inSeconds / _songDuration.inSeconds
      : 0;

  set playing(bool value) {
    _playing = value;
    notifyListeners();
  }

  set songDuration(Duration value) {
    _songDuration = value;
    notifyListeners();
  }

  set current(Duration value) {
    _current = value;
    notifyListeners();
  }

  String printDuration(Duration value) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    String twoDigitsMinutes = twoDigits(value.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(value.inSeconds.remainder(60));

    return '$twoDigitsMinutes:$twoDigitsSeconds';
  }
}
