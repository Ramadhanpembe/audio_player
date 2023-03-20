import 'package:audio_player/notifiers/repeat_button_notifier.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../logics/player_query_resources.dart';
import '../main.dart';
import '../notifiers/play_button_notifier.dart';
import '../notifiers/progress_bar_notifier.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
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
            ValueListenableBuilder(
              valueListenable: playerManager.currentTrackIndexNotifier,
              builder: (_, index, __) {
                return Text(
                  tracks[index].displayName,
                  style: const TextStyle(fontSize: 24, letterSpacing: 2),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: playerManager.currentTrackIndexNotifier,
              builder: (_, index, __) {
                return Text(
                  tracks[index].displayName,
                  style: const TextStyle(fontSize: 16, letterSpacing: 2),
                );
              },
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
                ValueListenableBuilder(
                  valueListenable: playerManager.currentTrackIndexNotifier,
                  builder: (_, index, __) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 20),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QueryArtworkWidget(
                        id: tracks[index].id,
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
                    );
                  },
                ),
                Container(
                  color: Colors.tealAccent,
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

                          // Modified
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ValueListenableBuilder<ProgressBarState>(
                              valueListenable:
                                  playerManager.progressBarNotifier,
                              builder: (_, value, __) {
                                return _buildProgressBar(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: playerManager.repeatButtonNotifier,
                            builder: (context, value, child) {
                              Icon icon;
                              switch (value) {
                                case RepeatState.off:
                                  icon = const Icon(Icons.repeat,
                                      color: Colors.grey);
                                  break;
                                case RepeatState.repeatOne:
                                  icon = const Icon(Icons.repeat_one);
                                  break;
                                case RepeatState.repeatAll:
                                  icon = const Icon(Icons.repeat);
                                  break;
                              }
                              return IconButton(
                                onPressed: () {
                                  playerManager.onRepeatButtonPressed();
                                },
                                icon: icon,
                                iconSize: 30.0,
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ValueListenableBuilder(
                                valueListenable:
                                    playerManager.isFirstTrackNotifier,
                                builder: (_, isFirst, __) {
                                  return IconButton(
                                    onPressed: () {
                                      isFirst
                                          ? null
                                          : playerManager
                                              .onPreviousTrackButtonPressed();
                                    },
                                    icon: isFirst
                                        ? const FaIcon(
                                            FontAwesomeIcons.backwardStep,
                                            color: Colors.grey)
                                        : const FaIcon(
                                            FontAwesomeIcons.backwardStep),
                                  );
                                },
                              ),
                              ValueListenableBuilder<PlayButtonState>(
                                valueListenable:
                                    playerManager.playButtonNotifier,
                                builder: (_, value, __) {
                                  switch (value) {
                                    case PlayButtonState.loading:
                                      return IconButton(
                                        icon: const Icon(Icons.pause_circle),
                                        iconSize: 80.0,
                                        onPressed: () {
                                          playerManager.pause();
                                        },
                                      );

                                    case PlayButtonState.paused:
                                      return IconButton(
                                        icon: const Icon(Icons.play_circle),
                                        iconSize: 80.0,
                                        onPressed: () {
                                          playerManager.play();
                                        },
                                      );
                                    case PlayButtonState.playing:
                                      return IconButton(
                                        icon: const Icon(Icons.pause_circle),
                                        iconSize: 80.0,
                                        onPressed: () {
                                          playerManager.pause();
                                        },
                                      );
                                  }
                                },
                              ),
                              ValueListenableBuilder(
                                valueListenable:
                                    playerManager.isLastTrackNotifier,
                                builder: (_, isLast, __) {
                                  return IconButton(
                                    onPressed: () {
                                      isLast
                                          ? null
                                          : playerManager
                                              .onNextTrackButtonPressed();
                                    },
                                    icon: isLast
                                        ? const FaIcon(
                                            FontAwesomeIcons.forwardStep,
                                            color: Colors.grey)
                                        : const FaIcon(
                                            FontAwesomeIcons.forwardStep),
                                  );
                                },
                              ),
                            ],
                          ),
                          ValueListenableBuilder(
                            valueListenable:
                                playerManager.isShuffleModeEnabledNotifier,
                            builder: (context, isEnabled, child) {
                              return IconButton(
                                onPressed: () {
                                  playerManager.onShuffleButtonPressed();
                                },
                                icon: isEnabled
                                    ? const FaIcon(Icons.shuffle)
                                    : const FaIcon(Icons.shuffle,
                                        color: Colors.grey),
                                iconSize: 30,
                              );
                            },
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

  ProgressBar _buildProgressBar(ProgressBarState value) {
    return ProgressBar(
      progress: value.current,
      total: value.total,
      buffered: value.buffered,
      barHeight: 3.0,
      thumbRadius: 7.0,
      barCapShape: BarCapShape.square,
      thumbColor: Colors.indigo,
      thumbGlowColor: Colors.white70,
      thumbGlowRadius: 30.0,
      bufferedBarColor: Colors.indigoAccent.shade200,
      progressBarColor: Colors.indigo,
      baseBarColor: Colors.indigo.shade300,
      timeLabelLocation: TimeLabelLocation.below,
      timeLabelType: TimeLabelType.remainingTime,
      thumbCanPaintOutsideBar: true,
      timeLabelPadding: 5.0,
      onSeek: playerManager.seek,
    );
  }
}
