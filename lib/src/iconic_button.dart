import 'dart:math';

import 'package:flutter/material.dart';

const double _defaultElevation = 0.0;
const Size _defaultSize = Size(45.0, 40);
const Color _defaultShadow = Colors.black;
const OutlinedBorder _defaultShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(4),
  ),
);
const EdgeInsets _defaultPadding = EdgeInsets.zero;
const InteractiveInkFeatureFactory _defaultSplash = InkRipple.splashFactory;

/// Helper function for creating custom ButtonStyle based on ThemeData where
/// parameters are not provided.
///
/// [primary] (the background of the button) [onPrimary] (the foreground of the
/// button) [onSurface] (the disabled color) are modified jointly when the
/// button is selected/unselected or disabled/enabled and should be provided
/// together or left null.
///
ButtonStyle buttonStyleFrom({
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

ButtonStyle defaultStyleOf(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  final ColorScheme colorScheme = theme.colorScheme;
  return buttonStyleFrom(
    primary: colorScheme.primary,
    onPrimary: colorScheme.onPrimary,
    onSurface: colorScheme.onSurface,
    shadowColor: theme.shadowColor,
    fixedSize: _defaultSize,
    elevation: _defaultElevation,
    textStyle: theme.textTheme.caption,
    shape: _defaultShape,
    animationDuration: kThemeChangeDuration,
    splashFactory: InkRipple.splashFactory,
  );
}

enum ButtonState { selected, unselected, enabled, disabled }

class ButtonController extends ValueNotifier<ButtonState> {
  ButtonController({ButtonState? value}) : super(value ?? ButtonState.enabled);

  select() => value = ButtonState.selected;

  unSelect() => value = ButtonState.unselected;

  enable() => value = ButtonState.enabled;

  disable() => value = ButtonState.disabled;
}

class BaseIconicButton extends StatefulWidget {
  const BaseIconicButton({
    Key? key,
    required this.state,
    required this.iconData,
    required this.onPressed,
    this.style,
    this.label,
    this.tooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.waitDuration = const Duration(seconds: 2),
    this.changeDuration,
    this.curve,
  }) : super(key: key);

  /// Whether this button is enabled, disabled, selected, or unSelected
  final ButtonState state;

  /// An icon is always shown. Will be scaled to fit in tile
  final IconData iconData;

  /// Called when button is enabled and tapped
  final VoidCallback onPressed;

  /// Used to style the button colors and decorations. If not null, it will
  /// be used instead of any other (convenience) style parameters.
  final ButtonStyle? style;

  /// Label is optional. If present will be scaled to fit in the tile
  final String? label;

  /// Optional tooltip. If non-null tile will be wrapped in Tooltip
  final String? tooltip;

  /// Distance from tile Tooltip will be offset. Default is set by theme or
  /// otherwise 24.0
  final double? tooltipOffset;

  /// Tooltip location preference. preferTooltipBelow is true.
  final bool? preferTooltipBelow;

  /// Hover wait duration before showing tooltip. Default is 2 seconds.
  final Duration waitDuration;

  /// Duration of changes to this button. Default is 200 milliseconds.
  final Duration? changeDuration;

  /// Curve of animated changes to this button. Default is linear.
  final Curve? curve;

  @override
  State<StatefulWidget> createState() => BaseIconicButtonState();
}

class BaseIconicButtonState extends State<BaseIconicButton> {
  final Set<MaterialState> states = {};

  void _update({
    Set<MaterialState> add = const {},
    Set<MaterialState> remove = const {},
  }) {
    if (add.isNotEmpty || remove.isNotEmpty) {
      setState(() {
        states.addAll(add);
        states.removeAll(remove);
      });
    }
  }

  void _applyButtonState(ButtonState buttonState) {
    switch (buttonState) {
      case ButtonState.selected:
        states.add(MaterialState.selected);
        states.remove(MaterialState.disabled);
        break;
      case ButtonState.unselected:
        states.remove(MaterialState.selected);
        states.remove(MaterialState.disabled);
        break;
      case ButtonState.enabled:
        states.remove(MaterialState.disabled);
        break;
      case ButtonState.disabled:
        states.add(MaterialState.disabled);
        states.remove(MaterialState.selected);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _applyButtonState(widget.state);
  }

  @override
  void didUpdateWidget(covariant BaseIconicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      _applyButtonState(widget.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ButtonStyle style = widget.style ?? defaultStyleOf(context);
    final shape = style.shape?.resolve(states) ?? _defaultShape;
    final bool isDisabled = states.contains(MaterialState.disabled);
    Widget button = _IconicMaterial(
      backgroundColor:
          style.backgroundColor?.resolve(states) ?? theme.primaryColor,
      shape: shape,
      elevation: style.elevation?.resolve(states) ?? _defaultElevation,
      shadowColor: style.shadowColor?.resolve(states) ?? _defaultShadow,
      splashFactory: style.splashFactory ?? _defaultSplash,
      onTap: isDisabled
          ? null
          : () {
              widget.onPressed();
              _update(remove: {MaterialState.pressed});
            },
      onTapDown: isDisabled
          ? null
          : (details) => _update(add: {MaterialState.pressed}),
      onTapCancel: () => _update(remove: {MaterialState.pressed}),
      onHover: isDisabled
          ? null
          : (isHovering) {
              if (isHovering) {
                _update(add: {MaterialState.hovered});
              } else {
                _update(remove: {MaterialState.hovered});
              }
            },
      onFocusChange: isDisabled
          ? null
          : (isFocused) {
              if (isFocused) {
                _update(add: {MaterialState.focused});
              } else {
                _update(remove: {MaterialState.focused});
              }
            },
      duration: widget.changeDuration,
      curve: widget.curve,
      child: _IconicContent(
        iconData: widget.iconData,
        label: widget.label,
        color: style.foregroundColor?.resolve(states) ??
            theme.colorScheme.onPrimary,
        shape: shape.copyWith(side: BorderSide.none),
        size: style.fixedSize?.resolve(states) ?? _defaultSize,
        textStyle: style.textStyle?.resolve(states) ?? theme.textTheme.caption!,
        padding: style.padding?.resolve(states) ?? _defaultPadding,
        duration: widget.changeDuration,
        curve: widget.curve,
      ),
    );
    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        verticalOffset: widget.tooltipOffset,
        preferBelow: widget.preferTooltipBelow,
        waitDuration: widget.waitDuration,
        child: button,
      );
    }
    return button;
  }
}

class IconicButton extends StatelessWidget {
  const IconicButton({
    Key? key,
    required this.controller,
    required this.iconData,
    required this.onPressed,
    this.style,
    this.label,
    this.tooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.waitDuration = const Duration(seconds: 2),
    this.changeDuration,
    this.curve,
  }) : super(key: key);

  /// A ValueNotifier<ButtonState> for controlling whether BaseIconicButton is
  /// enabled, disabled, selected, or unSelected.
  final ButtonController controller;

  /// An icon is always shown. Will be scaled to fit in tile
  final IconData iconData;

  /// Called when button is enabled and tapped
  final VoidCallback onPressed;

  /// Used to style the button colors and decorations. If not null, it will
  /// be used instead of any other (convenience) style parameters.
  final ButtonStyle? style;

  /// Label is optional. If present will be scaled to fit in the tile
  final String? label;

  /// Optional tooltip. If non-null tile will be wrapped in Tooltip
  final String? tooltip;

  /// Distance from tile Tooltip will be offset. Default is set by theme or
  /// otherwise 24.0
  final double? tooltipOffset;

  /// Tooltip location preference. preferTooltipBelow is true.
  final bool? preferTooltipBelow;

  /// Hover wait duration before showing tooltip. Default is 2 seconds.
  final Duration waitDuration;

  /// Duration of changes to this button. Default is 200 milliseconds.
  final Duration? changeDuration;

  /// Curve of animated changes to this button. Default is linear.
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: controller,
      builder: (context, state, _) {
        return BaseIconicButton(
          state: state,
          iconData: iconData,
          onPressed: onPressed,
          style: style,
          label: label,
          tooltip: tooltip,
          tooltipOffset: tooltipOffset,
          preferTooltipBelow: preferTooltipBelow,
          waitDuration: waitDuration,
          changeDuration: changeDuration,
          curve: curve,
        );
      },
    );
  }
}

