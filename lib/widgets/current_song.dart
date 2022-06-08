import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tunes/utils/utils.dart';
import 'package:tunes/widgets/widgets.dart';

class CurrentSong extends StatelessWidget {
  static const double _iconSize = 24;
  const CurrentSong({
    Key? key,
  }) : super(key: key);

  Widget _playerButton(PlayerState? playerState) {
    final processingState = playerState?.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return const SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(),
      );
    } else if (audioPlayer.playing != true) {
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: audioPlayer.play,
        color: Colors.white,
        iconSize: _iconSize,
        splashRadius: 26.0,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: const Icon(Icons.pause),
        iconSize: _iconSize,
        onPressed: audioPlayer.pause,
        color: Colors.white,
        splashRadius: 26.0,
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.replay),
        iconSize: _iconSize,
        color: Colors.white,
        onPressed: () => audioPlayer.seek(Duration.zero,
            index: audioPlayer.effectiveIndices?.first),
        splashRadius: 26.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) => const SongBottomModal(),
        ),
        child: Column(
          children: [
            StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    IndexedAudioSource? song = snapshot.data?.currentSource;
                    return Row(
                      children: [
                        SongArtWork(
                          songId: int.parse(song?.tag.id),
                          size: 48,
                          marginRight: 8,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextScroll(
                                  song?.tag.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(20, 0)),
                                  delayBefore:
                                      const Duration(milliseconds: 500),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  song?.tag.artist ?? "<Unknown>",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<PlayerState>(
                          stream: audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            return _playerButton(playerState);
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            await audioPlayer.seekToNext();
                          },
                          splashRadius: 26.0,
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: _iconSize,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
            StreamBuilder<Duration>(
                stream: audioPlayer.positionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double total =
                        audioPlayer.duration?.inMilliseconds.toDouble() ?? 1;
                    double value =
                        (snapshot.data!.inMilliseconds.toDouble() / total);
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.only(top: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: LinearProgressIndicator(
                        value: value,
                        color: accentColor,
                        backgroundColor: textColor.withOpacity(0.18),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
          ],
        ),
      ),
    );
  }
}
