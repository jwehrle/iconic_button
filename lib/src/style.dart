import 'package:flutter/material.dart';

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

/// Helper function for creating custom ButtonStyle based on ThemeData where
/// parameters are not provided.
///
/// [primary] (the background of the button) [onPrimary] (the foreground of the
/// button) [onSurface] (the disabled color) are modified jointly when the
/// button is selected/unselected or disabled/enabled and should be provided
/// together or left null.
///
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
    textStyle: theme.textTheme.caption,
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
    textStyle: theme.textTheme.caption,
    shape: kDefaultShape,
    animationDuration: kThemeChangeDuration,
    splashFactory: InkRipple.splashFactory,
  );
}