class _IconicMaterial extends ImplicitlyAnimatedWidget {
  final Color backgroundColor;
  final double elevation;
  final Color shadowColor;
  final OutlinedBorder shape;
  final Widget child;
  final VoidCallback? onTap;
  final ValueChanged<TapDownDetails>? onTapDown;
  final VoidCallback? onTapCancel;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final InteractiveInkFeatureFactory? splashFactory;

  _IconicMaterial({
    Key? key,
    required this.backgroundColor,
    required this.shadowColor,
    required this.shape,
    required this.child,
    required this.elevation,
    this.onTap,
    this.onTapDown,
    this.onTapCancel,
    this.onHover,
    this.onFocusChange,
    this.splashFactory,
    Curve? curve,
    Duration? duration,
  }) : super(
          key: key,
          curve: curve ?? Curves.linear,
          duration: duration ?? kThemeChangeDuration,
        );

  @override
  _IconicMaterialState createState() => _IconicMaterialState();
}

class _IconicMaterialState extends AnimatedWidgetBaseState<_IconicMaterial> {
  ColorTween? _color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _color!.evaluate(animation)!,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor,
      shape: widget.shape,
      child: InkWell(
        customBorder: widget.shape,
        onTap: widget.onTap,
        onTapDown: widget.onTapDown,
        onTapCancel: widget.onTapCancel,
        onHover: widget.onHover,
        onFocusChange: widget.onFocusChange,
        splashFactory: widget.splashFactory,
        child: widget.child,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(
      _color,
      widget.backgroundColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
  }
}

class _IconicContent extends ImplicitlyAnimatedWidget {
  final IconData iconData;
  final Size size;
  final OutlinedBorder shape;
  final Color color;
  final TextStyle textStyle;
  final String? label;
  final EdgeInsetsGeometry? padding;

