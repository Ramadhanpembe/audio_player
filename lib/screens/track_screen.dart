import 'package:audio_player/main.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:audio_player/utils/constants.dart';
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
  List<Color> tileColor = List.generate(tracks.length, (index) => Colors.transparent);

  Color _colorAtIndex(int trackIndex) {
    tileColor[trackIndex] = kNowPlayingTileColor;
    return tileColor[trackIndex];
  }

  @override
  Widget build(BuildContext context) {
    return _buildFutureBuilder(context);
  }

  FutureBuilder<List<SongModel>> _buildFutureBuilder(BuildContext context) {
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
            return ValueListenableBuilder(
              valueListenable: playerManager.currentTrackIndexNotifier,
              builder: (_, trackIndex, __) {
                return ListTile(
                  tileColor: index == trackIndex ? _colorAtIndex(trackIndex) : Colors.transparent,
                  visualDensity: VisualDensity.comfortable,
                  leading: _buildCircleAvatar(snapshot, index, trackIndex),
                  title: Text(
                    tracks.elementAt(index).title,
                    style: index == trackIndex ? kNowPlayingTitleStyle : kTileTitleStyle,
                  ),
                  subtitle: Text(
                    tracks.elementAt(index).album ?? '',
                    style: index == trackIndex ? kNowPlayingAlbumStyle : kTileAlbumStyle,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    color: index == trackIndex ? kNowPlayingAlbumColor : kTileAlbumColor,
                    onPressed: () async {
                      bool isFav = await queryManager.isFavorite(tracks[index]);
                      _showModalBottomSheet(index, tracks[index], isFav);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const PlayerScreen()));
                    playerManager.setInitialPlaylist(index);
                    playerManager.play();
                    setState(() {});
                  },
                );
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
        child: const CircularProgressIndicator(color: kProgressIndicatorColor),
      ),
    );
  }

  CircleAvatar _buildCircleAvatar(
      AsyncSnapshot<List<SongModel>> snapshot, int index, int trackIndex) {
    return CircleAvatar(
      backgroundColor: kCircleAvatarColor,
      radius: 26.0,
      child: QueryArtworkWidget(
        id: snapshot.data![index].id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          'images/musical_notes.png',
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          color: index == trackIndex ? kNowPlayingMusicIconColor : kMusicIconColor,
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
              return Container(
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    border: Border(
                      top: BorderSide(
                        color: kPrimaryColor,
                        width: 1.0,
                      ),
                    )),
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          color: kIconColor,
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
                              queryManager.addToFavorite(track.getMap.toFavoritesEntity());
                              setModalState(() {});
                            }
                            favoritesEntities = queryManager.initFavorites;
                            setModalState(() {});
                          },
                          iconSize: 40.0,
                        ),
                        const Text(
                          'Favorite',
                          style: kTileTitleStyle,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          color: kIconColor,
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: kDialogColor,
                                    title: const Text('Track Details'),
                                    actions: [
                                      FilledButton(
                                        child: const Text('OKAY'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: const Text(
                                                'Title:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                track.title,
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Text(
                                                'Album:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                track.album ?? '<unknown>',
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Text(
                                                'Artist:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                track.artist ?? '<unknown>',
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Text(
                                                'Genre:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                track.genre ?? '<unknown>',
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Text(
                                                'Size:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                '${_megabytesFromBytes(track.size)} MB',
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Text(
                                                'Extension:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                _trackExtension(track.displayName),
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Text(
                                                'Duration:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                _durationFormatter(track.duration ?? 0),
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Text(
                                                'Date Added:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                _dateFromTimestamp(track.dateAdded ?? 0).toString(),
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Text(
                                                'Date Modified:',
                                                style: kInfoDialogItemTitleStyle,
                                              ),
                                              title: Text(
                                                _dateFromTimestamp(track.dateModified ?? 0)
                                                    .toString(),
                                                style: kInfoDialogItemDetailStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          iconSize: 40.0,
                        ),
                        const Text(
                          'Info',
                          style: kTileTitleStyle,
                        ),
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
