import 'package:flutter/material.dart';

import '../models/opacity_change.dart';
import '../utils/constants.dart';
import 'animated_app_bar.dart';
import 'list_header.dart';

class FlexibleHeaderBottom extends StatelessWidget {
  const FlexibleHeaderBottom({
    super.key,
    required this.onOpacityChange,
    required this.opacityChanger,
  });

  /// BuildContext is required to determine which container is feasible.
  final Function(BuildContext) onOpacityChange;
  final OpacityChange opacityChanger;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        onOpacityChange(context);
        return Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedAppBar(
                title: 'Recorder',
                opacity: opacityChanger.subtitleOpacityLevel,
              ),
              ListHeader(
                constraints,
                color: const Color(kBackgroundColor),
                title: 'RECORDINGS',
              ),
            ],
          ),
        );
      },
    );
  }
}
