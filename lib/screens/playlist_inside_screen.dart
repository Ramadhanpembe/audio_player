import 'package:audio_player/customs/custom_search_delegate.dart';
import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/main.dart';
import 'package:audio_player/screens/add_to_playlist_screen.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_player/widgets/empty_list_indicator.dart';
import 'package:audio_player/widgets/loading_indicator.dart';
import 'package:audio_player/widgets/rounded_avatar.dart';
import 'package:audio_player/widgets/track_info_box.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../widgets/error_indicator.dart';

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
  Widget build(BuildContext context) {
    return _buildPlaylistInsideScreen(context);
  }

  Scaffold _buildPlaylistInsideScreen(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(playlists[_playlistIndex].playlistName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            playlistEntities = queryManager.initPlaylists;
            queryManager.updatePlaylist(playlists[_playlistIndex]);
            setState(() {});
            Navigator.pop(context, true);
            setState(() {});
          },
        ),
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
            onPressed: () async {
              await showSearch(
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
          return const LoadingIndicator();
        }
        if (snapshot.hasError) {
          return const ErrorIndicator();
        }
        if (snapshot.hasData) {
          addedEntities = snapshot.data!;
          addedTracks = queryManager.entityToSongAdapter(addedEntities);

          return Scrollbar(
            child: ListView.builder(
              itemCount: addedTracks.length,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: isBackArrowClickedNotifier,
                  builder: (_, isClicked, __) {
                    return ValueListenableBuilder(
                      valueListenable: playerManager.currentTrackIDNotifier,
                      builder: (_, id, __) {
                        return ListTile(
                          tileColor: isClicked && addedTracks[index].id == id
                              ? kNowPlayingTileColor
                              : Colors.transparent,
                          visualDensity: VisualDensity.comfortable,
                          leading: RoundedAvatar(
                            models: addedTracks,
                            index: index,
                            isClicked: isClicked,
                          ),
                          title: Text(
                            addedTracks[index].title,
                            style: isClicked && addedTracks[index].id == id
                                ? kNowPlayingTitleStyle
                                : kTileTitleStyle,
                          ),
                          subtitle: Text(
                            addedTracks[index].album ?? '',
                            style: isClicked && addedTracks[index].id == id
                                ? kNowPlayingAlbumStyle
                                : kTileAlbumStyle,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            color: isClicked && addedTracks[index].id == id
                                ? kNowPlayingAlbumColor
                                : kTileAlbumColor,
                            onPressed: () async {
                              isFavorite = await queryManager.isFavorite(addedTracks[index]);
                              _showModalBottomSheet(index, addedTracks[index], isFavorite);
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const PlayerScreen()));
                            playerManager.setPlaylist(index, addedTracks);
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
      },
    );
  }

  Future<List<SongEntity>> get _allFromPlaylist async {
    setState(() {});
    return await queryManager.getAllFromPlaylist(playlists[_playlistIndex].key);
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
                        color: kBackgroundColor,
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
                                      style: TextStyle(color: kBackgroundColor),
                                    ),
                                    actions: [
                                      FilledButton(
                                        child: const Text('OKAY'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    content: TrackInfoBox(
                                      context: context,
                                      track: track,
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
                  style: TextStyle(color: kBackgroundColor),
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
                    onPressed: () async {
                      queryManager.renamePlaylist(playlists[_playlistIndex].key, controller.text);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('OKAY'),
                  ),
                ],
              );
            },
          );
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
              style: TextStyle(color: kBackgroundColor),
            ),
          ),
          const PopupMenuItem(
            value: 'Clear all',
            child: Text(
              'Clear all',
              style: TextStyle(color: kBackgroundColor),
            ),
          ),
        ];
      },
    );
  }
}
