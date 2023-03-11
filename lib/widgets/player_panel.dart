import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';

class PlayerPanel extends StatelessWidget {
  const PlayerPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          splashColor: const Color(kSplashColor),
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          constraints: const BoxConstraints(),
          icon: const FaIcon(
            FontAwesomeIcons.arrowUpFromBracket,
            color: Color(0xff98265A),
          ),
          onPressed: () {},
        ),
        IconButton(
          splashColor: const Color(kSplashColor),
          icon: const FaIcon(
            FontAwesomeIcons.forwardFast,
            color: Color(0xff462038),
          ),
          onPressed: () {},
        ),
        IconButton(
          splashColor: const Color(kSplashColor),
          icon: const FaIcon(
            FontAwesomeIcons.play,
            color: Color(0xff462038),
          ),
          onPressed: () {},
        ),
        IconButton(
          splashColor: const Color(kSplashColor),
          icon: const FaIcon(
            FontAwesomeIcons.backwardFast,
            color: Color(0xff462038),
          ),
          onPressed: () {},
        ),
        IconButton(
          splashColor: const Color(kSplashColor),
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          constraints: const BoxConstraints(),
          icon: const FaIcon(
            FontAwesomeIcons.ellipsis,
            color: Color(0xff98265A),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
