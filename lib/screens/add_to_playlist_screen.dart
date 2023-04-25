import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_player/widgets/rounded_avatar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../main.dart';

class AddToPlaylistScreen extends StatefulWidget {
  const AddToPlaylistScreen({super.key, required this.playlistIndex});
  final int playlistIndex;

  @override
  State<AddToPlaylistScreen> createState() => _AddToPlaylistScreenState();
}

class _AddToPlaylistScreenState extends State<AddToPlaylistScreen> {
  late final _playlistIndex = widget.playlistIndex;
  List<bool?> isChecked = List.generate(entities.length, (index) => false);

  void _addEntitiesToPlaylist(List<SongEntity> addedEntities) {
    queryManager.addToPlaylist(playlists[_playlistIndex].key, addedEntities);
  }

  void _showSnackBar() {
    const snackBar = SnackBar(
        backgroundColor: kPrimaryColor,
        content: Center(
            child: Text(
          'The track is already added!',
          style: TextStyle(color: kBackgroundColor),
        )));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<SongEntity> get _selectedEntities {
    List<SongEntity> selectedEntities = [];
    for (int index in _selectedIndices) {
      selectedEntities.add(entities[index]);
    }
    return selectedEntities;
  }

  List<int> get _selectedIndices {
    List<int> indices = [];
    for (int i = 0; i < isChecked.length; i++) {
      if (isChecked[i]!) {
        indices.add(i);
      }
    }
    return indices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add to ${playlists[_playlistIndex].playlistName}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            // Adds tracks to the selected playlist
            child: IconButton(
              icon: const Icon(
                Icons.done,
                color: kHeaderIconColor,
              ),
              onPressed: () async {
                setState(() {
                  _addEntitiesToPlaylist(_selectedEntities);
                  Navigator.pop(context, true);
                });
              },
              iconSize: 30.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                visualDensity: VisualDensity.comfortable,
                value: isChecked[index],
                selected: isChecked[index]!,
                checkColor: kBackgroundColor,
                activeColor: kTileTitleColor,
                title: Text(
                  tracks.elementAt(index).title,
                  style: kTileTitleStyle,
                ),
                subtitle: Text(
                  tracks.elementAt(index).album ?? '',
                  style: kTileAlbumStyle,
                ),
                secondary: RoundedAvatar(
                  models: tracks,
                  index: index,
                ),
                onChanged: (bool? value) async {
                  bool isPreAdded = await queryManager.isPreAdded(
                      RoomType.PLAYLIST, entities[index].id, playlists[_playlistIndex].key);
                  setState(() {
                    if (isPreAdded) {
                      isChecked[index] = false;
                      _showSnackBar();
                    } else {
                      isChecked[index] = value;
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
