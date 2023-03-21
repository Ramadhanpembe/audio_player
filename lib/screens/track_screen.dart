import 'package:audio_player/main.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/extensions/song_map_formatter_extension.dart';

import '../logics/player_query_resources.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: songModels,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return _buildProgressIndicator();
        } else if (snapshot.data!.isEmpty) {
          return _buildEmptyIndicator(message: 'No Audio Found');
        }
        tracks = snapshot.data!;
        entities = queryManager.songToEntityAdapter(tracks);
        return ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: _buildCircleAvatar(snapshot, index),
              title: Text(tracks.elementAt(index).displayName),
              subtitle: Text(tracks.elementAt(index).title),
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () async {
                  bool isFav = await queryManager.isFavorite(tracks[index]);
                  _showModalBottomSheet(index, tracks[index], isFav);
                },
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PlayerScreen()));
                playerManager.setInitialPlaylist(index);
                playerManager.play();

                // setState(() {});
              },
            );
          },
        );
      },
    );
  }

  Center _buildEmptyIndicator({required String message}) {
    return Center(
      child: Text(message),
    );
  }

  Center _buildProgressIndicator() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 32.0,
        height: 32.0,
        child: const CircularProgressIndicator(color: Colors.indigo),
      ),
    );
  }

  CircleAvatar _buildCircleAvatar(
      AsyncSnapshot<List<SongModel>> snapshot, int index) {
    return CircleAvatar(
      backgroundColor: Colors.indigo,
      radius: 30.0,
      child: QueryArtworkWidget(
        id: snapshot.data![index].id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          'images/musical_notes.png',
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          color: Colors.white,
        ),
      ),
    );
  }

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

  void _showModalBottomSheet(int index, SongModel track, bool isFavorite) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, void Function(void Function()) setModalState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: isFavorite
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border),
                          onPressed: () async {
                            if (isFavorite) {
                              isFavorite = false;
                              queryManager.removeFromFavorite(track);
                              setModalState(() {});
                            } else {
                              isFavorite = true;
                              queryManager.addToFavorite(
                                  track.getMap.toFavoritesEntity());
                              setModalState(() {});
                            }
                            favoritesEntities = queryManager.initFavorites;
                            setModalState(() {});
                          },
                          iconSize: 40.0,
                        ),
                        const Text('Favorite'),
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
                                            title: Text(
                                                track.album ?? '<unknown>'),
                                          ),
                                          ListTile(
                                            leading: const Text('Artist:'),
                                            title: Text(
                                                track.artist ?? '<unknown>'),
                                          ),
                                          ListTile(
                                            leading: const Text('Genre:'),
                                            title: Text(
                                                track.genre ?? '<unknown>'),
                                          ),
                                          ListTile(
                                            leading: const Text('Size:'),
                                            title: Text(
                                                '${_megabytesFromBytes(track.size)} MB'),
                                          ),
                                          ListTile(
                                            leading: const Text('Extension:'),
                                            title: Text(_trackExtension(
                                                track.displayName)),
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
                                            leading:
                                                const Text('Date Modified:'),
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
            },
          );
        });
  }
}
