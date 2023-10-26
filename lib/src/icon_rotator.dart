import 'package:flutter/material.dart';
import 'package:iconic_button/src/style.dart';

/// Wrapper for [AnimatedRotation] to rotate [icon] based on selection state.
class IconRotator extends StatelessWidget {

  /// Creates a widget that rotates an [icon] based on [isSelected]
  const IconRotator({
    Key? key,
    required this.icon,
    required this.isSelected,
    this.duration,
    this.turnSelected = kTurnSelected,
    this.turnUnselected = kTurnUnselected,
  }) : super(key: key);

  /// The icon to be rotated
  final IconData icon;

  /// The state of this widget
  final bool isSelected;

  /// The duration of the rotation
  final Duration? duration;

  /// The number of turns to make when selected, defaults to 0.5
  final double turnSelected;

  /// The number of turns to make when unselected, defaults to 0.0
  final double turnUnselected;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(Theme.of(context).iconTheme.size ?? 24.0),
      child: AnimatedRotation(
        turns: isSelected ? turnSelected : turnUnselected,
        duration: duration ?? kThemeAnimationDuration,
        child: Icon(icon),
      ),
    );
  }
}
