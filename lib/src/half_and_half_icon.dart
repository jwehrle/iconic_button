import 'package:flutter/material.dart';
import 'package:iconic_button/src/style.dart';

/// An icon that displays in two colors for use with [HalfAndHalfColorButton]
class HalfAndHalfIcon extends StatelessWidget {
  
  /// A custom shader that makes an icon that is half one color and half another
  HalfAndHalfIcon({
    required this.iconData,
    required this.startColor,
    required this.endColor,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  /// The icon to shade
  final IconData iconData;

  /// The beginning half color
  final Color startColor;

  /// The ending half color
  final Color endColor;

  /// The alignment of the beginning half, defaulst to centerLeft
  final AlignmentGeometry begin;

  /// The alignment of the end half, defaults to centerRight
  final AlignmentGeometry end;


  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          stops: kHalfStops,
          colors: [startColor, startColor, startColor.withOpacity(0)],
          begin: begin,
          end: end,
        ).createShader(rect);
      },
      child: Icon(iconData, color: endColor),
    );
  }
}
