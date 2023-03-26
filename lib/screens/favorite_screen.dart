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

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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
              return ListTile(
                visualDensity: VisualDensity.comfortable,
                leading: RoundedAvatar(
                  models: addedFavorites,
                  index: index,
                ),
                title: Text(
                  addedFavorites[index].title,
                  style: kTileTitleStyle,
                ),
                subtitle: Text(
                  addedFavorites[index].album ?? '',
                  style: kTileAlbumStyle,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_horiz),
                  color: kTileAlbumColor,
                  onPressed: () async {
                    _showModalBottomSheet(index, addedFavorites[index]);
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
        }
        return const EmptyListIndicator();
      },
    );
  }

  void _showModalBottomSheet(int index, SongModel track) {
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
                      onPressed: () {
                        queryManager.removeFromFavorite(track);
                        Navigator.pop(context);
                        setState(() {});
                        favoritesEntities = queryManager.initFavorites;
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
