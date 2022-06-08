import 'dart:ui';

import 'package:flutter/material.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final bool? border;
  final double blurAmount;
  final Color backgroundColor;

  const Glass({
    Key? key,
    required this.child,
    required this.start,
    required this.end,
    this.blurAmount = 14,
    this.borderRadius = BorderRadius.zero,
    this.padding = EdgeInsets.zero,
    this.border,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: border != null
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.4),
                  Colors.transparent,
                ],
                stops: const [0.005, 0.005],
              )
            : null,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                backgroundColor.withOpacity(start),
                backgroundColor.withOpacity(end),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
