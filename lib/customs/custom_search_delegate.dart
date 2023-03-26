import 'package:audio_player/screens/playlist_inside_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
    return Container(
      color: kSearchDelegateColor,
      height: MediaQuery.of(context).size.height,
      child: _buildResults(list ?? []),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return Container(
        color: kSearchDelegateColor,
        height: MediaQuery.of(context).size.height,
        child: _buildResults(list ?? []),
      );
    } else {
      return Container(
        color: kSearchDelegateColor,
      );
    }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kPrimaryColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        backgroundColor: kPrimaryColor,
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
    if (tabIndex != 1) {
      List<dynamic> results = [];
      for (var item in list) {
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          results.add(item);
        }
      }
      return ListView.builder(
        itemCount: results.length,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (context, index) {
          return ListTile(
            // tileColor: kTileColor,
            visualDensity: VisualDensity.comfortable,
            leading: _buildCircleAvatar(results, index),
            title: Text(
              results.elementAt(index).title,
              style: kTileTitleStyle,
            ),
            subtitle: Text(
              results.elementAt(index).album ?? '',
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
      );
    }
    int playlistIndex = 0;
    List<dynamic> outputs = [];
    for (var item in list) {
      if (item.playlistName.toLowerCase().contains(query.toLowerCase())) {
        outputs.add(item);
      }
    }
    return ListView.builder(
      itemCount: outputs.length,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) {
        for (int i = 0; i < playlists.length; i++) {
          if (playlists[i].key == outputs[index].key) playlistIndex = i;
        }
        return ListTile(
          // tileColor: kTileColor,
          visualDensity: VisualDensity.comfortable,
          leading: const Icon(Icons.featured_play_list_outlined),
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
    );
  }

  CircleAvatar _buildCircleAvatar(List<dynamic> models, int index) {
    return CircleAvatar(
      backgroundColor: const Color(0xff145DA0),
      radius: 26.0,
      child: QueryArtworkWidget(
        id: models[index].id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          'images/musical_notes.png',
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          color: kMusicIconColor,
        ),
      ),
    );
  }
}
