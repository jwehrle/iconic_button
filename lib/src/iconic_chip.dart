import 'package:flutter/material.dart';
import 'package:iconic_button/button.dart';

const Size kDefaultAvatarSize = Size(32.0, 32.0);

class IconicChip extends StatefulWidget {
  const IconicChip({
    Key? key,
    required this.label,
    this.maxLines = 1,
    this.textOverflow = TextOverflow.ellipsis,
    this.onPressed,
    this.onLongPress,
    this.avatar,
    this.labelPadding,
    this.style,
    this.tooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.waitDuration = const Duration(seconds: 2),
    this.changeDuration,
    this.curve,
    this.usePersistentIcon = false,
    this.selectable = false,
    this.isSelected = false,
    this.iconColor,
    this.iconData = Icons.check,
    this.useCheck = true,
    this.outlineColor,
  }) : super(key: key);

  /// Generally a CircleAvatar. In this library, the avatar is not darkened
  /// when selected. That is the primary reason for this class as I did not
  /// like the stock Material version of FilterChip
  final Widget? avatar;

  /// A label is required for a chip.
  final String label;
  final int maxLines;
  final TextOverflow textOverflow;

  /// Optional Padding around the Text(label) widget
  final EdgeInsetsGeometry? labelPadding;

  /// Optional callback providing the current selection state
  final ValueChanged<bool>? onPressed;

  final VoidCallback? onLongPress;

  /// Optional styling for this widget. Defaults will be used if null.
  final ButtonStyle? style;

  /// Optional tooltip parameters
  final String? tooltip;
  final double? tooltipOffset;
  final bool? preferTooltipBelow;
  final Duration waitDuration;

  /// Animation parameters.
  final Duration? changeDuration;
  final Curve? curve;

  /// Selection parameters
  final bool usePersistentIcon;
  final bool selectable;
  final bool isSelected;
  final Color? iconColor;
  final IconData iconData;
  final bool useCheck;

  /// Optional outline color is used when shape is null in style, in which
  /// case this color is applied to a BorderSide of a StadiumBorder.
  final Color? outlineColor;

  @override
  State<StatefulWidget> createState() => IconicChipState();
}

class IconicChipState extends State<IconicChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Set<MaterialState> states = {};

  void update({
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

  @override
  void initState() {
    super.initState();
    if (widget.onPressed == null) {
      states.add(MaterialState.disabled);
    }
    if (widget.isSelected) {
      states.add(MaterialState.selected);
    }
    _controller = AnimationController(
      vsync: this,
      duration: widget.changeDuration ?? kThemeChangeDuration,
      lowerBound: 0.0,
      upperBound: 1.0,
      value: states.contains(MaterialState.selected) ? 1.0 : 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = widget.style ?? defaultChipStyleOf(context);
    final shape = style.shape?.resolve(states) ??
        (widget.outlineColor != null
            ? StadiumBorder(side: BorderSide(color: widget.outlineColor!))
            : StadiumBorder());
    final TextStyle? textStyle = style.textStyle?.resolve(states);
    Widget child = Text(
      widget.label,
      style: textStyle,
      maxLines: widget.maxLines,
      overflow: widget.textOverflow,
    );
    if (widget.labelPadding != null) {
      child = Padding(
        padding: widget.labelPadding!,
        child: child,
      );
    }
    Color? iconColor = widget.iconColor ?? textStyle?.color;
    Size size = style.fixedSize?.resolve(states) ?? kDefaultAvatarSize;
    if (widget.usePersistentIcon) {
      Widget leading = SizedBox(
        width: size.width,
        height: size.height,
        child: widget.avatar != null
            ? Stack(
                children: [
                  widget.avatar!,
                  Center(child: Icon(widget.iconData, color: iconColor)),
                ],
              )
            : Center(child: Icon(widget.iconData, color: iconColor)),
      );
      child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [leading, child],
      );
    } else if (widget.selectable) {
      Widget leading = widget.avatar != null
          ? SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  widget.avatar!,
                  FadeTransition(
                    opacity: _controller.view,
                    child: Center(
                      child: Icon(widget.iconData, color: iconColor),
                    ),
                  ),
                ],
              ),
            )
          : SizeTransition(
              sizeFactor: _controller.view,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: FadeTransition(
                opacity: _controller.view,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Center(
                    child: Icon(widget.iconData, color: iconColor),
                  ),
                ),
              ),
            );
      child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [leading, child],
      );
    } else {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.avatar != null ? [widget.avatar!, child] : [child],
      );
    }
    final padding = style.padding?.resolve(states);
    if (padding != null) {
      child = Padding(
        padding: padding,
        child: child,
      );
    }
    final bool isDisabled = states.contains(MaterialState.disabled);
    Widget button = IconicMaterial(
      backgroundColor: style.backgroundColor?.resolve(states) ??
          Theme.of(context).primaryColor,
      shape: shape,
      elevation: style.elevation?.resolve(states) ?? kDefaultElevation,
      shadowColor: style.shadowColor?.resolve(states) ?? kDefaultShadow,
      splashFactory: style.splashFactory ?? kDefaultSplash,
      onTap: isDisabled
          ? null
          : () {
              setState(() {
                if (widget.onPressed != null) {
                  if (widget.selectable) {
                    if (states.contains(MaterialState.selected)) {
                      states.remove(MaterialState.selected);
                      widget.onPressed!(false);
                      _controller.reverse();
                    } else {
                      states.add(MaterialState.selected);
                      widget.onPressed!(true);
                      _controller.forward();
                    }
                  } else {
                    widget.onPressed!(!widget.isSelected);
                  }
                }
                states.remove(MaterialState.pressed);
              });
            },
      onLongPress: widget.onLongPress,
      onTapDown:
          isDisabled ? null : (details) => update(add: {MaterialState.pressed}),
      onTapCancel: () => update(remove: {MaterialState.pressed}),
      onHover: isDisabled
          ? null
          : (isHovering) {
              if (isHovering) {
                update(add: {MaterialState.hovered});
              } else {
                update(remove: {MaterialState.hovered});
              }
            },
      onFocusChange: isDisabled
          ? null
          : (isFocused) {
              if (isFocused) {
                update(add: {MaterialState.focused});
              } else {
                update(remove: {MaterialState.focused});
              }
            },
      duration: widget.changeDuration,
      curve: widget.curve,
      child: child,
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

  @override
  void didUpdateWidget(covariant IconicChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed != oldWidget.onPressed) {
      if (widget.onPressed == null) {
        states.add(MaterialState.disabled);
      } else {
        states.remove(MaterialState.disabled);
      }
    }
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        states.add(MaterialState.selected);
        _controller.forward();
      } else {
        states.remove(MaterialState.selected);
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
