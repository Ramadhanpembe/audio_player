import 'package:audio_player/customs/play_color.dart';
import 'package:audio_player/screens/playlist_inside_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_player/widgets/playlist_display_icon.dart';
import 'package:audio_player/widgets/rounded_avatar.dart';
import 'package:flutter/material.dart';

import '../logics/player_query_resources.dart';
import '../main.dart';
import '../screens/player_screen.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({required this.list, this.tabIndex});
  int? tabIndex;
  List<dynamic>? list;

  @override
  String get searchFieldLabel => 'Search...';

  @override
  TextStyle get searchFieldStyle {
    return const TextStyle(
      color: Colors.white,
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent,
      decorationThickness: 0.0,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: _buildResults(list ?? []),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: _buildResults(list ?? []),
      );
    } else {
      return const Scaffold(
        backgroundColor: kBackgroundColor,
        resizeToAvoidBottomInset: false,
      );
    }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: kSystemUiOverlayStyle,
        backgroundColor: playColor,
        toolbarHeight: 80.0,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
      hintColor: Colors.grey,
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: InputBorder.none,
        activeIndicatorBorder: BorderSide.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildResults(List<dynamic> list) {
    if (tabIndex == 0 || tabIndex == 3 || tabIndex == null) {
      List<dynamic> results = [];
      for (var item in list) {
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          results.add(item);
        }
      }
      return Scrollbar(
        child: ListView.builder(
          itemCount: results.length,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (context, index) {
            return ListTile(
              visualDensity: VisualDensity.comfortable,
              leading: RoundedAvatar(models: results, index: index),
              title: Text(
                results[index].title,
                style: kTileTitleStyle,
              ),
              subtitle: Text(
                results[index].album ?? '',
                style: kTileAlbumStyle,
              ),
              onTap: () {
                close(context, results);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const PlayerScreen()));
                playerManager.playSelected(index, results[index].id);
                playerManager.play();
              },
            );
          },
        ),
      );
    } else if (tabIndex == 1) {
      int playlistIndex = 0;
      List<dynamic> outputs = [];
      for (var item in list) {
        if (item.playlistName.toLowerCase().contains(query.toLowerCase())) {
          outputs.add(item);
        }
      }
      return Scrollbar(
        child: ListView.builder(
          itemCount: outputs.length,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (context, index) {
            for (int i = 0; i < playlists.length; i++) {
              if (playlists[i].key == outputs[index].key) playlistIndex = i;
            }
            return ListTile(
              visualDensity: VisualDensity.comfortable,
              leading: PlaylistDisplayIcon(index: index),
              title: Text(
                outputs.elementAt(index).playlistName,
                style: kTileTitleStyle,
              ),
              onTap: () {
                close(context, outputs);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlaylistInsideScreen(
                          playlistIndex: playlistIndex,
                        )));
              },
            );
          },
        ),
      );
    }
    return Scrollbar(
      child: Container(),
    );
  }
}
