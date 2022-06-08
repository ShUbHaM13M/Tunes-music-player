import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/utils/provider.dart';
import 'package:tunes/widgets/widgets.dart';

//? TODO: Making a song details card with song info and shortcut to add to a playlist

Widget _buildSongInfoText(String name, String iconPath) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        SvgPicture.asset('assets/icons/$iconPath'),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(color: textColor, fontSize: 18.0),
          ),
        ),
      ],
    ),
  );
}

class SongCard extends StatelessWidget {
  final SongModel songModel;
  final Function onTap;
  const SongCard({
    Key? key,
    required this.songModel,
    required this.onTap,
  }) : super(key: key);

  Future showModal(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 4,
        context: context,
        builder: (context) {
          return Glass(
            start: 0.03,
            end: 0.08,
            blurAmount: 10,
            backgroundColor: Colors.grey[850]!,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            border: true,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.horizontal_rule_rounded,
                    color: textColor.withOpacity(0.2),
                    size: 32,
                  ),
                  _buildSongInfoText(songModel.artist ?? '', 'album.svg'),
                  _buildSongInfoText(songModel.album ?? '', 'album.svg'),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => {HapticFeedback.vibrate(), showModal(context)},
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SongArtWork(
              songId: songModel.id,
              size: 50,
              marginRight: 12,
              borderRadius: BorderRadius.circular(2),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songModel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      songModel.artist ?? "<Unknown>",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    IndexedAudioSource? song = snapshot.data?.currentSource;
                    if (int.parse(song?.tag.id) == songModel.id) {
                      return const Wave();
                    }
                  }
                  return const SizedBox.shrink();
                })),
          ],
        ),
      ),
    );
  }
}

class Wave extends StatelessWidget {
  const Wave({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      height: 32,
      width: 32,
      child: StreamBuilder<bool>(
        stream: audioPlayer.playingStream,
        builder: (context, snapshot) {
          final bool playing = snapshot.data ?? false;
          if (playing) {
            return Image.asset("assets/icons/wave_animation.gif");
          }
          return SvgPicture.asset("assets/icons/wave.svg");
        },
      ),
    );
  }
}
