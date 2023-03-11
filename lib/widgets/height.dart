import 'package:flutter/material.dart';

/// Creates a SizedBox with a required height.
class Height extends StatelessWidget {
  const Height(this.height, {super.key});

  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
