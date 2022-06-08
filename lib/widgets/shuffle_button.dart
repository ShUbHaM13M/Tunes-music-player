import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/utils/provider.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: audioPlayer.shuffleModeEnabledStream,
      builder: (context, snapshot) {
        bool enabled = snapshot.data ?? false;
        return IconButton(
          onPressed: () => audioPlayer
              .setShuffleModeEnabled(!audioPlayer.shuffleModeEnabled),
          icon: SvgPicture.asset(
            "assets/icons/shuffle.svg",
            color: enabled ? accentColor : Colors.white70,
            width: _size,
            height: _size,
          ),
          iconSize: _size,
        );
      },
    );
  }
}
