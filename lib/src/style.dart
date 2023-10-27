import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconic_button/iconic_button.dart';

/// Utility Functions and Classes for ButtonStyles and MaterialStateProperties
/// based on Material Theme guidelines.
const int kBackgroundAlpha = 0x1f; // 12%
const int kSelectAlpha = 0x3d; // 12% + 12% = 24%
const double kDefaultElevation = 2.0;
const Size kDefaultCircularSize = Size(45.0, 40);
const Size kDefaultAvatarSize = Size(32.0, 32.0);
const Color kDefaultShadow = Colors.black;
const OutlinedBorder kDefaultRectangularShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(4),
  ),
);
const OutlinedBorder kDefaultCircularShape = const CircleBorder();
const InteractiveInkFeatureFactory kDefaultSplash = InkRipple.splashFactory;
const EdgeInsets kDefaultLabelPadding = const EdgeInsets.all(4.0);
const EdgeInsets kDefaultIconicChipPadding = const EdgeInsets.all(4.0);
const kDefaultActionPadding = EdgeInsets.all(16.0);
const kDefaultActionSpacing = 8.0;
const double kTurnSelected = 0.5;
const double kTurnUnselected = 0.0;
const double kDefaultIconSize = 24.0;
/// Stops for [HalfAndHalfColorButton] gradient. Creates a sharp, vertical,
/// 1/2 split.
const List<double> kHalfStops = [0.0, 0.5, 0.5];

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

  final Color? primary;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered))
      return primary?.withOpacity(0.04);
    if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.pressed))
      return primary?.withOpacity(0.12);
    return null;
  }

  @override
  String toString() {
    return '{hovered: ${primary?.withOpacity(0.04)}, focused, pressed: '
        '${primary?.withOpacity(0.12)}, otherwise: null}';
  }
}

/// Property that changes elevation based on hovered state
@immutable
class _ElevationProperty extends MaterialStateProperty<double?> {
  _ElevationProperty(this.elevation);

  final double? elevation;

  @override
  double? resolve(Set<MaterialState> states) {
    return states.contains(MaterialState.hovered)
        ? elevation ?? 0.0 * 2.0
        : elevation;
  }

  @override
  String toString() {
    return '{hovered: $elevation x 2, otherwise $elevation}';
  }
}

/// Theme extension for [ColorButton] with factory and [style]
@immutable
class ColorButtonTheme extends ThemeExtension<ColorButtonTheme> {
  final Color? shadowColor;
  final double? elevation;
  final Size? avatarSize;
  final OutlinedBorder? shape;
  final Duration? animationDuration;
  final InteractiveInkFeatureFactory? splashFactory;

  ColorButtonTheme({
    this.shadowColor,
    this.elevation = kDefaultElevation,
    this.avatarSize = kDefaultCircularSize,
    this.shape = kDefaultCircularShape,
    this.animationDuration = kThemeChangeDuration,
    this.splashFactory = kDefaultSplash,
  });

  factory ColorButtonTheme.of(BuildContext context) {
    return ColorButtonTheme(
      shadowColor: Theme.of(context).shadowColor,
      avatarSize: kDefaultCircularSize,
      elevation: kDefaultElevation,
      shape: kDefaultCircularShape,
      animationDuration: kThemeChangeDuration,
      splashFactory: kDefaultSplash,
    );
  }

  ButtonStyle get style => ButtonStyle(
        elevation: _ElevationProperty(elevation),
        animationDuration: animationDuration,
        splashFactory: splashFactory,
        shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
        fixedSize: ButtonStyleButton.allOrNull<Size>(avatarSize),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      );

