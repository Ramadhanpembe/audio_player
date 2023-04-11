import 'package:audio_player/utils/constants.dart';
import 'package:flutter/material.dart';

class EmptyListIndicator extends StatelessWidget {
  const EmptyListIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Empty',
        style: TextStyle(color: kDisabledIconColor, fontSize: 24.0),
      ),
    );
  }
}
