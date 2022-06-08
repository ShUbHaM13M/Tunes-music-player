import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/screens/album_detail/album_detail.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/widgets/song_artwork.dart';

class AlbumCell extends StatefulWidget {
  final AlbumModel albumModel;
  const AlbumCell({Key? key, required this.albumModel}) : super(key: key);

  @override
  State<AlbumCell> createState() => _AlbumCellState();
}

class _AlbumCellState extends State<AlbumCell> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() async {
    var songs = await _audioQuery.queryAudiosFrom(
        AudiosFromType.ALBUM_ID, widget.albumModel.id);
    setState(() => _songs = songs);
  }

  String getAlbumDescription() {
    String albumDescription = widget.albumModel.artist ?? 'Unknown';
    var minYear = widget.albumModel.getMap['minyear'];
    var maxYear = widget.albumModel.getMap['maxyear'];
    if (widget.albumModel.getMap['minyear'] != null ||
        widget.albumModel.getMap['maxyear'] != null) {
      albumDescription += " - ${minYear ?? maxYear}";
    }
    return albumDescription;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailsScreen(
                albumModel: widget.albumModel, albumSongs: _songs),
          ),
        );
      },
      child: DefaultTextStyle(
        style: const TextStyle(
          color: textColor,
          fontSize: 18,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                height: 60,
                width: 60,
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SongArtWork(
                      songId: _songs.isNotEmpty ? _songs.first.id : 0,
                      size: 50,
                      marginRight: 0,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.albumModel.album,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      getAlbumDescription(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                widget.albumModel.numOfSongs.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
