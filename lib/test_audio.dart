import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

void main() async {
  await OnAudioRoom().initRoom(RoomType.PLAYLIST);
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final OnAudioRoom _audioRoom = OnAudioRoom();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late int? _playlistKey;

  void _createPlaylist() async {
    _playlistKey = await _audioRoom.createPlaylist('Pembe');
    log('Is the return equal to 0?:, this playlist already exist: $_playlistKey');
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _createPlaylist();
  }

  void _requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _audioRoom.closeRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OnAudioRoomExample"),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => Information(playlistKey: _playlistKey)),
              );
            },
            icon: const Icon(Icons.featured_play_list),
          )
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: OnAudioQuery().querySongs(),
        builder: (_, item) {
          if (item.data != null) {
            List<SongModel> songs = item.data!;
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(songs[index].title),
                  subtitle: Text(songs[index].artist ?? "No artist"),
                  onTap: () async {
                    var isSongAdded = await _audioRoom.addTo(
                        RoomType.PLAYLIST, songs[index].getMap.toSongEntity(),
                        ignoreDuplicate: true, playlistKey: _playlistKey);
                    log('----------------------$isSongAdded------------');
                  },
                  onLongPress: () async {
                    bool isAdded = await _audioRoom.checkIn(
                      RoomType.PLAYLIST,
                      songs[index].id,
                      playlistKey: _playlistKey,
                    );
                    log('$isAdded');
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Information extends StatefulWidget {
  const Information({super.key, required this.playlistKey});
  final int? playlistKey;

  @override
  InformationState createState() => InformationState();
}

class InformationState extends State<Information> {
  final OnAudioRoom _audioRoom = OnAudioRoom();
  late final _playlistKey = widget.playlistKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OnAudioRoomExample"),
        actions: [
          IconButton(
            onPressed: () async {
              await _audioRoom.clearRoom(RoomType.PLAYLIST);
              setState(() {});
            },
            icon: const Icon(Icons.delete_forever_rounded),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<SongEntity>>(
          future: _audioRoom.queryAllFromPlaylist(_playlistKey!),
          builder: (context, item) {
            if (item.data == null) return const CircularProgressIndicator();

            if (item.data!.isEmpty) return const Text("No data found");

            List<SongEntity> tracks = item.data!;
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tracks[index].title),
                  subtitle: Text(tracks[index].dateAdded.toString()),
                  onTap: () async {
                    await _audioRoom.deleteFrom(
                        RoomType.PLAYLIST, tracks[index].id);
                    setState(() {});
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
