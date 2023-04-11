import 'package:audio_player/logics/player_query_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class QueryManager {
  QueryManager() {
    _init();
  }

  Future<bool> isPermissionGranted() async {
    return await audioQuery.permissionsStatus();
  }

  Future<bool> isFavorite(SongModel model) {
    return audioRoom.checkIn(RoomType.FAVORITES, model.id);
  }

  Future<List<PlaylistEntity>> get initPlaylists async {
    return await audioRoom.queryPlaylists();
  }

  Future<List<FavoritesEntity>> get initFavorites async {
    return await audioRoom.queryFavorites();
  }

  Future<List<AlbumModel>> get initAlbums async {
    return await audioQuery.queryAlbums(
        sortType: AlbumSortType.ALBUM,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true);
  }

  Future<List<SongModel>> initAlbumSongs(int index) async {
    return await audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM,
      albums[index].album,
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
    );
  }

  Future<List<SongModel>> get initSongs async {
    return audioQuery.querySongs(
      sortType: SongSortType.DISPLAY_NAME,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  Future<bool> isPreAdded(RoomType roomType, int entityId, int playlistKey) async {
    return await audioRoom.checkIn(roomType, entityId, playlistKey: playlistKey);
  }

  Future<List<SongEntity>> getAllFromPlaylist(int? playlistKey) async {
    return await audioRoom.queryAllFromPlaylist(playlistKey!);
  }

  void _init() async {
    audioQuery = OnAudioQuery();
    audioRoom = OnAudioRoom();
    _requestPermission();
    playlists = <PlaylistEntity>[];
    favorites = <FavoritesEntity>[];
    songModels = initSongs;
    playlistEntities = initPlaylists;
    favoritesEntities = initFavorites;
    tracks = <SongModel>[];
    entities = <SongEntity>[];
    albumModels = initAlbums;
    albums = <AlbumModel>[];
    albumSongs = <SongModel>[];
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
    await audioRoom.addAllTo(RoomType.PLAYLIST, addedEntities, playlistKey: playlistKey);
  }

  void removeFromPlaylist(int entityKey, int playlistKey) async {
    await audioRoom.deleteFrom(RoomType.PLAYLIST, entityKey, playlistKey: playlistKey);
  }

  // entityIds are the same as the modelIds
  void removeAllFromPlaylist(List<SongEntity> entities, int playlistKey) async {
    for (SongEntity entity in entities) {
      removeFromPlaylist(entity.id, playlistKey);
    }
  }

  void renamePlaylist(int playlistKey, String newName) async {
    if (newName.trim().isEmpty) return;
    audioRoom.renamePlaylist(playlistKey, newName);
  }

  void deletePlaylist(int playlistKey) async {
    await audioRoom.deletePlaylist(playlistKey);
  }

  void updatePlaylist(PlaylistEntity playlistEntity) async {
    await audioRoom.updateRoom(RoomType.PLAYLIST, playlistEntity);
  }

  void addToFavorite(FavoritesEntity favorite) async {
    await audioRoom.addTo(RoomType.FAVORITES, favorite);
  }

  void removeFromFavorite(SongModel model) async {
    await audioRoom.deleteFrom(RoomType.FAVORITES, model.id);
  }

  List<SongModel> favoriteToSongAdapter(List<FavoritesEntity> favoritesEntities) {
    List<SongEntity> entities = [];
    for (FavoritesEntity favorite in favoritesEntities) {
      entities.add(favorite.getMap.toSongEntity());
    }
    return entityToSongAdapter(entities);
  }

  void dispose() {
    audioRoom.closeRoom();
  }
}
