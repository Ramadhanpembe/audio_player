import 'package:flutter/material.dart';

const int _primary = 0xff0C2D48;
final Map<int, Color> _swatch = <int, Color>{
  50: const Color.fromRGBO(12, 45, 72, .1),
  100: const Color.fromRGBO(12, 45, 72, .2),
  200: const Color.fromRGBO(12, 45, 72, .3),
  300: const Color.fromRGBO(12, 45, 72, .4),
  400: const Color.fromRGBO(12, 45, 72, .5),
  500: const Color.fromRGBO(12, 45, 72, .6),
  600: const Color.fromRGBO(12, 45, 72, .7),
  700: const Color.fromRGBO(12, 45, 72, .8),
  800: const Color.fromRGBO(12, 45, 72, .9),
  900: const Color.fromRGBO(12, 45, 72, 1),
};

final MaterialColor playColor = MaterialColor(_primary, _swatch);
