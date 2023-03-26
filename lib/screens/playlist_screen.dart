import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/screens/playlist_inside_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../main.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPlaylistScreen(context);
  }

  Column _buildPlaylistScreen(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kAddPlaylistContainerColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.playlist_add,
                  ),
                  iconSize: 45.0,
                  color: kIconColor,
                  onPressed: () async {
                    controller.clear();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: kDialogColor,
                          title: const Text(
                            'Add New Playlist',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          content: Builder(builder: (context) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextField(
                                controller: controller,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  hintText: 'Playlist name',
                                ),
                              ),
                            );
                          }),
                          actions: [
                            FilledButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('CANCEL'),
                            ),
                            FilledButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OKAY'),
                            ),
                          ],
                        );
                      },
                    );
                    queryManager.createPlaylist(controller.text);
                    playlistEntities = queryManager.initPlaylists;
                    setState(() {});
                  },
                ),
              ),
              Text(
                'Add New Playlist',
                style: kTileTitleStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<PlaylistEntity>>(
            future: playlistEntities,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return _buildProgressIndicator();
              } else if (snapshot.data!.isEmpty) {
                return _buildEmptyIndicator(message: 'No Playlist found');
              }
              playlists = snapshot.data!;
              return ListView.builder(
                itemCount: playlists.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        visualDensity: VisualDensity.comfortable,
                        leading: _buildPlaylistDisplayIcon(index),
                        trailing: Text(
                          _dateFromTimestamp(playlists[index].playlistDateModified),
                          style: kTileAlbumStyle,
                        ),
                        title: Text(
                          playlists[index].playlistName,
                          style: kTileTitleStyle.copyWith(fontSize: 18.0),
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlaylistInsideScreen(playlistIndex: index)));
                        },
                        onLongPress: () async {
                          bool? isDeleted = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Delete playlist ${playlists[index].playlistName}?',
                                    style: const TextStyle(color: kPrimaryColor),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete ${playlists[index].playlistName}?',
                                    style: const TextStyle(color: kPrimaryColor),
                                  ),
                                  actions: [
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('CANCEL'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        queryManager.deletePlaylist(playlists[index].key);
                                        setState(() {});
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('YES'),
                                    ),
                                  ],
                                );
                              });
                          if (isDeleted ?? false) {
                            playlistEntities = queryManager.initPlaylists;
                            setState(() {});
                          }
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
            },
          ),
        ),
      ],
    );
  }

  QueryArtworkWidget _buildPlaylistDisplayIcon(int index) {
    return QueryArtworkWidget(
      id: playlists[index].key,
      type: ArtworkType.PLAYLIST,
      nullArtworkWidget: const Icon(
        Icons.queue_music,
        size: 50.0,
        color: kIconColor,
      ),
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

  String _dateFromTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    DateFormat dateFormat = DateFormat('dd MMM - yyyy');
    return dateFormat.format(dateTime);
  }
}
