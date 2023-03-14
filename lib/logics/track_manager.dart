import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../screens/player_screen.dart';
import 'audio_data_models.dart' as am;

// bool isLooped = true;
void onTrackTap(BuildContext context, int index) async {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlayerScreen(trackIndex: index)));
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

/// This is a concatenating AudioSource which is not working in my case but will later be needed - DO NOT DELETE THIS
setConcatenatingAudioSource(int index) async {
  await am.audioPlayer.setAudioSource(
    ConcatenatingAudioSource(
      shuffleOrder: DefaultShuffleOrder(),
      useLazyPreparation: true,

      /// check to see if the list of a single source works - DOES NOT WORK
      children: _audioSources,
    ),
    initialIndex: index,
    preload: false,
  );
}

List<AudioSource> addAudioSources(int index) {
  // available list
  List<AudioSource> al = _audioSources;

  // required list
  List<AudioSource> rl = [];

  for (var i = 0; i < al.length; i++) {
    if (i == index) continue;
    rl.add(al[i]);
  }

  return rl;
}

// Future<void> checking(int index) async {
//   ConcatenatingAudioSource src = ConcatenatingAudioSource(
//     children: _audioSources
//   );
//   src.add(_audioSources[index]);
//   await am.audioPlayer.setAudioSource(src);
// }

void requestPermission() async {
  if (!kIsWeb) {
    bool status = await am.audioQuery.permissionsStatus();
    if (!status) {
      await am.audioQuery.permissionsRequest();
    }
  }
}
