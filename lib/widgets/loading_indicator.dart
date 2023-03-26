import 'package:flutter/material.dart';

import '../utils/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 32.0,
        height: 32.0,
        child: const CircularProgressIndicator(color: kProgressIndicatorColor),
      ),
    );
  }
}
