import 'package:flutter/material.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/utils/provider.dart';

class PlayButton extends StatefulWidget {
  final double iconSize;
  final Color color;
  const PlayButton({
    Key? key,
    this.iconSize = 32,
    this.color = accentColor,
  }) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        _controller.forward();
        return;
      }
      _controller.reverse();
    });
  }

  onTap() {
    if (audioPlayer.playerState.playing) {
      audioPlayer.pause();
      return;
    }
    audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widget.iconSize * 2,
        height: widget.iconSize * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ),
        alignment: Alignment.center,
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animation,
          semanticLabel: 'Toggle play',
          size: widget.iconSize * 1.2,
          color: Colors.white,
        ),
      ),
    );
  }
}
