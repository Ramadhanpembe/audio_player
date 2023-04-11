import 'package:audio_player/customs/play_color.dart';
import 'package:audio_player/logics/player_handler.dart';
import 'package:audio_player/logics/query_manager.dart';
import 'package:audio_player/screens/home_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_room/on_audio_room.dart';

import 'logics/player_manager.dart';

void main() async {
  await OnAudioRoom().initRoom();
  await initAudioService();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

late final PlayerManager playerManager;
late final QueryManager queryManager;

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    playerManager = PlayerManager();
    queryManager = QueryManager();
    super.initState();
  }

  @override
  void dispose() {
    playerManager.dispose();
    queryManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primarySwatch: playColor,
          appBarTheme: const AppBarTheme().copyWith(
            systemOverlayStyle: kSystemUiOverlayStyle,
            toolbarHeight: 100.0,
          ),
          checkboxTheme: const CheckboxThemeData().copyWith(
            fillColor: MaterialStateProperty.all(kTileAlbumColor),
          ),
          scrollbarTheme: const ScrollbarThemeData().copyWith(
            thumbColor: MaterialStateProperty.all(kDisabledIconColor),
            radius: const Radius.circular(3.0),
          )),
      home: const HomeScreen(),
    );
  }
}
