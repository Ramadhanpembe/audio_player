import 'package:audio_player/features/feature_resource.dart';
import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/main.dart';
import 'package:audio_player/screens/album_inside_screen.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_player/widgets/album_display_icon.dart';
import 'package:audio_player/widgets/empty_list_indicator.dart';
import 'package:audio_player/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    _updateOnce();
  }

  void _updateOnce() {
    if (_isFirstLaunch) {
      albumModels = queryManager.initAlbums;
      setState(() {});
    }
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('firstLaunch')) {
      setState(() {
        _isFirstLaunch = false;
      });
    } else {
      prefs.setBool('firstLaunch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AlbumModel>>(
      future: albumModels,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const LoadingIndicator();
        } else if (snapshot.data!.isEmpty) {
          return const LoadingIndicator();
        }
        albums = snapshot.data!;
        if (albums.isEmpty) {
          return const EmptyListIndicator();
        }
        return Scrollbar(
          child: ValueListenableBuilder(
            valueListenable: order.orderStateNotifier,
            builder: (_, value, __) {
              if (value == false) {
                return _buildAlbums(albums);
              }
              return _buildAlbums(albums, reversed: true);
            },
          ),
        );
      },
    );
  }

  ListView _buildAlbums(List<dynamic> list, {bool reversed = false}) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        if (reversed) {
          index = list.length - 1 - index;
        }
        return Column(
          children: [
            ListTile(
              visualDensity: VisualDensity.comfortable,
              leading: AlbumDisplayIcon(index: index),
              trailing: list[index].numOfSongs <= 1
                  ? Text('${list[index].numOfSongs} track', style: kTileAlbumStyle)
                  : Text('${list[index].numOfSongs} tracks', style: kTileAlbumStyle),
              title: Text(
                list[index].album,
                style: kTileTitleStyle,
              ),
              onTap: () async {
                albumSongModels = queryManager.initAlbumSongs(index);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AlbumInsideScreen(
                      futureModels: albumSongModels,
                      albumIndex: index,
                    ),
                  ),
                );
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
  }
}
