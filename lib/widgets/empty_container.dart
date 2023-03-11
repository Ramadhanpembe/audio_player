import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// This container will be visible when there is not any recording in the app, such that when no visible recording tile.
class EmptyContainer extends StatelessWidget {
  const EmptyContainer({
    super.key,
    required this.padding,
  });

  final double padding;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: padding),
        child: Center(
          child: Text(
            'No recordings yet!',
            style: kCallerTitleStyle.copyWith(
              fontWeight: FontWeight.normal,
              color: const Color(kSecondaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