  @override
  ColorButtonTheme copyWith({
    Color? shadowColor,
    double? elevation,
    Size? fixedSize,
    OutlinedBorder? shape,
    Duration? animationDuration,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return ColorButtonTheme(
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      avatarSize: fixedSize ?? this.avatarSize,
      shape: shape ?? this.shape,
      animationDuration: animationDuration ?? this.animationDuration,
      splashFactory: splashFactory ?? this.splashFactory,
    );
  }

  @override
  ColorButtonTheme lerp(covariant ColorButtonTheme? other, double t) {
    return ColorButtonTheme(
      shadowColor:
          Color.lerp(shadowColor, other?.shadowColor, t) ?? shadowColor,
      elevation: other != null
          ? lerpDouble(elevation, other.elevation, t) ?? elevation
          : elevation,
      avatarSize: Size.lerp(avatarSize, other?.avatarSize, t),
      shape: OutlinedBorder.lerp(shape, other?.shape, t),
      animationDuration:
          animationDuration != null && other?.animationDuration != null
              ? lerpDuration(animationDuration!, other!.animationDuration!, t)
              : animationDuration,
      splashFactory: splashFactory,
    );
  }
}

/// Theme extension for [IconicButton] with factory, [style], and [navigationStyle]
@immutable
class IconicButtonTheme extends ThemeExtension<IconicButtonTheme> {
  final Color? primary;
  final Color? onPrimary;
  final Color? onSurface;
  final Color? shadowColor;
  final double? elevation;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final Duration? animationDuration;
  final InteractiveInkFeatureFactory? splashFactory;

  IconicButtonTheme({
    this.primary,
    this.onPrimary,
    this.onSurface,
    this.shadowColor,
    this.elevation = kDefaultElevation,
    this.textStyle,
    this.padding,
    this.shape = kDefaultRectangularShape,
    this.animationDuration = kThemeChangeDuration,
    this.splashFactory = kDefaultSplash,
  });

  factory IconicButtonTheme.of(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return IconicButtonTheme(
      primary: theme.colorScheme.primary,
      onPrimary: theme.colorScheme.onPrimary,
      onSurface: theme.colorScheme.onSurface,
      shadowColor: theme.shadowColor,
      elevation: kDefaultElevation,
      textStyle: theme.textTheme.bodySmall,
      padding: theme.buttonTheme.padding,
      shape: kDefaultRectangularShape,
      animationDuration: kThemeChangeDuration,
      splashFactory: kDefaultSplash,
    );
  }

  ButtonStyle get style => ButtonStyle(
        backgroundColor: _BackgroundProperty(primary, onPrimary),
        foregroundColor: _ForegroundProperty(onPrimary, onSurface, primary),
        overlayColor: _OverlayProperty(primary),
        elevation: _ElevationProperty(elevation),
        animationDuration: animationDuration,
        splashFactory: splashFactory,
        shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
        textStyle: ButtonStyleButton.allOrNull<TextStyle>(textStyle),
        padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      );

  ButtonStyle get navigationStyle => ButtonStyle(
        backgroundColor: ButtonStyleButton.allOrNull<Color>(primary),
        foregroundColor: _NavigationForegroundProperty(onPrimary),
        overlayColor: _OverlayProperty(primary),
        elevation: ButtonStyleButton.allOrNull<double>(0.0),
        animationDuration: animationDuration,
        splashFactory: splashFactory,
        shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
        textStyle: ButtonStyleButton.allOrNull<TextStyle>(textStyle),
        padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      );

  @override
  IconicButtonTheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? onSurface,
    Color? shadowColor,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    OutlinedBorder? shape,
    Duration? animationDuration,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return IconicButtonTheme(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      onSurface: onSurface ?? this.onSurface,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      shape: shape ?? this.shape,
      animationDuration: animationDuration ?? this.animationDuration,
      splashFactory: splashFactory ?? this.splashFactory,
    );
  }

