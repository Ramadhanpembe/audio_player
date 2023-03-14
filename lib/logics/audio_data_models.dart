import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

final OnAudioQuery audioQuery = OnAudioQuery();

// plays audio files
final AudioPlayer audioPlayer = AudioPlayer();

// stores songs from the data fetched in the storage
List<SongModel> tracks = <SongModel>[];
