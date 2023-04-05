import 'package:audio_player/notifiers/play_button_notifier.dart';
import 'package:audio_player/notifiers/progress_bar_notifier.dart';
import 'package:audio_player/notifiers/repeat_button_notifier.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'player_query_resources.dart';

class PlayerManager {
  PlayerManager() {
    _init();
  }

  final currentTrackIndexNotifier = ValueNotifier<int>(0);
  final currentTrackTitleNotifier = ValueNotifier<String>('');
  final currentTrackAlbumNotifier = ValueNotifier<String>('');
  final currentTrackIDNotifier = ValueNotifier<int>(0);
  final currentPositionNotifier = ValueNotifier<Duration>(Duration.zero);
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressBarNotifier = ProgressBarNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstTrackNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastTrackNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  void _init() async {
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  void _listenToPlaybackState() {
    audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = PlayButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = PlayButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = PlayButtonState.playing;
      } else {
        audioHandler.seek(Duration.zero);
        audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      currentPositionNotifier.value = position;
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    audioHandler.playbackState.listen((playbackState) {
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: playbackState.bufferedPosition,
          total: oldState.total);
    });
  }

  void _listenToTotalDuration() {
    audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    audioHandler.mediaItem.listen((mediaItem) {
      currentTrackIndexNotifier.value = mediaItem?.extras!['tag'] ?? 0;
      currentTrackIDNotifier.value = mediaItem?.extras!['ID'] ?? 0;
      currentTrackTitleNotifier.value = mediaItem?.extras!['title'] ?? 'Now Playing';
      currentTrackAlbumNotifier.value = mediaItem?.extras!['album'] ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = audioHandler.mediaItem.value;
    final playlist = audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstTrackNotifier.value = true;
      isLastTrackNotifier.value = true;
    } else {
      isFirstTrackNotifier.value = playlist.first == mediaItem;
      isLastTrackNotifier.value = playlist.last == mediaItem;
    }
  }

  // Designed to be used in search bar if song is clicked
  void playSelected(int index, int id) async {
    int trackIndex = 0;
    for (int i = 0; i < tracks.length; i++) {
      if (tracks[i].id == id) {
        trackIndex = i;
      }
    }
    MediaItem mediaItem = MediaItem(
        id: '${tracks[trackIndex].id}',
        title: tracks[trackIndex].title,
        album: '${tracks[trackIndex].album}',
        genre: '${tracks[trackIndex].genre}',
        artist: '${tracks[trackIndex].artist}',
        duration: Duration(milliseconds: tracks[trackIndex].duration ?? 0),
        extras: {'uri': '${tracks[trackIndex].uri}', 'tag': trackIndex});

    await audioHandler.addQueueItem(mediaItem);
  }

  void setInitialPlaylist(int index) async {
    List<MediaItem> mediaItems = [];
    for (int i = 0; i < tracks.length; i++) {
      mediaItems.add(MediaItem(
        id: '${tracks[i].id}',
        title: tracks[i].title,
        album: tracks[i].album,
        genre: tracks[i].genre,
        artist: tracks[i].artist,
        duration: Duration(milliseconds: tracks[i].duration!),
        extras: {
          'uri': '${tracks[i].uri}',
          'ID': tracks[i].id,
          'title': tracks[i].title,
          'album': tracks[i].album,
        },
      ));
    }
    await audioHandler.addQueueItems(mediaItems);
    await audioHandler.skipToQueueItem(index);
  }

  // void setPlaylist(int index, List<SongModel> playlistSongs) async {
  //   // List<int> playlistTrackIds = [];
  //   // for (int i = 0; i < playlistSongs.length; i++) {
  //   //   for (var t in tracks) {
  //   //     if (playlistSongs[i].id == t.id) {
  //   //       playlistTrackIds.add(t.id);
  //   //     }
  //   //   }
  //   // }
  //   // List<int> indices = [];
  //   // for (int i = 0; i < tracks.length; i++) {
  //   //   for (int p in playlistTrackIds) {
  //   //     if (tracks[i].id == p) {
  //   //       indices.add(i);
  //   //     }
  //   //   }
  //   // }
  //   List<MediaItem> mediaItems = [];
  //   for (int i = 0; i < playlistSongs.length; i++) {
  //     mediaItems.add(MediaItem(
  //       id: '${playlistSongs[i].id}',
  //       title: playlistSongs[i].title,
  //       album: playlistSongs[i].album,
  //       genre: playlistSongs[i].genre,
  //       artist: playlistSongs[i].artist,
  //       duration: Duration(milliseconds: playlistSongs[i].duration!),
  //       extras: {'uri': '${playlistSongs[i].uri}',
  //         'ID': playlistSongs[i].id,
  //         'title': playlistSongs[i].title,
  //         'album': playlistSongs[i].album,
  //       },
  //     ));
  //   }
  //   await audioHandler.updateQueue(mediaItems);
  //   await audioHandler.skipToQueueItem(index);
  // }

  void setPlaylist(int index, List<SongModel> models) async {
    List<MediaItem> mediaItems = [];
    for (int i = 0; i < models.length; i++) {
      mediaItems.add(MediaItem(
        id: '${models[i].id}',
        title: models[i].title,
        album: models[i].album,
        genre: models[i].genre,
        artist: models[i].artist,
        duration: Duration(milliseconds: models[i].duration!),
        extras: {
          'uri': '${models[i].uri}',
          'ID': models[i].id,
          'title': models[i].title,
          'album': models[i].album,
          'tag': i,
        },
      ));
    }

    await audioHandler.updateQueue(mediaItems);
    await audioHandler.skipToQueueItem(index);
  }

  void play() => audioHandler.play();

  void pause() => audioHandler.pause();

  void seek(Duration position) => audioHandler.seek(position);

  void previous() => audioHandler.skipToPrevious();

  void next() => audioHandler.skipToNext();

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatAll:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
      case RepeatState.repeatOne:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
    }
  }

  void shuffle() {
    final enabled = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enabled;
    if (enabled) {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  void dispose() {
    audioHandler.stop();
  }
}
