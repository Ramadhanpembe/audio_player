import 'package:audio_player/customs/play_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final kSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: playColor,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarColor: playColor,
  systemNavigationBarDividerColor: Colors.grey,
);

const kInfoDialogItemTitleStyle = TextStyle(
    color: kTileTitleColor, fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: 1.5);
const kInfoDialogItemDetailStyle = TextStyle(color: kTileAlbumColor, fontSize: 14.0);

const kTileTitleStyle = TextStyle(fontSize: 16.0, color: kTileTitleColor);
const kTileAlbumStyle = TextStyle(fontSize: 14.0, color: kTileAlbumColor);
const kHeaderTitleStyle = TextStyle(fontSize: 18.0, color: Colors.white);
const kHeaderAlbumStyle = TextStyle(fontSize: 14.0, color: Colors.white70);

const kProgressIndicatorColor = Color(0x80444349); // changed but not tested
// const kMusicIconColor = Colors.white; // not used anywhere
const kIconColor = Color(0xff444349); // changed
const kHeaderIconColor = Colors.white; // changed
const kDisabledIconColor = Color(0xff808080); // not changed but looks great
const kBackgroundColor = Color(0xffb7b7c5); // changed
const kPrimaryColor = Color(0xff444349); // changed
const kCircleAvatarColor = Colors.transparent; // changed
const kTileTitleColor = Color(0xb3000000); // changed
const kTileAlbumColor = Color(0x80000000); // changed
const kProgressBarColor = Color(0xff444349); // changed
const kThumbGlowColor = Color(0x80ffffff); // not changed but looks great
const kBufferedBarColor = Color(0x80ffffff); // changed
const kBaseBarColor = Colors.white; // changed
const kMusicTonesColor = Color(0x33444349); // changed
// const kSearchDelegateColor = Color(0xe60C2D48);
const kAddPlaylistContainerColor = Color(0x80444349); // changed
const kDialogColor = kBackgroundColor; // changed
const kNowPlayingTitleStyle = TextStyle(fontSize: 16.0, color: kNowPlayingTitleColor);
const kNowPlayingAlbumStyle = TextStyle(fontSize: 14.0, color: kNowPlayingAlbumColor);
const kNowPlayingTitleColor = Color(0xffEEEDE7); // not changed but looks great
const kNowPlayingAlbumColor = Color(0x80EEEDE7); // not changed but looks great
const kNowPlayingTileColor = Color(0x80444349); // changed opacity to 40%
const kNowPlayingMusicIconColor = Color(0xffEEEDE7); // not changed but looks great