  @override
  IconicButtonTheme lerp(covariant IconicButtonTheme? other, double t) {
    return IconicButtonTheme(
      primary: Color.lerp(primary, other?.primary, t) ?? primary,
      onPrimary: Color.lerp(onPrimary, other?.onPrimary, t) ?? onPrimary,
      onSurface: Color.lerp(onSurface, other?.onSurface, t) ?? onSurface,
      shadowColor:
          Color.lerp(shadowColor, other?.shadowColor, t) ?? shadowColor,
      elevation: other != null
          ? lerpDouble(elevation, other.elevation, t) ?? elevation
          : elevation,
      textStyle: TextStyle.lerp(textStyle, other?.textStyle, t),
      padding: EdgeInsetsGeometry.lerp(padding, other?.padding, t),
      shape: OutlinedBorder.lerp(shape, other?.shape, t),
      animationDuration:
          animationDuration != null && other?.animationDuration != null
              ? lerpDuration(animationDuration!, other!.animationDuration!, t)
              : animationDuration,
      splashFactory: splashFactory,
    );
  }
}

/// Theme extension for [IconicChip] with factory and [style]
@immutable
class IconicChipTheme extends ThemeExtension<IconicChipTheme> {
  final Color? background;
  final Color? selected;
  final Color? foreground;
  final Color? outline;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Size? fixedSize;
  final double? pressedElevation;
  final double? defaultElevation;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final Duration? animationDuration;
  final InteractiveInkFeatureFactory? splashFactory;

  const IconicChipTheme({
    this.background,
    this.selected,
    this.foreground,
    this.outline,
    this.padding = const EdgeInsets.all(4.0),
    this.labelStyle,
    this.labelPadding = const EdgeInsets.all(4.0),
    this.pressedElevation = 6.0,
    this.defaultElevation = 1.0,
    this.fixedSize = kDefaultAvatarSize,
    this.shape = const StadiumBorder(),
    this.animationDuration = kThemeAnimationDuration,
    this.splashFactory = kDefaultSplash,
  });

  factory IconicChipTheme.of(BuildContext context) {
    final theme = Theme.of(context);
    return IconicChipTheme(
      labelStyle: theme.chipTheme.labelStyle,
      background: theme.chipTheme.backgroundColor,
      selected: theme.chipTheme.selectedColor,
    );
  }

  ButtonStyle get style => ButtonStyle(
        backgroundColor: _ChipBackgroundProperty(selected, background),
        elevation: _ChipElevationProperty(pressedElevation, defaultElevation),
        animationDuration: animationDuration,
        splashFactory: splashFactory,
        textStyle: ButtonStyleButton.allOrNull<TextStyle>(
            labelStyle?.copyWith(color: foreground)),
        padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
        fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      );

  @override
  IconicChipTheme copyWith({
    Color? background,
    Color? selected,
    Color? outline,
    Color? foreground,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? labelPadding,
    double? pressedElevation,
    double? defaultElevation,
    Size? fixedSize,
    OutlinedBorder? shape,
    Duration? animationDuration,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return IconicChipTheme(
      background: background ?? this.background,
      selected: selected ?? this.selected,
      outline: outline ?? this.outline,
      foreground: foreground ?? this.foreground,
      labelStyle: labelStyle ?? this.labelStyle,
      padding: padding ?? this.padding,
      labelPadding: labelPadding ?? this.labelPadding,
      pressedElevation: pressedElevation ?? this.pressedElevation,
      defaultElevation: defaultElevation ?? this.defaultElevation,
      fixedSize: fixedSize ?? this.fixedSize,
      shape: shape ?? this.shape,
      animationDuration: animationDuration ?? this.animationDuration,
      splashFactory: splashFactory ?? this.splashFactory,
    );
  }

  @override
  IconicChipTheme lerp(ThemeExtension<IconicChipTheme>? other, double t) {
    if (other is! IconicChipTheme) {
      return this;
    }
    return IconicChipTheme(
        background: Color.lerp(background, other.background, t),
        selected: Color.lerp(selected, other.selected, t),
        foreground: Color.lerp(foreground, other.foreground, t),
        outline: Color.lerp(outline, other.outline, t),
        labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
        padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
        labelPadding:
            EdgeInsetsGeometry.lerp(labelPadding, other.labelPadding, t),
        pressedElevation:
            lerpDouble(pressedElevation, other.pressedElevation, t),
        defaultElevation:
            lerpDouble(defaultElevation, other.defaultElevation, t),
        fixedSize: Size.lerp(fixedSize, other.fixedSize, t),
        shape: OutlinedBorder.lerp(shape, other.shape, t),
        animationDuration:
            animationDuration != null && other.animationDuration != null
                ? lerpDuration(animationDuration!, other.animationDuration!, t)
                : animationDuration,
        splashFactory: splashFactory);
  }

  @override
  String toString() => 'IconicChipTheme(background: $background, '
      'selected: $selected, outline: $outline, '
      'foreground: $foreground)';
}

/// Theme extension for [IconicCard] with factory and [style]
@immutable
class IconicCardTheme extends ThemeExtension<IconicCardTheme> {
  final Color? background;
  final Color? selected;
  final Color? foreground;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? pressedElevation;
  final double? defaultElevation;
  final EdgeInsetsGeometry? margin;
  final OutlinedBorder? shape;
  final Duration? animationDuration;
  final InteractiveInkFeatureFactory? splashFactory;

