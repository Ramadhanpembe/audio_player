import 'package:audio_player/logics/player_query_resources.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../utils/constants.dart';

class AlbumDisplayIcon extends StatelessWidget {
  const AlbumDisplayIcon({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: albums[index].id,
      type: ArtworkType.PLAYLIST,
      nullArtworkWidget: const Icon(
        Icons.album,
        size: 50.0,
        color: kIconColor,
      ),
    );
  }
}
