import 'dart:math';

import 'package:flutter/foundation.dart';
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
  Color? primary,
  Color? onPrimary,
  Color? onSurface,
  Color? shadowColor,
  double? elevation,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  Size? fixedSize,
  OutlinedBorder? shape,
  Duration? animationDuration,
  InteractiveInkFeatureFactory? splashFactory,
}) {
  final MaterialStateProperty<Color?>? foregroundColor =
      (onSurface == null && primary == null)
          ? null
          : _ForegroundMaterialStateProperty(onPrimary, onSurface, primary);
  final MaterialStateProperty<Color?>? background =
      (primary == null && onPrimary == null)
          ? null
          : _BackgroundMaterialStateProperty(primary, onPrimary);
  final MaterialStateProperty<Color?>? overlayColor =
      (primary == null) ? null : _OverlayMaterialStateProperty(primary);
  final MaterialStateProperty<double?>? elevationProperty =
      elevation == null ? null : _ElevationMaterialStateProperty(elevation);

  return ButtonStyle(
    backgroundColor: background,
    foregroundColor: foregroundColor,
    overlayColor: overlayColor,
    elevation: elevationProperty,
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
class _ForegroundMaterialStateProperty extends MaterialStateProperty<Color?> {
  _ForegroundMaterialStateProperty(
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
class _BackgroundMaterialStateProperty extends MaterialStateProperty<Color?> {
  _BackgroundMaterialStateProperty(this.backgroundColor, this.primary);
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
class _OverlayMaterialStateProperty extends MaterialStateProperty<Color?> {
  _OverlayMaterialStateProperty(this.primary);

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
class _ElevationMaterialStateProperty extends MaterialStateProperty<double?> {
  _ElevationMaterialStateProperty(this.elevation)
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

class IconicButton extends StatefulWidget {
  const IconicButton({
    Key? key,
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
  State<StatefulWidget> createState() => IconicButtonState();
}

class IconicButtonState extends State<IconicButton> {
  late IconData _iconData;
  late String? _label;
  ButtonStyle? _style;

  void reset({IconData? iconData, String? label, ButtonStyle? style}) {
    setState(() {
      _iconData = iconData ?? _iconData;
      _label = label ?? _label;
      _style = style ?? _style;
    });
  }

  final Set<MaterialState> _states = {};
  void update({
    Set<MaterialState> add = const {},
    Set<MaterialState> remove = const {},
  }) =>
      setState(() {
        if (add.isNotEmpty) _states.addAll(add);
        if (remove.isNotEmpty) _states.removeAll(remove);
      });

  void select() => update(add: {MaterialState.selected});

  void unSelect() => update(remove: {MaterialState.selected});

  void disable() => update(add: {MaterialState.disabled});

  void enable() => update(remove: {MaterialState.disabled});

  bool get isSelected => _states.contains(MaterialState.selected);

  bool get isDisabled => _states.contains(MaterialState.disabled);

  VoidCallback? get _onTap => isDisabled
      ? null
      : () {
          widget.onPressed();
          update(remove: {MaterialState.pressed});
        };

  ValueChanged<TapDownDetails>? get _onTapDown => isDisabled
      ? null
      : (details) {
          update(add: {MaterialState.pressed});
        };

  VoidCallback? get _onTapCancel =>
      () => update(remove: {MaterialState.pressed});

  ValueChanged<bool>? get _onHover => isDisabled
      ? null
      : (isHovering) {
          if (isHovering) {
            update(add: {MaterialState.hovered});
          } else {
            update(remove: {MaterialState.hovered});
          }
        };

  ValueChanged<bool>? get _onFocusChange => isDisabled
      ? null
      : (isFocused) {
          if (isFocused) {
            update(add: {MaterialState.focused});
          } else {
            update(remove: {MaterialState.focused});
          }
        };

  Color _background(ThemeData theme, ButtonStyle style) =>
      style.backgroundColor?.resolve(_states) ?? theme.primaryColor;

  double _elevation(ButtonStyle style) =>
      style.elevation?.resolve(_states) ?? _defaultElevation;

  Color _shadow(ButtonStyle style) =>
      style.shadowColor?.resolve(_states) ?? _defaultShadow;

  InteractiveInkFeatureFactory _splash(ButtonStyle style) =>
      style.splashFactory ?? _defaultSplash;

  Color _foreground(ThemeData theme, ButtonStyle style) =>
      style.foregroundColor?.resolve(_states) ?? theme.colorScheme.onPrimary;

  Size _size(ButtonStyle style) =>
      style.fixedSize?.resolve(_states) ?? _defaultSize;

  TextStyle _textStyle(ThemeData theme, ButtonStyle style) =>
      style.textStyle?.resolve(_states) ?? theme.textTheme.caption!;

  EdgeInsetsGeometry _padding(ButtonStyle style) =>
      style.padding?.resolve(_states) ?? _defaultPadding;

  @override
  void initState() {
    super.initState();
    _style = widget.style;
    _iconData = widget.iconData;
    _label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ButtonStyle style = _style ?? defaultStyleOf(context);
    final shape = style.shape?.resolve(_states) ?? _defaultShape;
    Widget button = _IconicMaterial(
      backgroundColor: _background(theme, style),
      shape: shape,
      elevation: _elevation(style),
      shadowColor: _shadow(style),
      splashFactory: _splash(style),
      onTap: _onTap,
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onHover: _onHover,
      onFocusChange: _onFocusChange,
      duration: widget.changeDuration,
      curve: widget.curve,
      child: _IconicContent(
        iconData: _iconData,
        label: _label,
        color: _foreground(theme, style),
        shape: shape.copyWith(side: BorderSide.none),
        size: _size(style),
        textStyle: _textStyle(theme, style),
        padding: _padding(style),
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
