import 'package:audio_player/main.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_player/widgets/rounded_avatar.dart';
import 'package:audio_player/widgets/track_info_box.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/extensions/song_map_formatter_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logics/player_query_resources.dart';
import '../widgets/empty_list_indicator.dart';
import '../widgets/loading_indicator.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> with WidgetsBindingObserver {
  bool _isFirstLaunch = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkFirstLaunch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _isFirstLaunch) {
      setState(() {
        songModels = queryManager.initSongs;
        albumModels = queryManager.initAlbums;
      });
    }
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('firstLaunch')) {
      setState(() {
        _isFirstLaunch = false;
      });
    } else {
      preferences.setBool('firstLaunch', false);
    }
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
          return const LoadingIndicator();
        } else if (snapshot.data!.isEmpty) {
          return const EmptyListIndicator();
        }
        tracks = snapshot.data!;

        if (tracks.isEmpty) {
          return const EmptyListIndicator();
        }
        entities = queryManager.songToEntityAdapter(tracks);
        return Scrollbar(
          child: ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return ValueListenableBuilder(
                valueListenable: isBackArrowClickedNotifier,
                builder: (_, isClicked, __) {
                  return ValueListenableBuilder(
                    valueListenable: playerManager.currentTrackIDNotifier,
                    builder: (_, id, __) {
                      return ListTile(
                        tileColor: isClicked && tracks[index].id == id
                            ? kNowPlayingTileColor
                            : Colors.transparent,
                        visualDensity: VisualDensity.comfortable,
                        leading: RoundedAvatar(
                          models: tracks,
                          index: index,
                          isClicked: isClicked,
                        ),
                        title: Text(
                          tracks.elementAt(index).title,
                          style: isClicked && tracks[index].id == id
                              ? kNowPlayingTitleStyle
                              : kTileTitleStyle,
                        ),
                        subtitle: Text(
                          tracks.elementAt(index).album ?? '',
                          style: isClicked && tracks[index].id == id
                              ? kNowPlayingAlbumStyle
                              : kTileAlbumStyle,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_horiz),
                          color: isClicked && tracks[index].id == id
                              ? kNowPlayingAlbumColor
                              : kTileAlbumColor,
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
          ),
        );
      },
    );
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
}
