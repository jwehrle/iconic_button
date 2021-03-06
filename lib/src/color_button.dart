import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';
import 'package:iconic_button/src/style.dart';

class ColorButton extends StatefulWidget {
  final int colorInt;
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

  const ColorButton({
    Key? key,
    required this.colorInt,
    this.onPressed,
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
  })  : assert(
            !usePersistentIcon || !selectable,
            'ColorButton cannot both persistently show an icon AND show an icon'
            ' only when button is selected.'),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ColorButtonState();
}

class ColorButtonState extends State<ColorButton> {
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
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = widget.style ?? defaultColorStyleOf(context);
    final shape = style.shape?.resolve(states) ?? kDefaultShape;
    final bool isDisabled = states.contains(MaterialState.disabled);
    Widget button = IconicMaterial(
      backgroundColor: Color(widget.colorInt),
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
      child: widget.usePersistentIcon
          ? Icon(widget.iconData, color: widget.iconColor)
          : widget.selectable
              ? AnimatedContainer(
                  duration: widget.changeDuration ?? kThemeChangeDuration,
                  child: states.contains(MaterialState.selected)
                      ? Icon(widget.iconData, color: widget.iconColor)
                      : null,
                )
              : null,
    );
    Size size = style.fixedSize?.resolve(states) ?? kDefaultSize;
    button = SizedBox(
      width: size.width,
      height: size.height,
      child: button,
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
  void didUpdateWidget(covariant ColorButton oldWidget) {
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
      } else {
        states.remove(MaterialState.selected);
      }
    }
  }
}
