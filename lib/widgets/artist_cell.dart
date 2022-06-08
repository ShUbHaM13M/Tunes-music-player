import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/screens/artist_detail/artist_detail.dart';
import 'package:tunes/utils/colors.dart';

class ArtistCell extends StatefulWidget {
  final ArtistModel artistModel;
  const ArtistCell({Key? key, required this.artistModel}) : super(key: key);

  @override
  State<ArtistCell> createState() => _ArtistCellState();
}

class _ArtistCellState extends State<ArtistCell> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() async {
    var songs = await _audioQuery.queryAudiosFrom(
        AudiosFromType.ARTIST_ID, widget.artistModel.id);
    setState(() => _songs = songs);
  }

  String getArtistDescription() {
    String albumDescription = widget.artistModel.artist;
    var minYear = widget.artistModel.getMap['minyear'];
    var maxYear = widget.artistModel.getMap['maxyear'];
    if (widget.artistModel.getMap['minyear'] != null ||
        widget.artistModel.getMap['maxyear'] != null) {
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
            builder: (context) => ArtistDetailScreen(
              artistModel: widget.artistModel,
              artistSongs: _songs,
            ),
          ),
        );
      },
      child: DefaultTextStyle(
        style: const TextStyle(
          color: textColor,
          fontSize: 18,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.artistModel.artist,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: textColor.withOpacity(0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
