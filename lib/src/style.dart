import 'package:flutter/material.dart';

/// Utility Functions and Classes for ButtonStyles and MaterialStateProperties
/// based on Material Theme guidelines.
const int kBackgroundAlpha = 0x1f; // 12%
const int kSelectAlpha = 0x3d; // 12% + 12% = 24%
const double kDefaultElevation = 0.0;
const Size kDefaultSize = Size(45.0, 40);
const Color kDefaultShadow = Colors.black;
const OutlinedBorder kDefaultShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(4),
  ),
);
const EdgeInsets kDefaultPadding = EdgeInsets.zero;
const InteractiveInkFeatureFactory kDefaultSplash = InkRipple.splashFactory;

/// Returns a [ButtonStyle] suited to [IconicButton]
ButtonStyle selectableStyleFrom({
  required Color primary,
  required Color onPrimary,
  required Color onSurface,
  Color? shadowColor,
  double elevation = 0.0,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  Size? fixedSize,
  OutlinedBorder? shape,
  Duration? animationDuration,
  InteractiveInkFeatureFactory? splashFactory,
}) {
  return ButtonStyle(
    backgroundColor: _BackgroundProperty(primary, onPrimary),
    foregroundColor: _ForegroundProperty(onPrimary, onSurface, primary),
    overlayColor: _OverlayProperty(primary),
    elevation: _ElevationProperty(elevation),
    animationDuration: animationDuration,
    splashFactory: splashFactory,
    shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
    textStyle: ButtonStyleButton.allOrNull<TextStyle>(textStyle),
    padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
    fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
    shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
  );
}

/// Returns a [ButtonStyle] suited to [ColorButton]
ButtonStyle colorStyleFrom({
  required Size fixedSize,
  Color? shadowColor,
  double elevation = 0.0,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  OutlinedBorder? shape,
  Duration? animationDuration,
  InteractiveInkFeatureFactory? splashFactory,
}) {
  return ButtonStyle(
    elevation: _ElevationProperty(elevation),
    animationDuration: animationDuration,
    splashFactory: splashFactory,
    shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
    textStyle: ButtonStyleButton.allOrNull<TextStyle>(textStyle),
    padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
    fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
    shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
  );
}

/// Returns a [ButtonStyle] suited to [IconicChip] and [CardChip]
ButtonStyle chipStyleFrom({
  required TextStyle textStyle,
  required Color backgroundColor,
  required Color selectedColor,
  Size? fixedSize,
  double pressedElevation = 6.0,
  double defaultElevation = 0.0,
  EdgeInsetsGeometry? padding,
  OutlinedBorder? shape,
  Duration? animationDuration,
  InteractiveInkFeatureFactory? splashFactory,
}) {
  return ButtonStyle(
    backgroundColor: _ChipBackgroundProperty(selectedColor, backgroundColor),
    elevation: _ChipElevationProperty(pressedElevation, defaultElevation),
    animationDuration: animationDuration,
    splashFactory: splashFactory,
    textStyle: ButtonStyleButton.allOrNull<TextStyle>(textStyle),
    padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
    fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
    shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
  );
}

/// Returns a [ButtonStyle] suited to Navigation uses of [IconicButton] where
/// the button content changes but the background does not.
ButtonStyle navigationStyleFrom({
  required Color primary,
  required Color onPrimary,
  Color? onSurface,
  Color? shadowColor,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  Size? fixedSize,
  OutlinedBorder? shape,
  Duration? animationDuration,
  InteractiveInkFeatureFactory? splashFactory,
}) {
  return ButtonStyle(
    backgroundColor: ButtonStyleButton.allOrNull<Color>(primary),
    foregroundColor: _NavigationForegroundProperty(onPrimary),
    overlayColor: _OverlayProperty(primary),
    elevation: ButtonStyleButton.allOrNull<double>(0.0),
    animationDuration: animationDuration,
    splashFactory: splashFactory,
    shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
    textStyle: ButtonStyleButton.allOrNull<TextStyle>(textStyle),
    padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
    fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
    shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
  );
}

/// Property for foreground that changes based whether selected or disabled
/// are present.
@immutable
class _ForegroundProperty extends MaterialStateProperty<Color?> {
  _ForegroundProperty(
    this.primary,
    this.onSurface,
    this.backgroundColor,
  );
  final Color? primary;
  final Color? onSurface;
  final Color? backgroundColor;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return backgroundColor;
    }
    if (states.contains(MaterialState.disabled)) {
      return onSurface?.withOpacity(0.38);
    }
    return primary;
  }

  @override
  String toString() {
    return '{selected: $backgroundColor, or if disabled: '
        '${onSurface?.withOpacity(0.38)}, otherwise: $primary}';
  }
}

