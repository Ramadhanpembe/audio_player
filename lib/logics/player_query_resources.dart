import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

late OnAudioQuery audioQuery;

late OnAudioRoom audioRoom;

late AudioPlayer audioPlayer;

late AudioHandler audioHandler;

late List<SongModel> tracks;

late List<SongEntity> entities;

late List<SongEntity> addedEntities;

late List<SongModel> addedTracks;

late ConcatenatingAudioSource concatenatingAudioSource;

late List<PlaylistEntity> playlists;

late List<FavoritesEntity> favorites;

late List<SongModel> addedFavorites;

late Future<List<PlaylistEntity>> playlistEntities;

late Future<List<FavoritesEntity>> favoritesEntities;

late Future<List<SongModel>> songModels;

late Future<List<AlbumModel>> albumModels;

late Future<List<SongModel>> albumSongModels;

late List<SongModel> albumSongs;

late List<AlbumModel> albums;

late bool isFavorite;

final isBackArrowClickedNotifier = ValueNotifier<bool>(false);
