// import 'dart:developer';
//
// import 'package:audio_player/notifiers/play_button_notifier.dart';
// import 'package:audio_player/notifiers/progress_bar_notifier.dart';
// import 'package:audio_player/notifiers/repeat_button_notifier.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:on_audio_query/on_audio_query.dart';
//
// import 'player_query_resources.dart';
//
// class PlayerManager {
//   PlayerManager() {
//     _init();
//   }
//
//   // used
//   final currentTrackIndexNotifier = ValueNotifier<int>(0);
//   final playlistNotifier = ValueNotifier<List<String>>([]);
//
//   // used
//   final progressBarNotifier = ProgressBarNotifier();
//   final repeatButtonNotifier = RepeatButtonNotifier();
//
//   // used
//   final isFirstTrackNotifier = ValueNotifier<bool>(true);
//
//   // used
//   final playButtonNotifier = PlayButtonNotifier();
//
//   // used
//   final isLastTrackNotifier = ValueNotifier<bool>(true);
//   final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
//
//   void _init() async {
//     audioPlayer = AudioPlayer();
//     _listenForChangeInSequenceState();
//
//     audioPlayer.playerStateStream.listen((playerState) {
//       final isPlaying = playerState.playing;
//       final processingState = playerState.processingState;
//
//       if (processingState == ProcessingState.loading ||
//           processingState == ProcessingState.buffering) {
//         playButtonNotifier.value = PlayButtonState.loading;
//       } else if (!isPlaying) {
//         playButtonNotifier.value = PlayButtonState.paused;
//       } else if (processingState != ProcessingState.completed) {
//         playButtonNotifier.value = PlayButtonState.playing;
//       } else {
//         audioPlayer.seek(Duration.zero);
//         audioPlayer.pause();
//       }
//     });
//
//     audioPlayer.positionStream.listen((position) {
//       final oldState = progressBarNotifier.value;
//       progressBarNotifier.value = ProgressBarState(
//         current: position,
//         total: oldState.total,
//         buffered: oldState.buffered,
//       );
//     });
//
//     audioPlayer.bufferedPositionStream.listen((buffered) {
//       final oldState = progressBarNotifier.value;
//       progressBarNotifier.value = ProgressBarState(
//         current: oldState.current,
//         total: oldState.total,
//         buffered: buffered,
//       );
//     });
//
//     audioPlayer.durationStream.listen((total) {
//       final oldState = progressBarNotifier.value;
//       progressBarNotifier.value = ProgressBarState(
//         current: oldState.current,
//         total: total ?? Duration.zero,
//         buffered: oldState.buffered,
//       );
//     });
//   }
//
//   void setInitialPlaylist(int index) async {
//     List<AudioSource> sources = [];
//     for (int i = 0; i < tracks.length; i++) {
//       AudioSource src = AudioSource.uri(Uri.parse(tracks[i].uri!), tag: i);
//       sources.add(src);
//     }
//     concatenatingAudioSource = ConcatenatingAudioSource(children: sources);
//     await audioPlayer.setAudioSource(concatenatingAudioSource,
//         initialIndex: index);
//   }
//
//   // for playlist use only
//   void setPlaylist(int index, List<SongModel> playlistSongs) async {
//     List<int> playlistTrackIds = [];
//     for (int i = 0; i < playlistSongs.length; i++) {
//       for (var t in tracks) {
//         if (playlistSongs[i].id == t.id) {
//           playlistTrackIds.add(t.id);
//         }
//       }
//     }
//     log(playlistTrackIds.toString());
//     List<int> indices = [];
//     for (int i = 0; i < tracks.length; i++) {
//       for (int p in playlistTrackIds) {
//         if (tracks[i].id == p) {
//           indices.add(i);
//         }
//       }
//     }
//     List<AudioSource> sources = [];
//     for (int i in indices) {
//       AudioSource src = AudioSource.uri(Uri.parse(tracks[i].uri!), tag: i);
//       sources.add(src);
//     }
//     concatenatingAudioSource = ConcatenatingAudioSource(children: sources);
//     await audioPlayer.setAudioSource(concatenatingAudioSource,
//         initialIndex: index);
//   }
//
//   void _listenForChangeInSequenceState() {
//     audioPlayer.sequenceStateStream.listen((sequenceState) {
//       if (sequenceState == null) return;
//       final currentItem = sequenceState.currentSource;
//       final index = currentItem?.tag;
//       currentTrackIndexNotifier.value = index;
//
//       final allTracks = sequenceState.effectiveSequence;
//       if (allTracks.isEmpty || currentItem == null) {
//         isFirstTrackNotifier.value = true;
//         isLastTrackNotifier.value = true;
//       } else {
//         // not working as expected
//         // isFirstTrackNotifier.value = allTracks.first == currentItem;
//         // isLastTrackNotifier.value = allTracks.last == currentItem;
//
//         /// trying mine - seems to work as expected
//         isFirstTrackNotifier.value = tracks.first == tracks[index];
//         isLastTrackNotifier.value = tracks.last == tracks[index];
//       }
//       isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;
//     });
//   }
//
//   void play() {
//     audioPlayer.play();
//   }
//
//   void pause() {
//     audioPlayer.pause();
//   }
//
//   void seek(Duration position) {
//     audioPlayer.seek(position);
//   }
//
//   void dispose() {
//     audioPlayer.dispose();
//   }
//
//   void onRepeatButtonPressed() {
//     repeatButtonNotifier.nextState();
//     switch (repeatButtonNotifier.value) {
//       case RepeatState.off:
//         audioPlayer.setLoopMode(LoopMode.off);
//         break;
//       case RepeatState.repeatOne:
//         audioPlayer.setLoopMode(LoopMode.one);
//         break;
//       case RepeatState.repeatAll:
//         audioPlayer.setLoopMode(LoopMode.all);
//     }
//   }
//
//   onPreviousTrackButtonPressed() {
//     audioPlayer.seekToPrevious();
//   }
//
//   onNextTrackButtonPressed() {
//     audioPlayer.seekToNext();
//   }
//
//   onShuffleButtonPressed() {
//     final enable = !audioPlayer.shuffleModeEnabled;
//     if (enable) {
//       audioPlayer.shuffle();
//     }
//     audioPlayer.setShuffleModeEnabled(enable);
//   }
//
//   /// First trial of the audio source
//   singleAudioSource(int index) async {
//     await audioPlayer
//         .setAudioSource(AudioSource.uri(Uri.parse(tracks[index].uri!)));
//   }
// }
