import 'dart:developer';

import 'package:audio_player/notifiers/play_button_notifier.dart';
import 'package:audio_player/notifiers/progress_bar_notifier.dart';
import 'package:audio_player/notifiers/repeat_button_notifier.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'logics/player_query_resources.dart';

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
    audioPlayer = AudioPlayer();
    _listenToChangeInCurrentTrackIndex();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
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
  void _listenToChangeInCurrentTrackIndex() {
    audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) return;
      for (var item in playlist) {
        final index = item.extras!['tag'];
        currentTrackIndexNotifier.value = index;
      }
    });
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

  void setInitialPlaylist() async {
    /// //////////////////////////////////////
    List<MediaItem> mediaItems = [];
    for (int i = 0; i < tracks.length; i++) {
      mediaItems.add(MediaItem(
          id: '${tracks[i].id}',
          album: tracks[i].album ?? '',
          title: tracks[i].title,
          extras: {'uri': tracks[i], 'tag': i}));
    }
    audioHandler.addQueueItems(mediaItems);

    /// /////////////////////////////////////
    // Original Codes
    // final mediaItems = tracks
    //     .map((track) => MediaItem(
    //           id: '${track.id}',
    //           album: track.album ?? '',
    //           title: track.title ?? '',
    //           extras: {'uri': track.uri},
    //         ))
    //     .toList();
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
    log(playlistTrackIds.toString());
    List<int> indices = [];
    for (int i = 0; i < tracks.length; i++) {
      for (int p in playlistTrackIds) {
        if (tracks[i].id == p) {
          indices.add(i);
        }
      }
    }
    List<AudioSource> sources = [];
    for (int i in indices) {
      AudioSource src = AudioSource.uri(Uri.parse(tracks[i].uri!), tag: i);
      sources.add(src);
    }
    concatenatingAudioSource = ConcatenatingAudioSource(children: sources);
    await audioPlayer.setAudioSource(concatenatingAudioSource,
        initialIndex: index);
  }

  void play() => audioHandler.play();

  void pause() => audioHandler.pause();

  void seek(Duration position) => audioHandler.seek(position);

  void previous() {}

  void next() {}

  void repeat() {}

  void shuffle() {}

  void add() {}

  void remove() {}

  void dispose() {}
}
