import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/widgets/widgets.dart';

class ArtistTab extends StatefulWidget {
  const ArtistTab({Key? key}) : super(key: key);

  @override
  ArtistTabState createState() => ArtistTabState();
}

class ArtistTabState extends State<ArtistTab> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<ArtistModel> artists = [];

  @override
  void initState() {
    super.initState();
    getArtists();
  }

  getArtists() async {
    var _artists = await _audioQuery.queryArtists();
    setState(() => artists = _artists);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: artists.isNotEmpty
          ? ListView.builder(
              itemCount: artists.length,
              padding: const EdgeInsets.only(bottom: 150),
              itemBuilder: ((context, index) {
                return ArtistCell(artistModel: artists[index]);
              }),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
