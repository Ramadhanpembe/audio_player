import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../logics/player_query_resources.dart';
import '../utils/constants.dart';

class PlaylistDisplayIcon extends StatelessWidget {
  const PlaylistDisplayIcon({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: playlists[index].key,
      type: ArtworkType.PLAYLIST,
      nullArtworkWidget: const Icon(
        Icons.queue_music,
        size: 50.0,
        color: kIconColor,
      ),
    );
  }
}
