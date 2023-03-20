import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int kSplashColor = 0xffF2DDE6;
const int kPrimaryColor = 0xff9F1D45;
const int kSecondaryColor = 0xffBA234D;
const int kDividerColor = 0xffF2F3F9;
const int kBackgroundColor = 0xffFFFEFF;

/// Maximum height of the AppBar when expanded.
const double kAppBarExpandedHeight = 300;

/// Height when the app titles animate and shift their position.
/// It is the height where either main title will stop being visible and subtitle will be visible or vice versa.
const double kAnimatedHeight = 200;

/// Maximum height of the AppBar when it is collapsed.
const double kCollapsedHeight = 110;

const List<Color> kGradientColors = [
  Color(0xffEEF1F8),
  Color(0xffF2F3F9),
  Color(0xffF6F7FD),
  Color(0xffFCFBFD),
  Color(0xffFFFEFF),
];

const kMainTitleStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Color(kPrimaryColor),
);

const kSubMainTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Color(kSecondaryColor),
);

const kAppTitle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: Color(kPrimaryColor),
);

const kListTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xff5E5E5E),
);

const kCallerTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xff6E6E6E),
);
const kPhoneTitleStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: Color(0xff6E6E6E),
);
const kTimeElapsedTitleStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Color(0xff6E6E6E),
);

/// New Ones - Added Specifically for Audio Player

const kSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.indigo,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
);
