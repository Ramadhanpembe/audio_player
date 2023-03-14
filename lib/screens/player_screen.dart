import 'package:audio_player/logics/track_manager.dart' as tm;
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../logics/audio_data_models.dart' as am;
import '../logics/player_manager.dart' as pm;
import '../models/duration_streams.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.trackIndex});
  final int trackIndex;
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final int _currentTrackIndex = widget.trackIndex;
  late SongModel _playingTrack = am.tracks[_currentTrackIndex];

  _concatenating() async {
    await tm.setConcatenatingAudioSource(am.tracks.indexOf(_playingTrack));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _playingTrack.displayName,
              style: const TextStyle(fontSize: 24, letterSpacing: 2),
            ),
            Text(
              _playingTrack.title,
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
                  child: QueryArtworkWidget(
                    id: _playingTrack.id,
                    type: ArtworkType.AUDIO,
                    keepOldArtwork: true,
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
                                stream: pm.durationStreams,
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
                                      barHeight: 3.0,
                                      thumbRadius: 7.0,
                                      thumbColor: Colors.indigo,
                                      thumbGlowColor: Colors.white70,
                                      thumbGlowRadius: 30.0,
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
                                        am.audioPlayer.seek(duration);
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
                              pm.checkLoopMode();

                              // am.audioPlayer.playbackEventStream.listen((e) => {
                              //       setState(() {
                              //         final index =
                              //             am.audioPlayer.currentIndex ?? 0;
                              //         _playingTrack = am.audioPlayer.audioSource
                              //             ?.sequence[index].tag;
                              //       })
                              //     });

                              // am.audioPlayer.sequenceStateStream
                              //     .listen((sequenceState) {
                              //   if (sequenceState == null) return;
                              //   final currentSource =
                              //       sequenceState.currentSource;
                              //
                              //   SongModel sm =
                              //       am.tracks[currentSource?.tag as int];
                              //
                              //   final currentTrack =
                              //       // currentSource?.tag as SongModel;
                              //       _playingTrack = sm;
                              // });

                              // if (am.audioPlayer.loopMode == LoopMode.all) {
                              //   if (am.audioPlayer.playing) {
                              //     setState(() {
                              //       _playingTrack = pm.nextTrack;
                              //
                              //       // am.tracks[am.audioPlayer.currentIndex!];
                              //     });
                              //     // setState(() {});
                              //   }
                              // }
                            },
                            icon: StreamBuilder<LoopMode>(
                                stream: am.audioPlayer.loopModeStream,
                                builder: (context, snapshot) {
                                  final loopMode = snapshot.data;
                                  if (loopMode == LoopMode.off) {
                                    /// WORKING
                                    // WidgetsBinding.instance
                                    //     .addPostFrameCallback((_) {
                                    //   setState(() {
                                    //     _playingTrack = am.tracks[
                                    //         am.audioPlayer.currentIndex!];
                                    //   });
                                    // });
                                    // WidgetsBinding.instance
                                    //     .addPostFrameCallback((_) {
                                    //   setState(() {
                                    //     _playingTrack =
                                    //         am.tracks[_currentTrackIndex];
                                    //   });
                                    // });

                                    // am.audioPlayer.sequenceStateStream
                                    //     .listen((sequenceState) {
                                    //   if (sequenceState == null) return;
                                    //   final currentSource =
                                    //       sequenceState.currentSource;
                                    //
                                    //   SongModel sm =
                                    //       am.tracks[currentSource?.tag as int];
                                    //   // final currentTrack =
                                    //   // currentSource?.tag as SongModel;
                                    //   _playingTrack = sm;
                                    // });

                                    // am.audioPlayer.playerStateStream
                                    //     .listen((event) {
                                    //   if (event.processingState ==
                                    //       ProcessingState.completed) {
                                    //     // TODO: Something to be done here, this is reachable
                                    //     if (kDebugMode) {
                                    //       print(
                                    //           '=========================================');
                                    //     }
                                    //   }
                                    // });

                                    return const Icon(
                                        Icons.disabled_by_default_outlined);
                                  } else if (loopMode == LoopMode.all) {
                                    // TODO: This is next part to be done today in shaa Allah
                                    // no problem here
                                    _concatenating();
                                    // am.audioPlayer.playerStateStream
                                    //     .listen((event) {
                                    //   if (event.processingState ==
                                    //       ProcessingState.completed) {
                                    //     // TODO: Something to be done here, this is reachable
                                    //     if (kDebugMode) {
                                    //       print(
                                    //           '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                                    //     }
                                    //   }
                                    // });
                                    return const Icon(Icons.repeat);
                                  } else {
                                    /// WORKING
                                    return const Icon(Icons.repeat_one);
                                  }
                                }),
                            iconSize: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (am.audioPlayer.hasPrevious) {
                                    am.audioPlayer.seekToPrevious();
                                  }
                                },
                                icon:
                                    const FaIcon(FontAwesomeIcons.backwardStep),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (am.audioPlayer.playing) {
                                    am.audioPlayer.stop();
                                  } else {
                                    am.audioPlayer.play();
                                  }
                                },
                                icon: !am.audioPlayer.playing
                                    ? const Icon(
                                        Icons.play_circle,
                                        // opticalSize: 150,
                                      )
                                    : const Icon(Icons.pause_circle),
                                iconSize: 80,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (am.audioPlayer.hasNext) {
                                    am.audioPlayer.seekToNext();
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
