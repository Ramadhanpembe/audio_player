import 'package:audio_player/customs/custom_search_delegate.dart';
import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/main.dart';
import 'package:audio_player/screens/add_to_playlist_screen.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:audio_player/utils/constants.dart';
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
    return _buildPlaylistInsideScreen(context);
  }

  Scaffold _buildPlaylistInsideScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: Text(playlists[_playlistIndex].playlistName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () async {
              bool? bl = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddToPlaylistScreen(
                            playlistIndex: _playlistIndex,
                          )));

              if (bl ?? false) {
                setState(() {});
              }
            },
            iconSize: 30.0,
            color: kIconColor,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(list: addedTracks),
              );
            },
            iconSize: 30.0,
            color: kIconColor,
          ),
          _buildPopupMenuButton(context),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: kSearchDelegateColor,
          child: _buildPlaylist(),
        ),
      ),
    );
  }

  FutureBuilder<List<SongEntity>> _buildPlaylist() {
    return FutureBuilder<List<SongEntity>>(
      future: _allFromPlaylist,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _buildProgressIndicator(message: 'Loading...');
        }
        if (snapshot.hasError) {
          return _buildErrorIndicator(message: 'Error in fetching the list!!');
        }
        if (snapshot.hasData) {
          addedEntities = snapshot.data!;
          addedTracks = queryManager.entityToSongAdapter(addedEntities);

          return ListView.builder(
            itemCount: addedTracks.length,
            itemBuilder: (context, index) {
              return ListTile(
                visualDensity: VisualDensity.comfortable,
                leading: _buildCircleAvatar(index),
                title: Text(
                  addedTracks[index].title,
                  style: kTileTitleStyle,
                ),
                subtitle: Text(
                  addedTracks[index].album ?? '',
                  style: kTileAlbumStyle,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_horiz),
                  color: kTileAlbumColor,
                  onPressed: () async {
                    isFavorite = await queryManager.isFavorite(addedTracks[index]);
                    _showModalBottomSheet(index, addedTracks[index], isFavorite);
                  },
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const PlayerScreen()));
                  playerManager.setPlaylist(index, addedTracks);
                  playerManager.play();
                },
              );
            },
          );
        }
        return _buildEmptyIndicator(message: 'No track found!');
      },
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              queryManager.removeFromPlaylist(
                                  addedTracks[index].id, playlists[_playlistIndex].key);
                            });
                            Navigator.pop(context);
                          },
                          iconSize: 40.0,
                        ),
                        const Text(
                          'Remove',
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
                                    title: const Text(
                                      'Track Details',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
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

  CircleAvatar _buildCircleAvatar(int index) {
    return CircleAvatar(
      backgroundColor: kCircleAvatarColor,
      radius: 26.0,
      child: QueryArtworkWidget(
        id: addedTracks[index].id,
        type: ArtworkType.AUDIO,
        keepOldArtwork: true,
        nullArtworkWidget: Image.asset(
          'images/musical_notes.png',
          filterQuality: FilterQuality.high,
          fit: BoxFit.fill,
          color: kMusicIconColor,
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
      color: kDialogColor,
      icon: const Icon(Icons.more_vert),
      iconSize: 30.0,
      onSelected: (value) async {
        controller.clear();
        if (value == 'Rename playlist') {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Rename Playlist',
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
                        hintText: 'Enter new playlist name',
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
          queryManager.renamePlaylist(playlists[_playlistIndex].key, controller.text);
          playlistEntities = queryManager.initPlaylists;
          setState(() {});
        }
        if (value == 'Clear all') {
          List<SongEntity> ens =
              await queryManager.getAllFromPlaylist(playlists[_playlistIndex].key);
          queryManager.removeAllFromPlaylist(ens, playlists[_playlistIndex].key);
          setState(() {});
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          const PopupMenuItem(
            value: 'Rename playlist',
            child: Text(
              'Rename playlist',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          const PopupMenuItem(
            value: 'Clear all',
            child: Text(
              'Clear all',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ];
      },
    );
  }
}
