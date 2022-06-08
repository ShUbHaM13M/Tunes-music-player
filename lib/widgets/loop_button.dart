import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/utils/provider.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({Key? key}) : super(key: key);
  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoopMode>(
      stream: audioPlayer.loopModeStream,
      builder: (context, snapshot) {
        final currentMode = snapshot.data;
        return IconButton(
          onPressed: () {
            switch (audioPlayer.loopMode) {
              case LoopMode.off:
                audioPlayer.setLoopMode(LoopMode.all);
                break;
              case LoopMode.all:
                audioPlayer.setLoopMode(LoopMode.one);
                break;
              case LoopMode.one:
                audioPlayer.setLoopMode(LoopMode.off);
                break;
              default:
                break;
            }
          },
          icon: (() {
            if (currentMode == LoopMode.one) {
              return SvgPicture.asset(
                'assets/icons/loop-one.svg',
                color: accentColor,
                height: _size,
                width: _size,
              );
            }
            return SvgPicture.asset(
              'assets/icons/loop.svg',
              color: currentMode == LoopMode.all ? accentColor : Colors.white70,
              width: _size,
              height: _size,
            );
          })(),
          iconSize: _size,
        );
      },
    );
  }
}
