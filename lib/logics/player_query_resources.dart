import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

late OnAudioQuery audioQuery;

late OnAudioRoom audioRoom;
// plays audio files
late AudioPlayer audioPlayer;

// audio service
late AudioHandler audioHandler;

// stores songs from the data fetched in the storage
late List<SongModel> tracks;

// stores entities obtained from [songToEntityAdapter]
late List<SongEntity> entities;

late List<SongEntity> addedEntities;

late List<SongModel> addedTracks;

// creating playlist - in my case the entire list of tracks first
late ConcatenatingAudioSource concatenatingAudioSource;

// trying to create playlists
late List<PlaylistEntity> playlists;

late List<FavoritesEntity> favorites;

late List<SongModel> addedFavorites;

late Future<List<PlaylistEntity>> playlistEntities;

late Future<List<FavoritesEntity>> favoritesEntities;

late Future<List<SongModel>> songModels;

late bool isFavorite;