/// Property that depends only on selected status and is used for navigation
/// bar
@immutable
class _NavigationForegroundProperty extends MaterialStateProperty<Color?> {
  _NavigationForegroundProperty(this.onPrimary);
  final Color? onPrimary;

  @override
  Color? resolve(Set<MaterialState> states) {
    return states.contains(MaterialState.selected)
        ? onPrimary
        : onPrimary?.withOpacity(0.76);
  }

  @override
  String toString() {
    return '{selected: $onPrimary, otherwise: $onPrimary with opacity 76%}';
  }
}

/// Property for background that changes based whether selected or disabled
/// are present.
@immutable
class _BackgroundProperty extends MaterialStateProperty<Color?> {
  _BackgroundProperty(this.backgroundColor, this.primary);
  final Color? backgroundColor;
  final Color? primary;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return primary;
    }
    return backgroundColor;
  }

  @override
  String toString() {
    return '{selected: $primary, otherwise: $backgroundColor}';
  }
}

/// Property that flips between [backgroundColor] and [selectedColor] based
/// on selected state.
@immutable
class _ChipBackgroundProperty extends MaterialStateProperty<Color?> {
  final Color? backgroundColor;
  final Color? selectedColor;

  _ChipBackgroundProperty(
    this.backgroundColor,
    this.selectedColor,
  );

  @override
  Color? resolve(Set<MaterialState> states) {
    return states.contains(MaterialState.selected)
        ? backgroundColor
        : selectedColor;
  }
}

/// Property that flips between [pressedElevation] and [defaultElevation] based
/// on selected state.
@immutable
class _ChipElevationProperty extends MaterialStateProperty<double?> {
  final double? pressedElevation;
  final double? defaultElevation;

  _ChipElevationProperty(this.pressedElevation, this.defaultElevation);

  @override
  double? resolve(Set<MaterialState> states) {
    return states.contains(MaterialState.pressed)
        ? pressedElevation
        : defaultElevation;
  }
}

/// Property that changes the opacity of primary color based on hovered,
/// focused, and pressed states.
@immutable
class _OverlayProperty extends MaterialStateProperty<Color?> {
  _OverlayProperty(this.primary);

  final Color primary;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered))
      return primary.withOpacity(0.04);
    if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.pressed))
      return primary.withOpacity(0.12);
    return null;
  }

  @override
  String toString() {
    return '{hovered: ${primary.withOpacity(0.04)}, focused, pressed: '
        '${primary.withOpacity(0.12)}, otherwise: null}';
  }
}

/// Property that changes elevation based on hovered state
@immutable
class _ElevationProperty extends MaterialStateProperty<double?> {
  _ElevationProperty(this.elevation)
      : assert(elevation >= 0.0, 'Elevation must be positive.');

  final double elevation;

  @override
  double? resolve(Set<MaterialState> states) {
    return states.contains(MaterialState.hovered) ? elevation * 2.0 : elevation;
  }

  @override
  String toString() {
    return '{hovered: $elevation x 2, otherwise $elevation}';
  }
}

/// Helper function for creating custom ButtonStyle based on ThemeData where
/// parameters are not provided.
///
/// [primary] (the background of the button) [onPrimary] (the foreground of the
/// button) [onSurface] (the disabled color) are modified jointly when the
/// button is selected/unselected or disabled/enabled and should be provided
/// together or left null.
ButtonStyle defaultSelectableStyleOf(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  final ColorScheme colorScheme = theme.colorScheme;
  return selectableStyleFrom(
    primary: colorScheme.primary,
    onPrimary: colorScheme.onPrimary,
    onSurface: colorScheme.onSurface,
    shadowColor: theme.shadowColor,
    fixedSize: kDefaultSize,
    elevation: kDefaultElevation,
    textStyle: theme.textTheme.bodySmall,
    shape: kDefaultShape,
    animationDuration: kThemeChangeDuration,
    splashFactory: InkRipple.splashFactory,
  );
}

ButtonStyle defaultColorStyleOf(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return colorStyleFrom(
    shadowColor: theme.shadowColor,
    fixedSize: kDefaultSize,
    elevation: kDefaultElevation,
    textStyle: theme.textTheme.bodySmall,
    shape: kDefaultShape,
    animationDuration: kThemeChangeDuration,
    splashFactory: InkRipple.splashFactory,
  );
}

ButtonStyle defaultChipStyleOf(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return chipStyleFrom(
    textStyle: DefaultTextStyle.of(context).style,
    backgroundColor: theme.chipTheme.backgroundColor ??
        theme.primaryColor.withAlpha(kBackgroundAlpha),
    selectedColor: theme.chipTheme.selectedColor ??
        theme.primaryColor.withAlpha(kSelectAlpha),
  );
}
