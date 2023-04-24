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

const kProgressIndicatorColor = Color(0xffB1D4E0);
const kMusicIconColor = Colors.white;
const kIconColor = Color(0xff000000); // changed
const kDisabledIconColor = Color(0xff808080); // not changed but looks great
const kBackgroundColor = Color(0xffb7b7c5); // changed
const kPrimaryColor = Color(0xff444349); // changed
const kCircleAvatarColor = Colors.transparent; // changed
const kTileTitleColor = Color(0xb3000000); // changed
const kTileAlbumColor = Color(0x80000000); // changed
const kProgressBarColor = Colors.white;
const kThumbGlowColor = Color(0x80ffffff);
const kBufferedBarColor = Color(0x4dB1D4E0);
const kBaseBarColor = Color(0xff2E8BC0);
const kMusicTonesColor = Color(0x4dB1D4E0);
const kSearchDelegateColor = Color(0xe60C2D48);
const kAddPlaylistContainerColor = Color(0xff808080); // changed
const kDialogColor = kBackgroundColor; // changed
const kNowPlayingTitleStyle = TextStyle(fontSize: 16.0, color: kNowPlayingTitleColor);
const kNowPlayingAlbumStyle = TextStyle(fontSize: 14.0, color: kNowPlayingAlbumColor);
const kNowPlayingTitleColor = Color(0xffF4EBD0); // not changed but looks great
const kNowPlayingAlbumColor = Color(0x99F4EBD0); // not changed but looks great
const kNowPlayingTileColor = Color(0x66444349); // changed opacity to 40%
const kNowPlayingMusicIconColor = Color(0xffF4EBD0); // not changed but looks great
