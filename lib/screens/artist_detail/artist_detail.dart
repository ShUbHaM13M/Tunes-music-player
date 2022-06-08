import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/utils/provider.dart';
import 'package:tunes/widgets/song_card.dart';

class ArtistDetailScreen extends ConsumerStatefulWidget {
  final ArtistModel artistModel;
  final List<SongModel> artistSongs;
  const ArtistDetailScreen({
    Key? key,
    required this.artistModel,
    required this.artistSongs,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ArtistDetailScreenState();
}

class ArtistDetailScreenState extends ConsumerState<ArtistDetailScreen> {
  @override
  initState() {
    super.initState();
  }

  onSongTap(WidgetRef ref, int id) async {
    int index = ref.watch(songListProvider).indexWhere((song) => song.id == id);

    await audioPlayer.seek(const Duration(milliseconds: 0), index: index);
    if (!audioPlayer.playing) {
      await audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 1,
        title: Text(widget.artistModel.artist),
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
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.artistModel.artist,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "number of albums : ${widget.artistModel.numberOfAlbums}",
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "number of tracks : ${widget.artistModel.numberOfTracks}",
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 150),
            sliver: SliverToBoxAdapter(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.artistSongs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SongCard(
                      songModel: widget.artistSongs[index],
                      onTap: () => onSongTap(ref, index),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
