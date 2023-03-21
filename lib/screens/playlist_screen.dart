import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/screens/playlist_inside_screen.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.tealAccent,
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.playlist_add,
                  ),
                  iconSize: 40,
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Add New Playlist'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Okay'),
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
              const Text('Add New Playlist'),
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
                return _buildEmptyIndicator(message: 'No Playlist yet');
              }
              playlists = snapshot.data!;
              return ListView.builder(
                itemCount: playlists.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: _buildPlaylistDisplayIcon(index),
                      title: Text(playlists[index].playlistName),
                      onTap: () async {
                        final bool bl = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PlaylistInsideScreen(
                                    playlistIndex: index)));

                        if (bl) {
                          setState(() {
                            // queryManager.initPlaylists;
                          });
                        }
                      },
                      onLongPress: () async {
                        bool isDeleted = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    'Delete playlist ${playlists[index].playlistName}?'),
                                content: Text(
                                    'Are you sure you want to delete ${playlists[index].playlistName}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      queryManager
                                          .deletePlaylist(playlists[index].key);
                                      setState(() {});
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('YES'),
                                  ),
                                ],
                              );
                            });
                        if (isDeleted) {
                          playlistEntities = queryManager.initPlaylists;
                          setState(() {});
                        }
                      },
                    ),
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
        Icons.featured_play_list_outlined,
        size: 50.0,
        color: Colors.indigo,
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
}
