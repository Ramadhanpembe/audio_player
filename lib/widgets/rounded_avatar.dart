import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../utils/constants.dart';

class RoundedAvatar extends StatelessWidget {
  const RoundedAvatar(
      {super.key,
      required this.models,
      required this.index,
      this.isClicked = false,
      this.currentIndex});
  final List<dynamic> models;
  final int index;
  final bool? isClicked;
  final int? currentIndex;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: kCircleAvatarColor,
      radius: 26.0,
      child: QueryArtworkWidget(
        id: models[index].id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          'images/musical_notes.png',
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          color: isClicked! && index == currentIndex ? kNowPlayingMusicIconColor : kMusicIconColor,
        ),
      ),
    );
  }
}
