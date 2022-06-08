import "package:flutter/material.dart";
import 'package:on_audio_query/on_audio_query.dart';

class SongArtWork extends StatelessWidget {
  final int songId;
  final double size;
  final double marginRight;
  final double notFoundIconSize;
  final BorderRadius borderRadius;
  final double artworkScale;
  final FilterQuality artworkQuality;
  const SongArtWork({
    Key? key,
    required this.songId,
    required this.size,
    this.marginRight = 16,
    this.notFoundIconSize = 32,
    this.borderRadius = BorderRadius.zero,
    this.artworkScale = 1,
    this.artworkQuality = FilterQuality.low,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: marginRight),
      child: QueryArtworkWidget(
        id: songId,
        type: ArtworkType.AUDIO,
        artworkHeight: size,
        artworkWidth: size,
        artworkScale: artworkScale,
        artworkBorder: borderRadius,
        artworkQuality: artworkQuality,
        size: artworkQuality != FilterQuality.low ? size.toInt() : null,
        nullArtworkWidget: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: borderRadius,
          ),
          child: Icon(
            Icons.image_not_supported_rounded,
            color: Colors.black,
            size: notFoundIconSize,
          ),
        ),
      ),
    );
  }
}
