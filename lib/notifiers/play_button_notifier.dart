import 'package:flutter/cupertino.dart';

class PlayButtonNotifier extends ValueNotifier<PlayButtonState> {
  PlayButtonNotifier() : super(_initialValue);

  static const _initialValue = PlayButtonState.paused;
}

enum PlayButtonState { paused, playing, loading }
