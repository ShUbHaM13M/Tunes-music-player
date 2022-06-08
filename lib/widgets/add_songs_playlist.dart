import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/utils/provider.dart';

class AddSongsPage extends ConsumerStatefulWidget {
  final int playlistId;

  const AddSongsPage({
    Key? key,
    required this.playlistId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddSongsPageState();
}

class AddSongsPageState extends ConsumerState<AddSongsPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<String> _playlistSongs = [];

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() async {
    var playlistSongs = await _audioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST, widget.playlistId);
    var songTitles = playlistSongs.map((song) => song.title).toList();
    setState(() => _playlistSongs = songTitles);
  }

  onSongCardClicked(int songId, String songTitle) async {
    if (_playlistSongs.contains(songTitle)) {
      await _audioQuery.removeFromPlaylist(widget.playlistId, songId);
    } else {
      await _audioQuery.addToPlaylist(widget.playlistId, songId);
    }
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songListProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryDark,
        title: const Text("Add songs"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        itemCount: songs.length,
        itemExtent: 56.0,
        itemBuilder: (context, index) {
          var song = songs[index];
          return _Card(
            song: song,
            onClick: onSongCardClicked,
            isInPlaylist: _playlistSongs.contains(song.title),
          );
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final SongModel song;
  final Function(int, String) onClick;
  final bool isInPlaylist;
  const _Card({
    Key? key,
    required this.song,
    required this.onClick,
    this.isInPlaylist = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    song.artist ?? "Unknown",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14.0,
                      color: textColor.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onClick(song.id, song.title),
              icon: Icon(
                isInPlaylist ? Icons.close : Icons.add,
                color: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
