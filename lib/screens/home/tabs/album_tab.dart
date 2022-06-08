import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/widgets/widgets.dart';

class AlbumTab extends StatefulWidget {
  const AlbumTab({Key? key}) : super(key: key);

  @override
  AlbumTabState createState() => AlbumTabState();
}

class AlbumTabState extends State {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<AlbumModel> albums = [];

  @override
  void initState() {
    super.initState();
    getAlbums();
  }

  getAlbums() async {
    var _albums = await _audioQuery.queryAlbums();
    setState(() => albums = _albums);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: albums.isNotEmpty
          ? ListView.builder(
              addAutomaticKeepAlives: true,
              itemCount: albums.length,
              padding: const EdgeInsets.only(bottom: 150),
              itemBuilder: ((context, index) {
                return AlbumCell(albumModel: albums[index]);
              }),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
