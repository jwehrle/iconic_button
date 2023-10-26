import 'package:flutter/material.dart';
import 'package:iconic_button/src/style.dart';

/// Encapsulation of selected and unselected icons for use in either leading
/// or trailing sections of a ListTile. Unselected can be null, in which case
/// the CardChip transitions between no icon and the selected icon based on
/// selection state.
class SwitchIcons {
  /// Creates a dedicated tuple for switches with icons
  SwitchIcons({this.unSelected, required this.selected});

  /// The icon for selected states
  final IconData selected;

  /// The optional icon for unselected states
  final IconData? unSelected;
}

/// Wrapper for [AnimatedSwitcher] to switch between icons in [SwitchIcons]
/// based on selection state.
class IconSwitcher extends StatelessWidget {
  /// Creates a widget that switches between icons in [SwitchIcons]
  /// based on selection state.
  const IconSwitcher({
    Key? key,
    required this.switchIcons,
    required this.isSelected,
    this.duration,
    this.iconSize,
  }) : super(key: key);

  /// The icons that toggle between selected and unselected
  final SwitchIcons switchIcons;

  /// The state of this switcher
  final bool isSelected;

  /// The duration of the animated transition between states
  final Duration? duration;

  /// The size of the icons, defaults to theme, then 24.0
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final selIcon = Icon(
      switchIcons.selected,
      key: ValueKey('selected_icon'),
    );
    final unSelIcon = Icon(
      switchIcons.unSelected,
      key: ValueKey('unselected_icon'),
    );
    return SizedBox.fromSize(
      size: Size.square(iconSize ?? Theme.of(context).iconTheme.size ?? kDefaultIconSize),
      child: AnimatedSwitcher(
        duration: duration ?? kThemeAnimationDuration,
        child: isSelected ? selIcon : unSelIcon,
      ),
    );
  }
}