  const _IconicContent({
    Key? key,
    required this.iconData,
    required this.size,
    required this.shape,
    required this.color,
    required this.textStyle,
    this.label,
    this.padding,
    Curve? curve,
    Duration? duration,
  }) : super(
          key: key,
          curve: curve ?? Curves.linear,
          duration: duration ?? kThemeChangeDuration,
        );

  @override
  _IconicContentState createState() => _IconicContentState();
}

class _IconicContentState extends AnimatedWidgetBaseState<_IconicContent> {
  static const double _internalPadding = 3.0;
  ColorTween? _color;

  double get _radius => min(widget.size.width, widget.size.height) / 2.0;

  double get _sideWidth => (_internalPadding + widget.shape.side.width) / 2.0;

  double get _innerDiameter => (_radius - _sideWidth) * sqrt2;

  double get _innerWidth =>
      widget.size.width - (_internalPadding + widget.shape.side.width);

  Alignment get _iconAlignment =>
      widget.label != null ? Alignment.bottomCenter : Alignment.center;

  @override
  Widget build(BuildContext context) {
    Color color = _color!.evaluate(animation)!;
    double innerWidth;
    Alignment labelAlignment;
    if (widget.shape is CircleBorder) {
      innerWidth = _innerDiameter;
      labelAlignment = Alignment.topCenter;
    } else {
      innerWidth = _innerWidth;
      labelAlignment = Alignment.bottomCenter;
    }
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      alignment: Alignment.center,
      margin: widget.padding,
      child: SizedBox(
        width: innerWidth,
        child: widget.label == null
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(widget.iconData, color: color),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FittedBox(
                    alignment: _iconAlignment,
                    fit: BoxFit.scaleDown,
                    child: Icon(widget.iconData, color: color),
                  ),
                  FittedBox(
                    alignment: labelAlignment,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label!,
                      style: widget.textStyle.copyWith(color: color),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(
      _color,
      widget.color,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
  }
}
