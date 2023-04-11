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
    color: kBackgroundColor, fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: 1.5);
const kInfoDialogItemDetailStyle = TextStyle(color: kBackgroundColor, fontSize: 14.0);

const kTileTitleStyle = TextStyle(fontSize: 16.0, color: kTileTitleColor);
const kTileAlbumStyle = TextStyle(fontSize: 14.0, color: kTileAlbumColor);
const kHeaderTitleStyle = TextStyle(fontSize: 18.0, color: Colors.white);
const kHeaderAlbumStyle = TextStyle(fontSize: 14.0, color: Colors.white70);

const kProgressIndicatorColor = Color(0xffB1D4E0);
const kMusicIconColor = Colors.white;

const kIconColor = Color(0xffB1D4E0);
const kDisabledIconColor = Color(0x4dB1D4E0);
const kBackgroundColor = Color(0xe6223C60);
const kPrimaryColor = Color(0xff0C2D48);
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
