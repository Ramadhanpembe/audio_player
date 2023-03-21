import 'dart:developer';

import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  audioHandler = await AudioService.init(
    builder: () => PlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ramadhanpembe.audio_player',
      androidNotificationChannelName: 'Play',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,

      /// Add androidNotificationIcon here
      // androidNotificationIcon:
    ),
  );
  return audioHandler;
}

class PlayerHandler extends BaseAudioHandler {
  final _initialPlaylist = ConcatenatingAudioSource(children: []);

  PlayerHandler() {
    _loadInitialPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChange();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    audioPlayer.playbackEventStream.listen((playbackEvent) {
      final playing = audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[audioPlayer.processingState]!,
        playing: playing,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        speed: audioPlayer.speed,
        queueIndex: playbackEvent.currentIndex,
      ));
    });
  }

  void _listenForDurationChange() {
    audioPlayer.durationStream.listen((duration) {
      final index = audioPlayer.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] == newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  UriAudioSource _createdAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(Uri.parse(mediaItem.extras!['uri']),
        tag: mediaItem.extras!['tag']);
  }

  Future<void> _loadInitialPlaylist() async {
    try {
      audioPlayer.setAudioSource(_initialPlaylist);
    } catch (err) {
      log('Error: $err');
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage just audio
    final audioSource =
        mediaItems.map((element) => _createdAudioSource(element));
    _initialPlaylist.addAll(audioSource.toList());
    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> play() => audioPlayer.play();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);
}
