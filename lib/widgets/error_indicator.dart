import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Error!',
        style: TextStyle(color: kDisabledIconColor, fontSize: 24.0),
      ),
    );
  }
}
