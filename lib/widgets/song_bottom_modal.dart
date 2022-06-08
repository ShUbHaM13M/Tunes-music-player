import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tunes/utils/provider.dart';
import 'package:tunes/widgets/widgets.dart';

class SongBottomModal extends StatelessWidget {
  const SongBottomModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Glass(
      start: 0.03,
      end: 0.08,
      backgroundColor: Colors.black87,
      blurAmount: 12,
      padding: const EdgeInsets.only(top: 34.0),
      border: true,
      child: FractionallySizedBox(
        heightFactor: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    IndexedAudioSource? song = snapshot.data?.currentSource;
                    return Column(
                      children: [
                        SongArtWork(
                          songId: int.parse(song?.tag.id),
                          size: MediaQuery.of(context).size.width * 0.84,
                          marginRight: 0,
                          notFoundIconSize: 60,
                          borderRadius: BorderRadius.circular(2.0),
                          artworkQuality: FilterQuality.medium,
                          artworkScale: 2,
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextScroll(
                                song?.tag.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                velocity: const Velocity(
                                    pixelsPerSecond: Offset(20, 0)),
                                delayBefore: const Duration(milliseconds: 800),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                song?.tag.artist ?? "<Unknown>",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<Duration>(
                    stream: audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      if (snapshot.hasData) {
                        return SeekBar(
                          duration: audioPlayer.duration ?? Duration.zero,
                          position: positionData ?? Duration.zero,
                          onChangeEnd: (newPosition) =>
                              audioPlayer.seek(newPosition),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),
                  buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildActions() {
  const double _iconSize = 22;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ShuffleButton(),
        IconButton(
          onPressed: () {
            audioPlayer.seekToPrevious();
            if (!audioPlayer.playing) audioPlayer.play();
          },
          icon: SvgPicture.asset(
            'assets/icons/skip-previous.svg',
            height: _iconSize,
            width: _iconSize,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          child: const PlayButton(),
        ),
        IconButton(
          onPressed: () {
            audioPlayer.seekToNext();
            if (!audioPlayer.playing) audioPlayer.play();
          },
          icon: SvgPicture.asset(
            'assets/icons/skip-next.svg',
            height: _iconSize,
            width: _iconSize,
          ),
        ),
        const LoopButton(),
      ],
    ),
  );
}
