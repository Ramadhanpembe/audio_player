import 'package:audio_player/logics/player_query_resources.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  audioPlayer = AudioPlayer();
  concatenatingAudioSource = ConcatenatingAudioSource(children: []);
  audioHandler = await AudioService.init(
    builder: () => PlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ramadhanpembe.audio_player',
      androidNotificationChannelName: 'Play',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,

      /// Add androidNotificationIcon here
      androidNotificationIcon: 'mipmap/notification_icon',
    ),
  );
  return audioHandler;
}

class PlayerHandler extends BaseAudioHandler {
  PlayerHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChange();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
    _listenOnPlaybackSpeed();
    _listenOnPlaybackVolume();
  }

  static final speedNotifier = ValueNotifier<double>(1.0);
  static final volumeNotifier = ValueNotifier<double>(0.5);

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
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all
        }[audioPlayer.loopMode]!,
        shuffleMode: (audioPlayer.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
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
      var index = audioPlayer.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (audioPlayer.shuffleModeEnabled) {
        index = audioPlayer.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] == newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (audioPlayer.shuffleModeEnabled) {
        index = audioPlayer.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    audioPlayer.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  void _listenOnPlaybackSpeed() {
    audioPlayer.speedStream.listen((speed) {
      final speedValue = double.parse(speed.toStringAsFixed(1));
      speedNotifier.value = speedValue;
    });
  }

  void _listenOnPlaybackVolume() {
    audioPlayer.volumeStream.listen((volume) {
      final volumeLevel = double.parse(volume.toStringAsFixed(1));
      volumeNotifier.value = volumeLevel;
    });
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) =>
      audioPlayer.setVolume(extras!['volume']);

  @override
  Future<void> setSpeed(double speed) => audioPlayer.setSpeed(speed);

  @override
  Future<void> play() => audioPlayer.play();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> skipToNext() => audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => audioPlayer.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        audioPlayer.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        audioPlayer.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        audioPlayer.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      audioPlayer.setShuffleModeEnabled(false);
    } else {
      await audioPlayer.shuffle();
      audioPlayer.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> stop() async {
    await audioPlayer.dispose();
    return super.stop();
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    await audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(mediaItem.extras!['uri']), tag: mediaItem));
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    List<AudioSource> srcs = [];
    for (var mediaItem in mediaItems) {
      srcs.add(AudioSource.uri(Uri.parse(mediaItem.extras!['uri']), tag: mediaItem));
    }
    concatenatingAudioSource = ConcatenatingAudioSource(children: srcs);

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    List<AudioSource> srcs = [];
    for (var mediaItem in queue) {
      srcs.add(AudioSource.uri(Uri.parse(mediaItem.extras!['uri']), tag: mediaItem));
    }
    concatenatingAudioSource = ConcatenatingAudioSource(children: srcs);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    await audioPlayer.setAudioSource(
      concatenatingAudioSource,
      initialIndex: index,
    );
  }
}
