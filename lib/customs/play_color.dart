import 'package:flutter/material.dart';

const int _primary = 0xff444349;
final Map<int, Color> _swatch = <int, Color>{
  50: const Color.fromRGBO(68, 67, 73, .1),
  100: const Color.fromRGBO(68, 67, 73, .2),
  200: const Color.fromRGBO(68, 67, 73, .3),
  300: const Color.fromRGBO(68, 67, 73, .4),
  400: const Color.fromRGBO(68, 67, 73, .5),
  500: const Color.fromRGBO(68, 67, 73, .6),
  600: const Color.fromRGBO(68, 67, 73, .7),
  700: const Color.fromRGBO(68, 67, 73, .8),
  800: const Color.fromRGBO(68, 67, 73, .9),
  900: const Color.fromRGBO(68, 67, 73, 1),
};

final MaterialColor playColor = MaterialColor(_primary, _swatch);
