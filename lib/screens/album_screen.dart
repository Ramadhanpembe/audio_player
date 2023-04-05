import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/main.dart';
import 'package:audio_player/screens/album_inside_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_player/widgets/album_display_icon.dart';
import 'package:audio_player/widgets/empty_list_indicator.dart';
import 'package:audio_player/widgets/error_indicator.dart';
import 'package:audio_player/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: albumModels,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingIndicator();
        }
        if (snapshot.hasError) {
          return const ErrorIndicator();
        }
        if (snapshot.hasData) {
          albums = snapshot.data!;
          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    visualDensity: VisualDensity.comfortable,
                    leading: AlbumDisplayIcon(index: index),
                    trailing: albums[index].numOfSongs <= 1
                        ? Text('${albums[index].numOfSongs} track', style: kTileAlbumStyle)
                        : Text('${albums[index].numOfSongs} tracks', style: kTileAlbumStyle),
                    title: Text(
                      albums[index].album,
                      style: kTileTitleStyle,
                    ),
                    onTap: () async {
                      albumSongModels = queryManager.initAlbumSongs(index);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AlbumInsideScreen(
                            futureModels: albumSongModels,
                            albumIndex: index,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 0.3,
                    color: Colors.grey,
                  ),
                ],
              );
            },
          );
        }
        return const EmptyListIndicator();
      },
    );
  }
}