  const IconicCardTheme({
    this.background,
    this.selected,
    this.foreground,
    this.titleStyle,
    this.subtitleStyle,
    this.pressedElevation = 6.0,
    this.defaultElevation = 1.0,
    this.margin = const EdgeInsets.all(4.0),
    this.shape = kDefaultRectangularShape,
    this.animationDuration = kThemeAnimationDuration,
    this.splashFactory = kDefaultSplash,
  });

  factory IconicCardTheme.of(BuildContext context) {
    final theme = Theme.of(context);
    return IconicCardTheme(
      background: theme.cardColor,
      selected: theme.chipTheme.selectedColor,
      foreground: theme.textTheme.bodySmall?.color,
      titleStyle: theme.listTileTheme.titleTextStyle,
      subtitleStyle: theme.listTileTheme.subtitleTextStyle,
      shape: kDefaultRectangularShape,
      animationDuration: kThemeAnimationDuration,
      splashFactory: kDefaultSplash,
    );
  }

  ButtonStyle get style => ButtonStyle(
        backgroundColor: _ChipBackgroundProperty(selected, background),
        elevation: _ChipElevationProperty(pressedElevation, defaultElevation),
        animationDuration: animationDuration,
        splashFactory: splashFactory,
        padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(margin),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      );

  @override
  IconicCardTheme copyWith({
    Color? background,
    Color? selected,
    Color? outline,
    Color? foreground,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? pressedElevation,
    double? defaultElevation,
    EdgeInsetsGeometry? margin,
    OutlinedBorder? shape,
    Duration? animationDuration,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return IconicCardTheme(
      background: background ?? this.background,
      selected: selected ?? this.selected,
      foreground: foreground ?? this.foreground,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      pressedElevation: pressedElevation ?? this.pressedElevation,
      defaultElevation: defaultElevation ?? this.defaultElevation,
      margin: margin ?? this.margin,
      shape: shape ?? this.shape,
      animationDuration: animationDuration ?? this.animationDuration,
      splashFactory: splashFactory ?? this.splashFactory,
    );
  }

  @override
  IconicCardTheme lerp(ThemeExtension<IconicCardTheme>? other, double t) {
    if (other is! IconicCardTheme) {
      return this;
    }
    return IconicCardTheme(
      background: Color.lerp(background, other.background, t),
      selected: Color.lerp(selected, other.selected, t),
      foreground: Color.lerp(foreground, other.foreground, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      pressedElevation: lerpDouble(pressedElevation, other.pressedElevation, t),
      defaultElevation: lerpDouble(defaultElevation, other.defaultElevation, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      shape: OutlinedBorder.lerp(shape, other.shape, t),
      animationDuration:
          animationDuration != null && other.animationDuration != null
              ? lerpDuration(animationDuration!, other.animationDuration!, t)
              : animationDuration,
      splashFactory: splashFactory,
    );
  }

  @override
  String toString() => 'IconicChipTheme(background: $background, '
      'selected: $selected, foreground: $foreground)';
}
