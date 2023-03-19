import 'package:flutter/material.dart';

class ProgressBarNotifier extends ValueNotifier<ProgressBarState> {
  ProgressBarNotifier() : super(_initialValue);

  static const _initialValue = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}

class ProgressBarState {
  const ProgressBarState(
      {required this.current, required this.buffered, required this.total});
  final Duration current;
  final Duration buffered;
  final Duration total;
}
