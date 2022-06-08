import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

final audioPlayer = AudioPlayer();

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final _songs = ref.watch(songListProvider);
  if (_songs.isEmpty) {
    return audioPlayer;
  }

  return audioPlayer;
});

final songListProvider = StateProvider<List<SongModel>>((ref) => []);

loadSongs(List<SongModel> songs) async {
  await audioPlayer.setAudioSource(
    ConcatenatingAudioSource(
      children: songs
          .map(
            (song) => AudioSource.uri(
              Uri.parse(song.uri ?? ''),
              tag: MediaItem(
                id: song.id.toString(),
                title: song.title,
                album: song.album,
                artist: song.artist,
                genre: song.genre,
                displayTitle: song.displayName,
                duration: Duration(milliseconds: song.duration ?? 0),
              ),
            ),
          )
          .toList(),
    ),
  );
}
