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
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressBarNotifier = ProgressBarNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstTrackNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastTrackNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  void _init() async {
    // _listenToChangeInCurrentTrackIndex();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    // _listenForChangeInSequenceState();
    // audioPlayer.playerStateStream.listen((playerState) {
    //   final isPlaying = playerState.playing;
    //   final processingState = playerState.processingState;
    //
    //   if (processingState == ProcessingState.loading ||
    //       processingState == ProcessingState.buffering) {
    //     playButtonNotifier.value = PlayButtonState.loading;
    //   } else if (!isPlaying) {
    //     playButtonNotifier.value = PlayButtonState.paused;
    //   } else if (processingState != ProcessingState.completed) {
    //     playButtonNotifier.value = PlayButtonState.playing;
    //   } else {
    //     audioPlayer.seek(Duration.zero);
    //     audioPlayer.pause();
    //   }
    // });
    // audioPlayer.positionStream.listen((position) {
    //   final oldState = progressBarNotifier.value;
    //   progressBarNotifier.value = ProgressBarState(
    //     current: position,
    //     total: oldState.total,
    //     buffered: oldState.buffered,
    //   );
    // });
    // audioPlayer.bufferedPositionStream.listen((buffered) {
    //   final oldState = progressBarNotifier.value;
    //   progressBarNotifier.value = ProgressBarState(
    //     current: oldState.current,
    //     total: oldState.total,
    //     buffered: buffered,
    //   );
    // });
    // audioPlayer.durationStream.listen((total) {
    //   final oldState = progressBarNotifier.value;
    //   progressBarNotifier.value = ProgressBarState(
    //     current: oldState.current,
    //     total: total ?? Duration.zero,
    //     buffered: oldState.buffered,
    //   );
    // });
  }

  // void _listenToChangeInInitialPlaylist() {
  //   audioHandler.queue.listen((playlist) {
  //     if (playlist.isEmpty) return;
  //     final newList = playlist.map((item) => item.title).toList();
  //     playlistNotifier.value = newList;
  //   });
  // }

  /// This method might not work for the first time - its my own implementation
  // void _listenToChangeInCurrentTrackIndex() {
  //   audioHandler.queue.listen((playlist) {
  //     if (playlist.isEmpty) return;
  //     for (var item in playlist) {
  //       final index = item.extras!['tag'];
  //       currentTrackIndexNotifier.value = index;
  //     }
  //   });
  // }

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
  /// Not tested yet - seems to work
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
        extras: {'uri': '${tracks[i].uri}', 'tag': i},
      ));
    }
    await audioHandler.addQueueItems(mediaItems);
    await audioHandler.skipToQueueItem(index);
  }

  /// for playlist use only - will need to implement this method by Audio Handler
  void setPlaylist(int index, List<SongModel> playlistSongs) async {
    List<int> playlistTrackIds = [];
    for (int i = 0; i < playlistSongs.length; i++) {
      for (var t in tracks) {
        if (playlistSongs[i].id == t.id) {
          playlistTrackIds.add(t.id);
        }
      }
    }
    List<int> indices = [];
    for (int i = 0; i < tracks.length; i++) {
      for (int p in playlistTrackIds) {
        if (tracks[i].id == p) {
          indices.add(i);
        }
      }
    }
    List<MediaItem> mediaItems = [];
    for (int i = 0; i < indices.length; i++) {
      mediaItems.add(MediaItem(
        id: '${tracks[indices[i]].id}',
        title: tracks[indices[i]].title,
        album: tracks[indices[i]].album,
        genre: tracks[indices[i]].genre,
        artist: tracks[indices[i]].artist,
        duration: Duration(milliseconds: tracks[indices[i]].duration!),
        extras: {'uri': '${tracks[indices[i]].uri}', 'tag': indices[i]},
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
