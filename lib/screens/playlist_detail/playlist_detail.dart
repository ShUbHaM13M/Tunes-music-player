import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/utils/provider.dart';
import 'package:tunes/widgets/song_card.dart';

class PlaylistDetailScreen extends ConsumerStatefulWidget {
  final PlaylistModel playlistModel;
  const PlaylistDetailScreen({
    Key? key,
    required this.playlistModel,
  }) : super(key: key);

  @override
  ConsumerState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends ConsumerState<PlaylistDetailScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() async {
    var playlistSongs = await _audioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST, widget.playlistModel.id);

    var _songs = await _audioQuery.querySongs();
    List<SongModel> filteredSongs = [];
    for (var song in playlistSongs) {
      filteredSongs
          .add(_songs.firstWhere((element) => element.title == song.title));
    }
    setState(() => songs = filteredSongs);
  }

  playAll() async {
    loadSongs(songs);
    await audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 1,
        title: Text(widget.playlistModel.playlist),
        actions: const [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: primaryDark.withOpacity(0.4),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.playlistModel.playlist,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "number of songs : ${widget.playlistModel.numOfSongs}",
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Play all",
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
                GestureDetector(
                  onTap: playAll,
                  child: const Icon(Icons.play_circle,
                      color: accentColor, size: 28),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 150),
                itemCount: songs.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SongCard(
                    songModel: songs[index],
                    onTap: () {},
                  );
                }),
          ),
        ],
      ),
    );
  }
}
