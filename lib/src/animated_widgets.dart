import 'package:flutter/material.dart';

class IconicMaterial extends ImplicitlyAnimatedWidget {
  final Color backgroundColor;
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

  IconicMaterial({
    Key? key,
    required this.backgroundColor,
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

class IconicGradientMaterial extends ImplicitlyAnimatedWidget {
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
      // type: MaterialType.card,
      // color: _color!.evaluate(animation)!,
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

class IconicContent extends ImplicitlyAnimatedWidget {
  final IconData iconData;
  final Size size;
  final OutlinedBorder shape;
  final Color color;
  final TextStyle textStyle;
  final String? label;
  final EdgeInsetsGeometry? padding;
  final bool showAlertDot;
  final Color alertDotColor;

  const IconicContent({
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
          Positioned(
            child: Icon(
              Icons.brightness_1,
              color: widget.alertDotColor,
              size: 9.0,
            ),
          ),
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
                    style: widget.textStyle.copyWith(color: color),
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
