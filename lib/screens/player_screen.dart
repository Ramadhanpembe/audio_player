import 'package:audio_player/notifiers/repeat_button_notifier.dart';
import 'package:audio_player/utils/constants.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
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
  double _toolbarHeight(BuildContext context) {
    return MediaQuery.of(context).size.height / 8;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(interceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }

  bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    isBackArrowClickedNotifier.value = true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: _toolbarHeight(context),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            isBackArrowClickedNotifier.value = true;
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: playerManager.currentTrackIndexNotifier,
              builder: (_, index, __) {
                return SizedBox(
                  height: _toolbarHeight(context) * 0.6,
                  child: Marquee(
                    text: tracks[index].title.trim(),
                    blankSpace: 15.0,
                    velocity: 60.0,
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: playerManager.currentTrackIndexNotifier,
              builder: (_, index, __) {
                return Text(
                  tracks[index].album?.trim().toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 16.0),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 15,
                  vertical: MediaQuery.of(context).size.height / 30),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: orientation == Orientation.portrait
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: playerManager.currentTrackIndexNotifier,
                            builder: (_, index, __) {
                              return Expanded(
                                flex: 4,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
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
                                      color: kMusicTonesColor,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ValueListenableBuilder<ProgressBarState>(
                                  valueListenable: playerManager.progressBarNotifier,
                                  builder: (_, value, __) {
                                    return _buildProgressBar(value);
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: playerManager.repeatButtonNotifier,
                                      builder: (context, value, child) {
                                        Icon icon;
                                        switch (value) {
                                          case RepeatState.off:
                                            icon =
                                                const Icon(Icons.repeat, color: kDisabledIconColor);
                                            break;
                                          case RepeatState.repeatOne:
                                            icon = const Icon(
                                              Icons.repeat_one,
                                              color: kIconColor,
                                            );
                                            break;
                                          case RepeatState.repeatAll:
                                            icon = const Icon(
                                              Icons.repeat,
                                              color: kIconColor,
                                            );
                                            break;
                                        }
                                        return IconButton(
                                          onPressed: () {
                                            playerManager.repeat();
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
                                          valueListenable: playerManager.isFirstTrackNotifier,
                                          builder: (_, isFirst, __) {
                                            return IconButton(
                                              onPressed: () {
                                                isFirst ? null : playerManager.previous();
                                              },
                                              icon: isFirst
                                                  ? const FaIcon(
                                                      FontAwesomeIcons.backwardStep,
                                                      color: kIconColor,
                                                    )
                                                  : const FaIcon(
                                                      FontAwesomeIcons.backwardStep,
                                                      color: kIconColor,
                                                    ),
                                            );
                                          },
                                        ),
                                        ValueListenableBuilder<PlayButtonState>(
                                          valueListenable: playerManager.playButtonNotifier,
                                          builder: (_, value, __) {
                                            switch (value) {
                                              case PlayButtonState.loading:
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons.pause_circle,
                                                    color: kIconColor,
                                                  ),
                                                  iconSize: 80.0,
                                                  onPressed: () {
                                                    playerManager.pause();
                                                  },
                                                );

                                              case PlayButtonState.paused:
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons.play_circle,
                                                    color: kIconColor,
                                                  ),
                                                  iconSize: 80.0,
                                                  onPressed: () {
                                                    playerManager.play();
                                                  },
                                                );
                                              case PlayButtonState.playing:
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons.pause_circle,
                                                    color: kIconColor,
                                                  ),
                                                  iconSize: 80.0,
                                                  onPressed: () {
                                                    playerManager.pause();
                                                  },
                                                );
                                            }
                                          },
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: playerManager.isLastTrackNotifier,
                                          builder: (_, isLast, __) {
                                            return IconButton(
                                              onPressed: () {
                                                isLast ? null : playerManager.next();
                                              },
                                              icon: isLast
                                                  ? const FaIcon(
                                                      FontAwesomeIcons.forwardStep,
                                                      color: kIconColor,
                                                    )
                                                  : const FaIcon(
                                                      FontAwesomeIcons.forwardStep,
                                                      color: kIconColor,
                                                    ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: playerManager.isShuffleModeEnabledNotifier,
                                      builder: (context, isEnabled, child) {
                                        return IconButton(
                                          onPressed: () {
                                            playerManager.shuffle();
                                          },
                                          icon: isEnabled
                                              ? const FaIcon(
                                                  Icons.shuffle,
                                                  color: kIconColor,
                                                )
                                              : const FaIcon(
                                                  Icons.shuffle,
                                                  color: kDisabledIconColor,
                                                ),
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
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: playerManager.currentTrackIndexNotifier,
                            builder: (_, index, __) {
                              return Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
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
                                      color: const Color(0x0d0C2D48),
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                            icon =
                                                const Icon(Icons.repeat, color: kDisabledIconColor);
                                            break;
                                          case RepeatState.repeatOne:
                                            icon = const Icon(
                                              Icons.repeat_one,
                                              color: kIconColor,
                                            );
                                            break;
                                          case RepeatState.repeatAll:
                                            icon = const Icon(
                                              Icons.repeat,
                                              color: kIconColor,
                                            );
                                            break;
                                        }
                                        return IconButton(
                                          onPressed: () {
                                            playerManager.repeat();
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
                                          valueListenable: playerManager.isFirstTrackNotifier,
                                          builder: (_, isFirst, __) {
                                            return IconButton(
                                              onPressed: () {
                                                isFirst ? null : playerManager.previous();
                                              },
                                              icon: isFirst
                                                  ? const FaIcon(
                                                      FontAwesomeIcons.backwardStep,
                                                      color: kIconColor,
                                                    )
                                                  : const FaIcon(
                                                      FontAwesomeIcons.backwardStep,
                                                      color: kIconColor,
                                                    ),
                                            );
                                          },
                                        ),
                                        ValueListenableBuilder<PlayButtonState>(
                                          valueListenable: playerManager.playButtonNotifier,
                                          builder: (_, value, __) {
                                            switch (value) {
                                              case PlayButtonState.loading:
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons.pause_circle,
                                                    color: kIconColor,
                                                  ),
                                                  iconSize: 80.0,
                                                  onPressed: () {
                                                    playerManager.pause();
                                                  },
                                                );

                                              case PlayButtonState.paused:
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons.play_circle,
                                                    color: kIconColor,
                                                  ),
                                                  iconSize: 80.0,
                                                  onPressed: () {
                                                    playerManager.play();
                                                  },
                                                );
                                              case PlayButtonState.playing:
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons.pause_circle,
                                                    color: kIconColor,
                                                  ),
                                                  iconSize: 80.0,
                                                  onPressed: () {
                                                    playerManager.pause();
                                                  },
                                                );
                                            }
                                          },
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: playerManager.isLastTrackNotifier,
                                          builder: (_, isLast, __) {
                                            return IconButton(
                                              onPressed: () {
                                                isLast ? null : playerManager.next();
                                              },
                                              icon: isLast
                                                  ? const FaIcon(
                                                      FontAwesomeIcons.forwardStep,
                                                      color: kIconColor,
                                                    )
                                                  : const FaIcon(
                                                      FontAwesomeIcons.forwardStep,
                                                      color: kIconColor,
                                                    ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: playerManager.isShuffleModeEnabledNotifier,
                                      builder: (context, isEnabled, child) {
                                        return IconButton(
                                          onPressed: () {
                                            playerManager.shuffle();
                                          },
                                          icon: isEnabled
                                              ? const FaIcon(
                                                  Icons.shuffle,
                                                  color: kIconColor,
                                                )
                                              : const FaIcon(Icons.shuffle,
                                                  color: kDisabledIconColor),
                                          iconSize: 30,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ValueListenableBuilder<ProgressBarState>(
                                    valueListenable: playerManager.progressBarNotifier,
                                    builder: (_, value, __) {
                                      return _buildProgressBar(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
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
      thumbColor: kProgressBarColor,
      thumbGlowColor: kThumbGlowColor,
      thumbGlowRadius: 30.0,
      progressBarColor: kProgressBarColor,
      bufferedBarColor: kBufferedBarColor,
      baseBarColor: kBaseBarColor,
      timeLabelLocation: TimeLabelLocation.below,
      timeLabelType: TimeLabelType.remainingTime,
      thumbCanPaintOutsideBar: true,
      timeLabelPadding: 5.0,
      onSeek: playerManager.seek,
      timeLabelTextStyle: const TextStyle(
        color: kTileAlbumColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
