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

const kProgressIndicatorColor = Color(0x80444349);
const kIconColor = Color(0xff444349);
const kHeaderIconColor = Colors.white;
const kDisabledIconColor = Color(0xff808080);
const kBackgroundColor = Color(0xffb7b7c5);
const kPrimaryColor = Color(0xff444349);
const kCircleAvatarColor = Colors.transparent;
const kTileTitleColor = Color(0xb3000000);
const kTileAlbumColor = Color(0x80000000);
const kProgressBarColor = Color(0xff444349);
const kThumbGlowColor = Color(0x80ffffff);
const kBufferedBarColor = Color(0x80ffffff);
const kBaseBarColor = Colors.grey;
const kMusicTonesColor = Color(0x33444349);
const kAddPlaylistContainerColor = Color(0x80444349);
const kDialogColor = kBackgroundColor;
const kNowPlayingTitleStyle = TextStyle(fontSize: 16.0, color: kNowPlayingTitleColor);
const kNowPlayingAlbumStyle = TextStyle(fontSize: 14.0, color: kNowPlayingAlbumColor);
const kNowPlayingTitleColor = Color(0xffEEEDE7);
const kNowPlayingAlbumColor = Color(0x80EEEDE7);
const kNowPlayingTileColor = Color(0x80444349);
const kNowPlayingMusicIconColor = Color(0xffEEEDE7);
