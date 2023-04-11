import 'package:audio_player/features/feature_resource.dart';
import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/main.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_player/widgets/empty_list_indicator.dart';
import 'package:audio_player/widgets/error_indicator.dart';
import 'package:audio_player/widgets/loading_indicator.dart';
import 'package:audio_player/widgets/rounded_avatar.dart';
import 'package:audio_player/widgets/track_info_box.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key, required this.onRemoveToFavorite});
  final Function(BuildContext, SongModel) onRemoveToFavorite;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FavoritesEntity>>(
      future: favoritesEntities,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingIndicator();
        }
        if (snapshot.hasError) {
          return const ErrorIndicator();
        }
        if (snapshot.hasData) {
          favorites = snapshot.data!;
          addedFavorites = queryManager.favoriteToSongAdapter(favorites);

          if (addedFavorites.isEmpty) {
            return const EmptyListIndicator();
          }
          return Scrollbar(
            child: ValueListenableBuilder(
              valueListenable: order.orderStateNotifier,
              builder: (_, value, __) {
                if (value == false) {
                  return _buildFavorites(addedFavorites);
                }
                return _buildFavorites(addedFavorites, reversed: true);
              },
            ),
          );
        }
        return const EmptyListIndicator();
      },
    );
  }

  ListView _buildFavorites(List<SongModel> list, {bool reversed = false}) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        if (reversed) {
          index = list.length - 1 - index;
        }
        return ValueListenableBuilder(
          valueListenable: isBackArrowClickedNotifier,
          builder: (_, isClicked, __) {
            return ValueListenableBuilder(
              valueListenable: playerManager.currentTrackIDNotifier,
              builder: (_, id, __) {
                return ListTile(
                  tileColor: isClicked && addedFavorites[index].id == id
                      ? kNowPlayingTileColor
                      : Colors.transparent,
                  visualDensity: VisualDensity.comfortable,
                  leading: RoundedAvatar(
                    models: list,
                    index: index,
                    isClicked: isClicked,
                  ),
                  title: Text(
                    list[index].title,
                    style:
                        isClicked && list[index].id == id ? kNowPlayingTitleStyle : kTileTitleStyle,
                  ),
                  subtitle: Text(
                    list[index].album ?? '',
                    style:
                        isClicked && list[index].id == id ? kNowPlayingAlbumStyle : kTileAlbumStyle,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    color:
                        isClicked && list[index].id == id ? kNowPlayingAlbumColor : kTileAlbumColor,
                    onPressed: () async {
                      _showModalBottomSheet(index, list[index], context);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const PlayerScreen()));
                    playerManager.setPlaylist(index, list);
                    playerManager.play();
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showModalBottomSheet(int index, SongModel track, BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
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
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onRemoveToFavorite(context, track),
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
        });
  }
}
