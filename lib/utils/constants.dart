import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int kSplashColor = 0xffF2DDE6;
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

const kSubMainTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Color(kSecondaryColor),
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
  statusBarColor: kPrimaryColor,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarColor: kPrimaryColor,
  systemNavigationBarDividerColor: Colors.grey,
);

const kInfoDialogItemTitleStyle = TextStyle(
    color: kPrimaryColor, fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: 1.5);
const kInfoDialogItemDetailStyle = TextStyle(color: kPrimaryColor, fontSize: 14.0);

const kTileTitleStyle = TextStyle(fontSize: 16.0, color: kTileTitleColor);
const kTileAlbumStyle = TextStyle(fontSize: 14.0, color: kTileAlbumColor);
const kHeaderTitleStyle = TextStyle(fontSize: 18.0, color: Colors.white);
const kHeaderAlbumStyle = TextStyle(fontSize: 14.0, color: Colors.white70);

const kProgressIndicatorColor = Color(0xffB1D4E0);
const kMusicIconColor = Colors.white;

// const kTileColor = Color(0x80145DA0);
const kScaffoldBackgroundColor = Color(0x80145DA0);
const kIconColor = Color(0xffB1D4E0);
const kDisabledIconColor = Color(0x4dB1D4E0);
const kPrimaryColor = Color(0xff0C2D48);
// const kModalBottomSheetColor = Color(0xcc0C2D48);
const kCircleAvatarColor = Color(0x700C2D48);
const kTileTitleColor = Color(0xffB1D4E0);
const kTileAlbumColor = Color(0x73B1D4E0);
const kProgressBarColor = Colors.white;
const kThumbGlowColor = Color(0x80ffffff);
const kBufferedBarColor = Color(0x4dB1D4E0);
const kBaseBarColor = Color(0xff2E8BC0);
const kMusicTonesColor = Color(0x4dB1D4E0);
const kSearchDelegateColor = Color(0xe60C2D48);
const kAddPlaylistContainerColor = Color(0x4dffffff);
const kDialogColor = Color(0xffB1D4E0);
const kNowPlayingTitleStyle = TextStyle(fontSize: 16.0, color: kNowPlayingTitleColor);
const kNowPlayingAlbumStyle = TextStyle(fontSize: 14.0, color: kNowPlayingAlbumColor);
const kNowPlayingTitleColor = Color(0xffe9ff70);
const kNowPlayingAlbumColor = Color(0xa6e9ff70);
const kNowPlayingTileColor = Color(0xff3d405b);
const kNowPlayingMusicIconColor = Color(0xffe9ff70);
