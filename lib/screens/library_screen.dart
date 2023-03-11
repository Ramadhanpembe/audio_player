import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // retrieves audios from storage
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // plays audio files
  final AudioPlayer _audioPlayer = AudioPlayer();

  // stores songs from the data fetched in the storage
  List<SongModel> songs = <SongModel>[];

  PageStorageKey songsStorageKey =
      const PageStorageKey('restore_songs_scroll_pos');
  // bool isPlayerControlsWidgetVisible = false;

  void requestPermission() async {
    if (!kIsWeb) {
      bool status = await _audioQuery.permissionsStatus();
      if (!status) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: _audioQuery.querySongs(
        sortType: SongSortType.DURATION,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
              value: 5,
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Audio Found!'),
          );
        }
        songs = snapshot.data!;
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            // return Text(songs.elementAt(index).displayName);
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.indigo,
                radius: 23,
                child: Text('P'),
              ),
              title: Text(songs.elementAt(index).displayName),
              subtitle: Text(songs.elementAt(index).title),
              trailing: Text(songs.elementAt(index).duration.toString()),
              onTap: () async {
                await _audioPlayer.setAudioSource(
                    AudioSource.uri(Uri.parse(songs[index].uri!)));
                await _audioPlayer.play();
              },
            );
          },
        );
      },
    );
  }
}
