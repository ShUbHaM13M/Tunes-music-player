import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tunes/utils/utils.dart';
import 'package:tunes/widgets/current_song.dart';
import 'package:tunes/widgets/custom_bottom_bar.dart';
import 'package:tunes/widgets/glass.dart';

class HomeScreenBottom extends ConsumerStatefulWidget {
  final TabController controller;
  const HomeScreenBottom({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreenBottom> {
  @override
  Widget build(BuildContext context) {
    return Glass(
      start: 0.03,
      end: 0.08,
      backgroundColor: Colors.black87,
      blurAmount: 10,
      border: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CurrentSong(),
            CustomBottomBar(
              backgroundColor: primaryDark,
              controller: widget.controller,
              items: [
                CustomBottombarItem(
                  icon: const Icon(Icons.audiotrack_rounded),
                  title: "Songs",
                ),
                CustomBottombarItem(
                  icon: const Icon(Icons.album_rounded),
                  title: "Albums",
                ),
                CustomBottombarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/artist-icon.svg",
                    color: accentColor,
                    height: 24,
                    width: 24,
                  ),
                  title: "Artists",
                ),
                CustomBottombarItem(
                  icon: const Icon(Icons.settings),
                  title: "Settings",
                ),
              ],
              onItemSelected: (index) => widget.controller.animateTo(index),
            ),
          ],
        ),
      ),
    );
  }
}
