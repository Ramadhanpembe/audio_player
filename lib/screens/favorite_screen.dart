import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/main.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FavoritesEntity>>(
      future: favoritesEntities,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _buildProgressIndicator(message: 'Loading');
        }
        if (snapshot.hasError) {
          return _buildErrorIndicator(message: 'Error in getting favorites');
        }
        if (snapshot.hasData) {
          favorites = snapshot.data!;

          /// check if favorite here
          // _isFavorite(favorites);
          addedFavorites = queryManager.favoriteToSongAdapter(favorites);
          return ListView.builder(
            itemCount: addedFavorites.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: _buildCircleAvatar(index),
                title: Text(addedFavorites[index].displayName),
                subtitle: Text(addedFavorites[index].title),
                trailing: IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () async {
                    _showModalBottomSheet(index, addedFavorites[index]);
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PlayerScreen()));
                  playerManager.setPlaylist(index, addedFavorites);
                  playerManager.play();
                },
              );
            },
          );
        }
        return _buildEmptyIndicator(message: 'No favorite found');
      },
    );
  }

  // void _isFavorite(List<FavoritesEntity> favorites) {
  //   for (FavoritesEntity favorite in favorites) {
  //     queryManager.isFavorite(favorite);
  //   }
  // }

  String _dateFromTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(dateTime);
  }

  String _megabytesFromBytes(int bytes) {
    return (bytes / 1000000).toStringAsFixed(2);
  }

  String _trackExtension(String name) {
    int periodIndex = name.indexOf('.');
    return name.substring(periodIndex);
  }

  String _durationFormatter(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    String formatDuration(int n) => n.toString().padLeft(2, '0');
    String minutes = formatDuration(duration.inMinutes.remainder(60));
    String seconds = formatDuration(duration.inSeconds.remainder(60));
    return '${formatDuration(duration.inHours)}:$minutes:$seconds';
  }

  Center _buildEmptyIndicator({required String message}) {
    return Center(
      child: Text(message),
    );
  }

  Text _buildErrorIndicator({required String message}) => Text(message);

  Center _buildProgressIndicator({required String message}) {
    return Center(
      child: Text(message),
    );
  }

  CircleAvatar _buildCircleAvatar(int index) {
    return CircleAvatar(
      backgroundColor: Colors.indigo,
      radius: 30.0,
      child: QueryArtworkWidget(
        id: addedFavorites[index].id,
        type: ArtworkType.AUDIO,
        keepOldArtwork: true,
        nullArtworkWidget: Image.asset(
          'images/musical_notes.png',
          filterQuality: FilterQuality.high,
          fit: BoxFit.fill,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showModalBottomSheet(int index, SongModel track) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        /// remove from favorites here
                        queryManager.removeFromFavorite(track);
                        Navigator.pop(context);
                        setState(() {});
                        favoritesEntities = queryManager.initFavorites;
                      },
                      iconSize: 40.0,
                    ),
                    const Text('Remove'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Track Details'),
                                actions: [
                                  TextButton(
                                    child: const Text('Okay'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Text('Title:'),
                                        title: Text(track.title),
                                      ),
                                      ListTile(
                                        leading: const Text('Album:'),
                                        title: Text(track.album ?? '<unknown>'),
                                      ),
                                      ListTile(
                                        leading: const Text('Artist:'),
                                        title:
                                            Text(track.artist ?? '<unknown>'),
                                      ),
                                      ListTile(
                                        leading: const Text('Genre:'),
                                        title: Text(track.genre ?? '<unknown>'),
                                      ),
                                      ListTile(
                                        leading: const Text('Size:'),
                                        title: Text(
                                            '${_megabytesFromBytes(track.size)} MB'),
                                      ),
                                      ListTile(
                                        leading: const Text('Extension:'),
                                        title: Text(
                                            _trackExtension(track.displayName)),
                                      ),
                                      ListTile(
                                        leading: const Text('Duration:'),
                                        title: Text(_durationFormatter(
                                            track.duration ?? 0)),
                                      ),
                                      ListTile(
                                        leading: const Text('Date Added:'),
                                        title: Text(_dateFromTimestamp(
                                                track.dateAdded ?? 0)
                                            .toString()),
                                      ),
                                      ListTile(
                                        leading: const Text('Date Modified:'),
                                        title: Text(_dateFromTimestamp(
                                                track.dateModified ?? 0)
                                            .toString()),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      iconSize: 40.0,
                    ),
                    const Text('Info'),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
