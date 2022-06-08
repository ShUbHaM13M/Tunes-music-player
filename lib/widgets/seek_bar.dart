import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tunes/utils/colors.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? currentValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 6.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SliderTheme(
              data: _sliderThemeData.copyWith(
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 3,
                  elevation: 0,
                  pressedElevation: 0,
                ),
                thumbColor: accentColor.withOpacity(0.8),
                activeTrackColor: accentColor.withOpacity(0.8),
                inactiveTrackColor: textColor.withOpacity(0.6),
                trackHeight: 4,
              ),
              child: ExcludeSemantics(
                child: Slider(
                  min: 0.0,
                  max: widget.duration.inMilliseconds.toDouble(),
                  value: widget.position.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    setState(() => currentValue = value);
                    if (widget.onChanged != null) {
                      widget.onChanged!(Duration(milliseconds: value.round()));
                    }
                  },
                  onChangeEnd: (value) {
                    if (widget.onChangeEnd != null) {
                      widget
                          .onChangeEnd!(Duration(milliseconds: value.round()));
                    }
                    currentValue = null;
                  },
                ),
              ),
            ),
            SliderTheme(
              data: _sliderThemeData.copyWith(
                inactiveTrackColor: Colors.transparent,
                trackHeight: 8.0,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 4.9,
                  elevation: 0,
                ),
              ),
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                    currentValue ?? widget.position.inMilliseconds.toDouble(),
                    widget.duration.inMilliseconds.toDouble()),
                onChanged: (value) {
                  setState(() => currentValue = value);
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  currentValue = null;
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("${widget.position}")
                        ?.group(1) ??
                    '${widget.position}',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white38,
                      fontSize: 14.0,
                    ),
              ),
              Text(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("${widget.duration}")
                        ?.group(1) ??
                    '${widget.duration}',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white38,
                      fontSize: 14.0,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}
