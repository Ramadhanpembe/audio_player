import 'package:audio_player/logics/player_query_resources.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
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
    const snackBar =
        SnackBar(content: Center(child: Text('The track is already added!')));
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
      appBar: AppBar(
        title: Text('Add to ${playlists[_playlistIndex].playlistName}'),
        toolbarHeight: 100.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            // Adds tracks to the selected playlist
            child: IconButton(
              icon: const Icon(Icons.done),
              onPressed: () async {
                setState(() {
                  _addEntitiesToPlaylist(_selectedEntities);
                  Navigator.pop(context, true);
                });
              },
              iconSize: 50.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              value: isChecked[index],
              selected: isChecked[index]!,
              checkColor: Colors.red,
              activeColor: Colors.tealAccent,
              title: Text(tracks.elementAt(index).displayName),
              subtitle: Text(tracks.elementAt(index).title),
              secondary: CircleAvatar(
                backgroundColor: Colors.indigo,
                radius: 30.0,
                child: QueryArtworkWidget(
                  id: tracks[index].id,
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
              onChanged: (bool? value) async {
                bool isPreAdded = await queryManager.isPreAdded(
                    RoomType.PLAYLIST,
                    entities[index].id,
                    playlists[_playlistIndex].key);
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
    );
  }
}
