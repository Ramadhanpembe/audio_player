import 'package:rxdart/rxdart.dart';

import '../models/duration_streams.dart';
import 'audio_data_models.dart' as am;

Stream<DurationStreams> get durationStreams {
  return Rx.combineLatest3<Duration, Duration?, Duration?, DurationStreams>(
      am.audioPlayer.positionStream,
      am.audioPlayer.durationStream,
      am.audioPlayer.bufferedPositionStream, (position, duration, buffer) {
    return DurationStreams(
        position: position,
        duration: duration ?? Duration.zero,
        buffer: buffer ?? Duration.zero);
  });
}
//
// void checkLoopMode() {
//   final loopMode = am.audioPlayer.loopMode;
//   if (loopMode == LoopMode.all) {
//     am.audioPlayer.setLoopMode(LoopMode.one);
//   } else if (loopMode == LoopMode.one) {
//     am.audioPlayer.setLoopMode(LoopMode.off);
//   } else {
//     am.audioPlayer.setLoopMode(LoopMode.all);
//   }
// }
//
// SongModel get currentTrack {
//   return _currentTrack;
// }
//
// SongModel get nextTrack {
//   return am.tracks[am.audioPlayer.nextIndex == null ? -0 : 1];
// }
//
// loopAllTracks() async {
//   if (am.audioPlayer.hasNext) {
//     await am.audioPlayer.seekToNext();
//   }
// }
//
// Icon loopTracks(BuildContext context, AsyncSnapshot snapshot) {
//   final loopMode = snapshot.data;
//   final shuffle = am.audioPlayer.shuffleModeEnabled;
//   if (loopMode == LoopMode.all && !shuffle) {
//     if (am.audioPlayer.hasNext) {
//       am.audioPlayer.seekToNext();
//       _currentTrack = nextTrack;
//     }
//     return const Icon(Icons.repeat);
//   } else if (loopMode == LoopMode.one && !shuffle) {
//     return const Icon(Icons.repeat_one);
//   } else {
//     am.audioPlayer.shuffle();
//     _currentTrack = nextTrack;
//     return const Icon(Icons.shuffle);
//   }
// }
