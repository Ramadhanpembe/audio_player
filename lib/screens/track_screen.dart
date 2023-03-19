import 'package:audio_player/main.dart';
import 'package:audio_player/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../logics/player_query_resources.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(color: Colors.indigo),
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Audio Found'),
          );
        }
        tracks = snapshot.data!;
        entities = queryManager.songToEntityAdapter(tracks);
        return ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo,
                radius: 30.0,
                child: QueryArtworkWidget(
                  id: snapshot.data![index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Image.asset(
                    'images/musical_notes.png',
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.contain,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(tracks.elementAt(index).displayName),
              subtitle: Text(tracks.elementAt(index).title),
              trailing: Text(tracks.elementAt(index).dateAdded.toString()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PlayerScreen()));
                // pageManager.audioSource(index);
                playerManager.setInitialPlaylist(index);
                playerManager.play();

                // setState(() {});
              },
            );
          },
        );
      },
    );
  }
}
