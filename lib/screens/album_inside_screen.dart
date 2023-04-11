import 'package:audio_player/screens/player_screen.dart';
import 'package:audio_player/widgets/empty_list_indicator.dart';
import 'package:audio_player/widgets/error_indicator.dart';
import 'package:audio_player/widgets/loading_indicator.dart';
import 'package:audio_player/widgets/rounded_avatar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../logics/player_query_resources.dart';
import '../main.dart';
import '../utils/constants.dart';
import '../utils/utility_functions.dart';

class AlbumInsideScreen extends StatelessWidget {
  const AlbumInsideScreen({super.key, required this.futureModels, required this.albumIndex});
  final Future<List<SongModel>> futureModels;
  final int albumIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(albums[albumIndex].album),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureModels,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingIndicator();
            }
            if (snapshot.hasError) {
              return const ErrorIndicator();
            }
            if (snapshot.hasData) {
              albumSongs = snapshot.data!;
              return Scrollbar(
                child: ListView.builder(
                  itemCount: albumSongs.length,
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder(
                      valueListenable: isBackArrowClickedNotifier,
                      builder: (_, isClicked, __) {
                        return ValueListenableBuilder(
                          valueListenable: playerManager.currentTrackIDNotifier,
                          builder: (_, id, __) {
                            return ListTile(
                              tileColor: isClicked && albumSongs[index].id == id
                                  ? kNowPlayingTileColor
                                  : Colors.transparent,
                              title: Text(
                                albumSongs[index].title,
                                style: isClicked && albumSongs[index].id == id
                                    ? kNowPlayingTitleStyle
                                    : kTileTitleStyle,
                              ),
                              subtitle: Text(
                                durationFormatter(albumSongs[index].duration ?? 0),
                                style: isClicked && albumSongs[index].id == id
                                    ? kNowPlayingAlbumStyle
                                    : kTileAlbumStyle,
                              ),
                              leading: RoundedAvatar(
                                models: albumSongs,
                                index: index,
                                isClicked: isClicked,
                              ),
                              trailing: Text(
                                '${megabytesFromBytes(albumSongs[index].size)} MB',
                                style: isClicked && albumSongs[index].id == id
                                    ? kNowPlayingAlbumStyle
                                    : kTileAlbumStyle,
                              ),
                              onTap: () {
                                playerManager.setPlaylist(index, albumSongs);
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const PlayerScreen()));
                                playerManager.play();
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const EmptyListIndicator();
            // return const EmptyListIndicator();
          },
        ),
      ),
    );
  }
}
