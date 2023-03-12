import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class PlayerScreen extends StatefulWidget {
  final SongModel song;
  final AudioPlayer audioPlayer;
  final List<SongModel> songs;
  const PlayerScreen({
    super.key,
    required this.song,
    required this.audioPlayer,
    required this.songs,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final AudioPlayer _audioPlayer = widget.audioPlayer;
  late final SongModel _song = widget.song;
  late final List<SongModel> _songs = widget.songs;
  // player position and current playing song duration state stream
  Stream<DurationStreams> get _durationStreams {
    return Rx.combineLatest3<Duration, Duration?, Duration?, DurationStreams>(
        _audioPlayer.positionStream,
        _audioPlayer.durationStream,
        _audioPlayer.bufferedPositionStream, (position, duration, buffer) {
      return DurationStreams(
          position: position,
          duration: duration ?? Duration.zero,
          buffer: buffer ?? Duration.zero);
    });
  }

  void checkLoopMode(AudioPlayer audioPlayer) {
    final loopMode = audioPlayer.loopMode;
    final shuffle = audioPlayer.shuffleModeEnabled;

    if (loopMode == LoopMode.all && !shuffle) {
      audioPlayer.setLoopMode(LoopMode.one);
    } else if (loopMode == LoopMode.one && !shuffle) {
      audioPlayer.setLoopMode(LoopMode.all);
      audioPlayer.setShuffleModeEnabled(true);
    } else {
      audioPlayer.setLoopMode(LoopMode.all);
      audioPlayer.setShuffleModeEnabled(false);
    }
  }

  @override
  void initState() {
    _audioPlayer.setLoopMode(LoopMode.off);
    _audioPlayer.setShuffleModeEnabled(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String trackTitle =
        _songs[_audioPlayer.nextIndex!].title.replaceRange(3, null, '');
    String trackAlbum = _songs[_audioPlayer.nextIndex!].album!;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              trackTitle,
              style: const TextStyle(fontSize: 24, letterSpacing: 2),
            ),
            Text(
              trackAlbum,
              style: const TextStyle(fontSize: 16, letterSpacing: 2),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // child: Image.asset('images/call_recorder_logo.png'),
                  child: QueryArtworkWidget(
                    id: _song.id,
                    type: ArtworkType.AUDIO,
                    artworkQuality: FilterQuality.high,
                    artworkBorder: BorderRadius.circular(12),
                    nullArtworkWidget: Image.asset(
                      'images/music_music.png',
                      color: Colors.grey,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite_border),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert),
                              ),
                            ],
                          ),

                          /// There is a bug here for playing zero seconds audios
                          RepaintBoundary(
                            child: Container(
                              color: Colors.transparent,
                              child: StreamBuilder<DurationStreams>(
                                stream: _durationStreams,
                                builder: (context, snapshot) {
                                  final durationStates = snapshot.data;
                                  final progress =
                                      durationStates?.position ?? Duration.zero;
                                  final duration =
                                      durationStates?.duration ?? Duration.zero;
                                  final buffered =
                                      durationStates?.buffer ?? Duration.zero;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 24),
                                    child: ProgressBar(
                                      progress: progress,
                                      total: duration,
                                      buffered: buffered,
                                      barHeight: 3,
                                      thumbRadius: 7.0,
                                      thumbColor: Colors.indigo,
                                      thumbGlowColor: Colors.white70,
                                      thumbGlowRadius: 30,
                                      bufferedBarColor:
                                          Colors.indigoAccent.shade200,
                                      progressBarColor: Colors.indigo,
                                      baseBarColor: Colors.indigo.shade300,
                                      timeLabelLocation:
                                          TimeLabelLocation.sides,
                                      timeLabelType:
                                          TimeLabelType.remainingTime,
                                      thumbCanPaintOutsideBar: true,
                                      timeLabelPadding: 5.0,
                                      onSeek: (duration) {
                                        _audioPlayer.seek(duration);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              checkLoopMode(_audioPlayer);
                            },
                            icon: StreamBuilder<LoopMode>(
                                stream: _audioPlayer.loopModeStream,
                                builder: (context, snapshot) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      trackTitle;
                                      trackAlbum;
                                    });
                                  });
                                  final loopMode = snapshot.data;
                                  final shuffle =
                                      _audioPlayer.shuffleModeEnabled;
                                  if (loopMode == LoopMode.all && !shuffle) {
                                    _audioPlayer.seekToNext();
                                    return const Icon(Icons.repeat);
                                  } else if (loopMode == LoopMode.one &&
                                      !shuffle) {
                                    return const Icon(Icons.repeat_one);
                                  } else {
                                    _audioPlayer.shuffle();
                                    return const Icon(Icons.shuffle);
                                  }
                                }),
                            iconSize: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_audioPlayer.hasPrevious) {
                                    _audioPlayer.seekToPrevious();
                                  }
                                },
                                icon:
                                    const FaIcon(FontAwesomeIcons.backwardStep),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_audioPlayer.playing) {
                                    _audioPlayer.stop();
                                  } else {
                                    _audioPlayer.play();
                                  }
                                },
                                icon: !_audioPlayer.playing
                                    ? const Icon(
                                        Icons.play_circle,
                                        // opticalSize: 150,
                                      )
                                    : const Icon(Icons.pause_circle),
                                iconSize: 80,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_audioPlayer.hasNext) {
                                    _audioPlayer.seekToNext();
                                  }
                                },
                                icon:
                                    const FaIcon(FontAwesomeIcons.forwardStep),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(Icons.shuffle),
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// position and duration state class
class DurationStreams {
  DurationStreams(
      {this.position = Duration.zero,
      this.duration = Duration.zero,
      this.buffer = Duration.zero});
  Duration position, duration, buffer;
}
