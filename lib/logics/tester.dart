import 'package:flutter/material.dart';

final currentSongTitleNotifier = ValueNotifier<String>('');
final playlistNotifier = ValueNotifier<List<String>>([]);
// final progressNotifier = ProgressNotifier();
// final repeatButtonNotifier = RepeatButtonNotifier();
final isFirstSongNotifier = ValueNotifier<bool>(true);
// final playButtonNotifier = PlayButtonNotifier();
final isLastSongNotifier = ValueNotifier<bool>(true);
final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
