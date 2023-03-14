import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../screens/player_screen.dart';
import 'audio_data_models.dart' as am;

void onTrackTap(BuildContext context, int index) async {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const PlayerScreen()));
  await _setAudioSource(index);
  await am.audioPlayer.play();
}

List<AudioSource> get _audioSources {
  List<AudioSource> audioSources = [];
  for (var track in am.tracks) {
    audioSources.add(AudioSource.uri(Uri.parse(track.uri!)));
  }
  return audioSources;
}

Future<void> _setAudioSource(int index) async {
  await am.audioPlayer.setAudioSource(_audioSources[index]);
}

setConcatenatingAudioSource(int index) async {
  await am.audioPlayer.setAudioSource(
    ConcatenatingAudioSource(
      shuffleOrder: DefaultShuffleOrder(),
      useLazyPreparation: true,
      children: _audioSources,
    ),
    initialIndex: index,
  );
}

void requestPermission() async {
  if (!kIsWeb) {
    bool status = await am.audioQuery.permissionsStatus();
    if (!status) {
      await am.audioQuery.permissionsRequest();
    }
  }
}
