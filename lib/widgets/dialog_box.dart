import 'package:flutter/material.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/widgets/glass.dart';

class DialogBox extends StatelessWidget {
  final String title;
  final Widget? child;
  const DialogBox({
    Key? key,
    required this.title,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      contentTextStyle: const TextStyle(
        color: Colors.white,
      ),
      title: Text(title),
      content: Glass(
        start: 0.12,
        end: 0.12,
        backgroundColor: Colors.grey.shade400,
        blurAmount: 10,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 280,
          decoration: BoxDecoration(
            border: Border.all(
              color: textColor.withOpacity(0.05),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: child,
        ),
      ),
    );
  }
}
