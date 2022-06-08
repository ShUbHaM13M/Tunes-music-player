import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/utils/provider.dart';
import 'package:tunes/widgets/song_card.dart';

class AlbumDetailsScreen extends ConsumerStatefulWidget {
  final AlbumModel albumModel;
  final List<SongModel> albumSongs;
  static final OnAudioQuery audioQuery = OnAudioQuery();
  const AlbumDetailsScreen({
    Key? key,
    required this.albumModel,
    required this.albumSongs,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AlbumDetailScreenState();
}

class AlbumDetailScreenState extends ConsumerState<AlbumDetailsScreen> {
  onSongTap(WidgetRef ref, int id) async {
    int index = ref.watch(songListProvider).indexWhere((song) => song.id == id);

    await audioPlayer.seek(const Duration(milliseconds: 0), index: index);
    if (!audioPlayer.playing) {
      await audioPlayer.play();
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 1,
        title: Text(widget.albumModel.album),
      ),
      backgroundColor: primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: primaryDark.withOpacity(0.4),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.albumModel.album,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          getAlbumDescription(),
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
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 150),
            sliver: SliverToBoxAdapter(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.albumSongs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SongCard(
                      songModel: widget.albumSongs[index],
                      onTap: () => onSongTap(ref, widget.albumSongs[index].id),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
