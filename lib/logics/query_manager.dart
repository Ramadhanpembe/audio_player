import 'package:audio_player/logics/player_query_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class QueryManager {
  QueryManager() {
    _init();
  }

  Future<List<PlaylistEntity>> get initPlaylists async {
    return await audioRoom.queryPlaylists();
  }

  Future<bool> isPreAdded(
      RoomType roomType, int entityId, int playlistKey) async {
    return await audioRoom.checkIn(roomType, entityId,
        playlistKey: playlistKey);
  }

  Future<List<SongEntity>> getAllFromPlaylist(int? playlistKey) async {
    return await audioRoom.queryAllFromPlaylist(playlistKey!);
  }

  void _init() async {
    audioQuery = OnAudioQuery();
    audioRoom = OnAudioRoom();
    playlists = <PlaylistEntity>[];
    playlistEntities = initPlaylists;
    _requestPermission();
    tracks = <SongModel>[];
    entities = <SongEntity>[];
  }

  void _requestPermission() async {
    if (!kIsWeb) {
      bool status = await audioQuery.permissionsStatus();
      if (!status) {
        await audioQuery.permissionsRequest();
      }
    }
  }

  List<SongEntity> songToEntityAdapter(List<SongModel> songs) {
    List<SongEntity> songEntities = [];
    for (var element in songs) {
      songEntities.add(element.getMap.toSongEntity());
    }
    return songEntities;
  }

  List<SongModel> entityToSongAdapter(List<SongEntity> entities) {
    List<int> entityPlaylistIds = entities.getAllIds;
    List<SongModel> songPlaylist = [];
    for (int i in entityPlaylistIds) {
      songPlaylist.addAll(tracks.where((element) => element.id == i));
    }
    return songPlaylist;
  }

  void createPlaylist(String playlistName) async {
    if (playlistName.trim().isEmpty) return;
    await audioRoom.createPlaylist(playlistName);
  }

  void addToPlaylist(int? playlistKey, List<SongEntity> addedEntities) async {
    List<SongEntity> toBeRemoved = [];
    for (SongEntity en in addedEntities) {
      bool isAdded = await isPreAdded(RoomType.PLAYLIST, en.id, playlistKey!);
      if (isAdded) {
        toBeRemoved.add(en);
      }
    }
    addedEntities.removeWhere((element) => toBeRemoved.contains(element));
    if (addedEntities.isEmpty) return;
    await audioRoom.addAllTo(RoomType.PLAYLIST, addedEntities,
        playlistKey: playlistKey);
  }

  void removeFromPlaylist(int entityKey, int playlistKey) async {
    await audioRoom.deleteFrom(RoomType.PLAYLIST, entityKey,
        playlistKey: playlistKey);
  }

  // void deleteAllPlaylists() async {
  //   await audioRoom.clearAll();
  // }

  void dispose() {
    audioRoom.closeRoom();
  }
}
