import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/main.dart';
import 'package:audio_player/screens/add_to_playlist_screen.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistInsideScreen extends StatefulWidget {
  const PlaylistInsideScreen({super.key, required this.playlistIndex});

  final int playlistIndex;
  @override
  State<PlaylistInsideScreen> createState() => _PlaylistInsideScreenState();
}

class _PlaylistInsideScreenState extends State<PlaylistInsideScreen> {
  late final _playlistIndex = widget.playlistIndex;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(playlists[_playlistIndex].playlistName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined),
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
            icon: const Icon(Icons.search),
            onPressed: () {},
            iconSize: 30.0,
          ),
          _buildPopupMenuButton(context),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<List<SongEntity>>(
            future: _allFromPlaylist,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return _buildProgressIndicator(message: 'Loading...');
              }
              if (snapshot.hasError) {
                return _buildErrorIndicator(
                    message: 'Error in fetching the list!!');
              }
              if (snapshot.hasData) {
                addedEntities = snapshot.data!;
                addedTracks = queryManager.entityToSongAdapter(addedEntities);

                return ListView.builder(
                  itemCount: addedTracks.length,
                  itemBuilder: (context, index) {
                    /// favorites
                    // queryManager.testWithStreams(addedTracks);
                    return ListTile(
                      leading: _buildCircleAvatar(index),
                      title: Text(addedTracks[index].displayName),
                      subtitle: Text(addedTracks[index].title),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () async {
                          isFavorite =
                              await queryManager.isFavorite(addedTracks[index]);
                          _showModalBottomSheet(
                              index, addedTracks[index], isFavorite);
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlayerScreen()));
                        playerManager.setPlaylist(index, addedTracks);
                        playerManager.play();
                      },
                    );
                  },
                );
              }
              return _buildEmptyIndicator(message: 'No track found!');
            },
          ),
        ),
      ),
    );
  }

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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              queryManager.removeFromPlaylist(
                                  addedTracks[index].id,
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

  CircleAvatar _buildCircleAvatar(int index) {
    return CircleAvatar(
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
    );
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

  PopupMenuButton<dynamic> _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      iconSize: 30.0,
      onSelected: (value) async {
        if (value == 'Rename playlist') {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Rename Playlist'),
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
          queryManager.renamePlaylist(
              playlists[_playlistIndex].key, controller.text);
          playlistEntities = queryManager.initPlaylists;
          setState(() {});
        }
        if (value == 'Clear all') {
          List<SongEntity> ens = await queryManager
              .getAllFromPlaylist(playlists[_playlistIndex].key);
          queryManager.removeAllFromPlaylist(
              ens, playlists[_playlistIndex].key);
          setState(() {});
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          const PopupMenuItem(
            value: 'Rename playlist',
            child: Text('Rename playlist'),
          ),
          const PopupMenuItem(
            value: 'Clear all',
            child: Text('Clear all'),
          ),
        ];
      },
    );
  }
}
