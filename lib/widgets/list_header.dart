import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ListHeader extends StatelessWidget {
  const ListHeader(this.constraints,
      {super.key, required this.title, this.color});

  final String title;
  final Color? color;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: Container(
        height: 65,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: kGradientColors,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Divider(
              height: 3,
              thickness: 3,

              /// Takes the width of the mobile screen and multiplies it with 0.45.
              indent: constraints.maxWidth * 0.45,
              endIndent: constraints.maxWidth * 0.45,
              color: const Color(0xffE5E7EA),
            ),
            Text(title, textAlign: TextAlign.center, style: kListTitleStyle),
          ],
        ),
      ),
    );
  }
}
