import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tunes/utils/provider.dart';
import 'package:tunes/widgets/widgets.dart';

class SongTab extends ConsumerStatefulWidget {
  const SongTab({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SongTabState();
}

class SongTabState extends ConsumerState<SongTab> {
  onSongCardTap(int index) async {
    await audioPlayer.seek(const Duration(milliseconds: 0), index: index);
    if (!audioPlayer.playing) {
      await audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _songs = ref.watch(songListProvider);

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Quote(),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 150),
          sliver: _songs.isNotEmpty
              ? SliverToBoxAdapter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _songs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => SongCard(
                      songModel: _songs[index],
                      onTap: () => onSongCardTap(index),
                    ),
                  ),
                )
              : const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ],
    );
  }
}
