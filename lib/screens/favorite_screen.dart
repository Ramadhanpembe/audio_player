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
          return ListView.builder(
            itemCount: addedFavorites.length,
            itemBuilder: (context, index) {
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
                          models: addedFavorites,
                          index: index,
                          isClicked: isClicked,
                        ),
                        title: Text(
                          addedFavorites[index].title,
                          style: isClicked && addedFavorites[index].id == id
                              ? kNowPlayingTitleStyle
                              : kTileTitleStyle,
                        ),
                        subtitle: Text(
                          addedFavorites[index].album ?? '',
                          style: isClicked && addedFavorites[index].id == id
                              ? kNowPlayingAlbumStyle
                              : kTileAlbumStyle,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_horiz),
                          color: isClicked && addedFavorites[index].id == id
                              ? kNowPlayingAlbumColor
                              : kTileAlbumColor,
                          onPressed: () async {
                            _showModalBottomSheet(index, addedFavorites[index], context);
                          },
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => const PlayerScreen()));
                          playerManager.setPlaylist(index, addedFavorites);
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
        return const EmptyListIndicator();
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
