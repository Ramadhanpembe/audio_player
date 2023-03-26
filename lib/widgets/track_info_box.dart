import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../utils/constants.dart';

class TrackInfoBox extends StatelessWidget {
  const TrackInfoBox({super.key, required this.context, required this.track});
  final BuildContext context;
  final SongModel track;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Text(
                'Title:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                track.title,
                style: kInfoDialogItemDetailStyle,
              ),
            ),
            ListTile(
              leading: const Text(
                'Album:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                track.album ?? '<unknown>',
                style: kInfoDialogItemDetailStyle,
              ),
            ),
            ListTile(
              leading: const Text(
                'Artist:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                track.artist ?? '<unknown>',
                style: kInfoDialogItemDetailStyle,
              ),
            ),
            ListTile(
              leading: const Text(
                'Genre:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                track.genre ?? '<unknown>',
                style: kInfoDialogItemDetailStyle,
              ),
            ),
            ListTile(
              leading: const Text(
                'Size:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                '${_megabytesFromBytes(track.size)} MB',
                style: kInfoDialogItemDetailStyle,
              ),
            ),
            ListTile(
              leading: const Text(
                'Extension:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                _trackExtension(track.displayName),
                style: kInfoDialogItemDetailStyle,
              ),
            ),
            ListTile(
              leading: const Text(
                'Duration:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                _durationFormatter(track.duration ?? 0),
                style: kInfoDialogItemDetailStyle,
              ),
            ),
            ListTile(
              leading: const Text(
                'Date Added:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                _dateFromTimestamp(track.dateAdded ?? 0).toString(),
                style: kInfoDialogItemDetailStyle,
              ),
            ),
            ListTile(
              leading: const Text(
                'Date Modified:',
                style: kInfoDialogItemTitleStyle,
              ),
              title: Text(
                _dateFromTimestamp(track.dateModified ?? 0).toString(),
                style: kInfoDialogItemDetailStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateFromTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(dateTime);
  }

  String _megabytesFromBytes(int bytes) {
    return (bytes / 1000000).toStringAsFixed(2);
  }

  String _trackExtension(String name) {
    int periodIndex = name.indexOf('.');
    return name.substring(periodIndex);
  }

  String _durationFormatter(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    String formatDuration(int n) => n.toString().padLeft(2, '0');
    String minutes = formatDuration(duration.inMinutes.remainder(60));
    String seconds = formatDuration(duration.inSeconds.remainder(60));
    return '${formatDuration(duration.inHours)}:$minutes:$seconds';
  }
}
