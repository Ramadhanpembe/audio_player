import 'dart:io';

import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/main.dart';
import 'package:audio_player/screens/add_to_playlist_screen.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class PlaylistInsideScreen extends StatefulWidget {
  const PlaylistInsideScreen({super.key, required this.playlistIndex});

  final int playlistIndex;
  @override
  State<PlaylistInsideScreen> createState() => _PlaylistInsideScreenState();
}

class _PlaylistInsideScreenState extends State<PlaylistInsideScreen> {
  late final _playlistIndex = widget.playlistIndex;

  Future<List<SongEntity>> get _allFromPlaylist async {
    setState(() {});
    return await queryManager.getAllFromPlaylist(playlists[_playlistIndex].key);
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

  void _share(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File testFile = File("${dir.path}/$filename");
    if (!await testFile.exists()) {
      await testFile.create(recursive: true);
      testFile.writeAsStringSync("test for share documents file");
    }
    ShareExtend.share(testFile.path, "file");
  }

  // Future<String?> _getPath(SongModel track) async {
  //   return await LecleFlutterAbsolutePath.getAbsolutePath(uri: track.uri ?? '');
  // }

  void _showModalBottomSheet(int index, SongModel track) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                      iconSize: 40.0,
                    ),
                    const Text('Favorite'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          queryManager.removeFromPlaylist(addedTracks[index].id,
                              playlists[_playlistIndex].key);
                        });
                        Navigator.pop(context);
                      },
                      iconSize: 40.0,
                    ),
                    const Text('Remove'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () async {
                        /// /////////////////////////////////////////
                        // String? path = await LecleFlutterAbsolutePath.getAbsolutePath(
                        //     uri: track.uri ?? '');
                        // await Share.shareXFiles([XFile(path ?? '')]);
                        if (mounted) Navigator.pop(context);
                        _share(track.displayName);
                        // Share.share(
                        //   track.displayName,
                        // );
                      },
                      iconSize: 40.0,
                    ),
                    const Text('Share'),
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
                                      const ListTile(
                                        leading: Text('Path:'),
                                        title: Text('Path'),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: Text(playlists[_playlistIndex].playlistName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () async {
              final bl = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddToPlaylistScreen(
                            playlistIndex: _playlistIndex,
                          )));

              if (bl) {
                setState(() {});
              }
            },
            iconSize: 30.0,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            iconSize: 30.0,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<List<SongEntity>>(
            future: _allFromPlaylist,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: Text('Loading...'),
                );
              }
              if (snapshot.hasError) {
                return const Text('Error in fetching the list!!');
              }
              if (snapshot.hasData) {
                addedEntities = snapshot.data!;
                addedTracks = queryManager.entityToSongAdapter(addedEntities);

                return ListView.builder(
                  itemCount: addedTracks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        radius: 30.0,
                        child: QueryArtworkWidget(
                          id: addedTracks[index].id,
                          type: ArtworkType.AUDIO,
                          keepOldArtwork: true,
                          nullArtworkWidget: Image.asset(
                            'images/musical_notes.png',
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.fill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(addedTracks[index].displayName),
                      subtitle: Text(addedTracks[index].title),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () async {
                          // we need to show something like bottom sheet
                          // String? path = await _getPath(addedTracks[index]);
                          _showModalBottomSheet(index, addedTracks[index]);
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlayerScreen()));
                        // pageManager.audioSource(index);
                        /// this is where the real challenge is - SOLVED:
                        playerManager.setPlaylist(index, addedTracks);
                        playerManager.play();
                      },
                    );
                  },
                );
              }
              return const Center(
                child: Text('No track found!'),
              );
            },
          ),
        ),
      ),
    );
  }
}
