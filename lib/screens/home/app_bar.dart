import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tunes/utils/utils.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: primaryDark,
      title: Row(
        children: [
          SvgPicture.asset("assets/icons/tunes-logo.svg"),
          const Text("Tunes"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
