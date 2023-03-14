import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../logics/audio_data_models.dart' as am;
import '../logics/track_manager.dart' as tm;

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  void initState() {
    tm.requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    am.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: am.audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
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
            child: Text('No Audio Found'),
          );
        }
        am.tracks = snapshot.data!;
        return ListView.builder(
          itemCount: am.tracks.length,
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
                    fit: BoxFit.fill,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(am.tracks.elementAt(index).displayName),
              subtitle: Text(am.tracks.elementAt(index).title),
              trailing: Text(am.tracks.elementAt(index).dateAdded.toString()),
              onTap: () {
                tm.onTrackTap(context, index);
                setState(() {});
              },
            );
          },
        );
      },
    );
  }
}
