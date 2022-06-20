import 'package:flutter/material.dart';
import 'package:iconic_button/button.dart';

class IconicChip extends StatefulWidget {
  final Widget? avatar;
  final String label;
  final EdgeInsetsGeometry? labelPadding;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final String? tooltip;
  final double? tooltipOffset;
  final bool? preferTooltipBelow;
  final Duration waitDuration;
  final Duration? changeDuration;
  final Curve? curve;
  final bool usePersistentIcon;
  final bool selectable;
  final bool isSelected;
  final Color iconColor;
  final IconData iconData;

  const IconicChip({
    Key? key,
    required this.label,
    this.onPressed,
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
    this.iconColor = Colors.white,
    this.iconData = Icons.check,
  }) : super(key: key);

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
    final shape = style.shape?.resolve(states) ?? StadiumBorder();
    Widget child = Text(widget.label, style: style.textStyle?.resolve(states));
    if (widget.labelPadding != null) {
      child = Padding(
        padding: widget.labelPadding!,
        child: child,
      );
    }
    if (widget.avatar != null) {
      if (widget.usePersistentIcon) {
        Size size = style.fixedSize?.resolve(states) ?? kDefaultSize;
        Widget leading = SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              widget.avatar!,
              Center(child: Icon(widget.iconData, color: widget.iconColor)),
            ],
          ),
        );
        child = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [leading, child],
        );
      } else if (widget.selectable) {
        Size size = style.fixedSize?.resolve(states) ?? kDefaultSize;
        Widget leading = SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              widget.avatar!,
              FadeTransition(
                opacity: _controller.view,
                child: Center(
                  child: Icon(widget.iconData, color: widget.iconColor),
                ),
              ),
            ],
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
          children: [widget.avatar!, child],
        );
      }
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
              if (widget.onPressed != null) widget.onPressed!();
              update(remove: {MaterialState.pressed});
            },
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
