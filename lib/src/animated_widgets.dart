import 'package:flutter/material.dart';
import 'package:iconic_button/iconic_button.dart';

/// Splash focused wrapper for Material that implicitly animates color and
/// automatically handles MaterialState changes from interactions like tap,
/// hover, focus change, etc.
///
/// Created because vanilla Material does not automatically handle splash well
/// when a child is present and vanilla Material doesn't implicitly animate
/// color changes.
///
/// Used in [CardChip], [ColorButton], [IconicButton], [IconicChip]
class IconicMaterial extends ImplicitlyAnimatedWidget {

  /// Changing [backgroundColor] triggers implicit animation between old
  /// color and new color.
  IconicMaterial({
    Key? key,
    required this.backgroundColor,
    required this.shadowColor,
    required this.shape,
    required this.elevation,
    this.child,
    this.onLongPress,
    this.onDoubleTap,
    this.onHighlightChanged,
    this.mouseCursor,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onHover,
    this.onFocusChange,
    this.splashFactory,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.overlayColor,
    this.splashColor,
    this.autoFocus = false,
    this.focusNode,
    this.borderRadius,
    this.radius,
    this.canRequestFocus = true,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    Curve? curve,
    Duration? duration,
  }) : super(
          key: key,
          curve: curve ?? Curves.linear,
          duration: duration ?? kThemeChangeDuration,
        );

  final Color backgroundColor;
  final double elevation;
  final Color shadowColor;
  final OutlinedBorder shape;
  final Widget? child;
  final GestureTapCallback? onTap;
  final ValueChanged<TapDownDetails>? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onDoubleTap;
  final MouseCursor? mouseCursor;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final InteractiveInkFeatureFactory? splashFactory;
  final Color? focusColor;
  final Color? highlightColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final bool autoFocus;
  final FocusNode? focusNode;
  final BorderRadius? borderRadius;
  final double? radius;
  final bool canRequestFocus;
  final bool enableFeedback;
  final bool excludeFromSemantics;

  @override
  IconicMaterialState createState() => IconicMaterialState();
}

class IconicMaterialState extends AnimatedWidgetBaseState<IconicMaterial> {
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
        onLongPress: widget.onLongPress,
        onDoubleTap: widget.onDoubleTap,
        onTap: widget.onTap,
        onTapDown: widget.onTapDown,
        onTapUp: widget.onTapUp,
        onTapCancel: widget.onTapCancel,
        onHover: widget.onHover,
        onHighlightChanged: widget.onHighlightChanged,
        mouseCursor: widget.mouseCursor,
        onFocusChange: widget.onFocusChange,
        splashFactory: widget.splashFactory,
        focusColor: widget.focusColor,
        highlightColor: widget.highlightColor,
        hoverColor: widget.hoverColor,
        overlayColor: widget.overlayColor,
        splashColor: widget.splashColor,
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        borderRadius: widget.borderRadius,
        radius: widget.radius,
        canRequestFocus: widget.canRequestFocus,
        enableFeedback: true,
        excludeFromSemantics: widget.excludeFromSemantics,
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

/// Splash focused wrapper for Material that replaces background color with
/// a LinearGradient that is implicitly animated and automatically handles
/// MaterialState changes from interactions like tap, hover, focus change, etc.
///
/// Created because vanilla Material does not automatically handle splash well
/// when a child is present and vanilla Material doesn't use a LinearGradient
/// background, let alone implicitly animating gradient changes.
///
/// Used in [HalfAndHalfColorButton]
class IconicGradientMaterial extends ImplicitlyAnimatedWidget {

  /// Changing [gradient] triggers implicit animation between old  gradient and
  /// new gradient.
  IconicGradientMaterial({
    Key? key,
    required this.gradient,
    required this.shadowColor,
    required this.shape,
    required this.elevation,
    this.child,
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

  final LinearGradient gradient;
  final double elevation;
  final Color shadowColor;
  final OutlinedBorder shape;
  final Widget? child;
  final VoidCallback? onTap;
  final ValueChanged<TapDownDetails>? onTapDown;
  final VoidCallback? onTapCancel;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final InteractiveInkFeatureFactory? splashFactory;

  @override
  IconicGradientMaterialState createState() => IconicGradientMaterialState();
}

class IconicGradientMaterialState
    extends AnimatedWidgetBaseState<IconicGradientMaterial> {
  LinearGradientTween? _gradientTween;

  @override
  Widget build(BuildContext context) {
    LinearGradient gradient = _gradientTween!.evaluate(animation)!;
    return Material(
      elevation: widget.elevation,
      shadowColor: widget.shadowColor,
      shape: widget.shape,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(gradient: gradient),
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
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _gradientTween = visitor(
            _gradientTween,
            widget.gradient,
            (dynamic value) =>
                LinearGradientTween(begin: value as LinearGradient))
        as LinearGradientTween?;
  }
}

class LinearGradientTween extends Tween<LinearGradient?> {
  LinearGradientTween({LinearGradient? begin, LinearGradient? end})
      : super(begin: begin, end: end);

  @override
  LinearGradient? lerp(double t) {
    return LinearGradient.lerp(begin, end, t);
  }
}

/// Icon based widget that optionally displays text. Changes to color are
/// animated and an optional notification dot can be displayed.
///
/// Used in [IconicButton]
class IconicContent extends ImplicitlyAnimatedWidget {
  final IconData iconData;
  final Color color;
  final TextStyle? textStyle;
  final String? label;
  final EdgeInsetsGeometry? padding;
  final bool showAlertDot;
  final Color alertDotColor;

  /// Changing [color] triggers animation from old color to new color.
  const IconicContent({
    Key? key,
    required this.iconData,
    required this.color,
    this.textStyle,
    this.label,
    this.padding,
    Curve? curve,
    Duration? duration,
    this.showAlertDot = false,
    this.alertDotColor = Colors.red,
  }) : super(
          key: key,
          curve: curve ?? Curves.linear,
          duration: duration ?? kThemeChangeDuration,
        );

  @override
  IconicContentState createState() => IconicContentState();
}

class IconicContentState extends AnimatedWidgetBaseState<IconicContent> {
  ColorTween? _color;

  @override
  Widget build(BuildContext context) {
    Color color = _color!.evaluate(animation)!;

    Widget icon = Icon(widget.iconData, color: color);
    if (widget.showAlertDot) {
      icon = Stack(
        children: [
          icon,
          Positioned(child: IconDot(dotColor: widget.alertDotColor)),
        ],
      );
    }
    return IntrinsicWidth(
      child: Container(
        alignment: Alignment.center,
        margin: widget.padding,
        child: widget.label == null
            ? icon
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  icon,
                  Text(
                    widget.label!,
                    style: widget.textStyle?.copyWith(color: color),
                    maxLines: 1,
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

/// Standard notification style dot.
class IconDot extends StatelessWidget {
  final Color dotColor;
  final IconData dotIcon;
  final double dotSize;

  const IconDot({
    Key? key,
    this.dotColor = Colors.red,
    this.dotIcon = Icons.brightness_1,
    this.dotSize = 9.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(dotIcon, color: dotColor, size: dotSize);
  }
}
