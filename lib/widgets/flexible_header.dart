import 'package:flutter/material.dart';

import '../models/opacity_change.dart';
import '../utils/constants.dart';

class FlexibleHeader extends StatelessWidget {
  const FlexibleHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onConstraining,
    required this.opacityChange,
    this.color = Colors.white,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Color? color;

  /// Implements what to be done when the dimensions of the container change.
  final Function(BoxConstraints) onConstraining;

  /// Changes the opacity level ot the app titles.
  final OpacityChange opacityChange;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        onConstraining(constraints);

        return Container(
          color: const Color(kBackgroundColor),
          margin: const EdgeInsets.only(bottom: 25),
          constraints: BoxConstraints.tightFor(
            width: constraints.biggest.width,
            height: constraints.biggest.height,
          ),
          child: AnimatedOpacity(
            opacity: opacityChange.mainTitleOpacityLevel,
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: kMainTitleStyle,
                ),
                Text(
                  subtitle,
                  style: kSubMainTitleStyle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
