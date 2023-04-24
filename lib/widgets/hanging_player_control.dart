import 'package:audio_player/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../main.dart';
import '../notifiers/play_button_notifier.dart';
import '../screens/player_screen.dart';

class HangingPlayerControl extends StatelessWidget {
  const HangingPlayerControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      height: 64.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const PlayerScreen())),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ValueListenableBuilder(
                valueListenable: playerManager.currentTrackIDNotifier,
                builder: (_, index, __) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 25.0,
                          child: QueryArtworkWidget(
                            id: index,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Image.asset(
                              'images/player_image.png',
                              height: 40,
                              width: 40,
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.contain,
                              color: kBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ValueListenableBuilder(
                            valueListenable: playerManager.currentTrackTitleNotifier,
                            builder: (_, title, __) {
                              return SizedBox(
                                height: 60.0,
                                child: Marquee(
                                  text: title,
                                  style: const TextStyle(
                                    color: kBackgroundColor,
                                    fontSize: 16.0,
                                  ),
                                  blankSpace: title.characters.length >= 20 ? 15.0 : 30.0,
                                  velocity: title.characters.length >= 20 ? 60.0 : 40.0,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: playerManager.isFirstTrackNotifier,
            builder: (_, isFirst, __) {
              return IconButton(
                color: kBackgroundColor,
                onPressed: () {
                  isFirst ? null : playerManager.previous();
                },
                icon: isFirst
                    ? const FaIcon(FontAwesomeIcons.backwardStep)
                    : const FaIcon(FontAwesomeIcons.backwardStep),
              );
            },
          ),
          ValueListenableBuilder<PlayButtonState>(
            valueListenable: playerManager.playButtonNotifier,
            builder: (_, value, __) {
              switch (value) {
                case PlayButtonState.loading:
                  return IconButton(
                    color: kBackgroundColor,
                    icon: const Icon(Icons.pause),
                    iconSize: 35.0,
                    onPressed: () {
                      playerManager.pause();
                    },
                  );

                case PlayButtonState.paused:
                  return IconButton(
                    color: kBackgroundColor,
                    icon: const Icon(Icons.play_arrow_rounded),
                    iconSize: 35.0,
                    onPressed: () {
                      playerManager.play();
                    },
                  );
                case PlayButtonState.playing:
                  return IconButton(
                    color: kBackgroundColor,
                    icon: const Icon(Icons.pause),
                    iconSize: 35.0,
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
                color: kBackgroundColor,
                onPressed: () {
                  isLast ? null : playerManager.next();
                },
                icon: isLast
                    ? const FaIcon(FontAwesomeIcons.forwardStep)
                    : const FaIcon(FontAwesomeIcons.forwardStep),
              );
            },
          ),
        ],
      ),
    );
  }
}
