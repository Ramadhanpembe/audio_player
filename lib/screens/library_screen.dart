import 'package:audio_player/screens/player_screen.dart';
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
        orderType: OrderType.ASC_OR_SMALLER,
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
            child: Text('No Audio Found'),
          );
        }
        songs = snapshot.data!;
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            // return Text(songs.elementAt(index).displayName);
            // bool hasArtwork = _audioQuery.queryArtwork(songs.elementAt(index).id, )
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo,
                radius: 30,
                child: QueryArtworkWidget(
                  id: snapshot.data![index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Image.asset(
                    'images/musical_notes.png',
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fill,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(songs.elementAt(index).displayName),
              subtitle: Text(songs.elementAt(index).title),
              trailing: Text(songs.elementAt(index).dateAdded.toString()),
              onTap: () async {
                if (context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                            audioPlayer: _audioPlayer,
                            song: songs.elementAt(index),
                            songs: songs,
                            // sources: sources,
                          )));
                }
                await _audioPlayer.setAudioSource(
                  ConcatenatingAudioSource(
                    shuffleOrder: DefaultShuffleOrder(),
                    children: getAudioSources(songs),
                  ),
                  initialIndex: index,
                );
                await _audioPlayer.play();
              },
            );
          },
        );
      },
    );
  }
}

List<AudioSource> getAudioSources(List<SongModel> songs) {
  List<AudioSource> audioSources = [];
  for (var song in songs) {
    audioSources.add(AudioSource.uri(Uri.parse(song.uri!)));
  }
  return audioSources;
}
