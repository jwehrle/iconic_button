import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';

import 'package:iconic_button/src/style.dart';

class CardChip extends StatefulWidget {
  /// ListTile parameters
  final String title;
  final String? subtitle;

  /// Typically IconicChip
  final List<Widget>? choices;
  final IconData? iconData;
  final int maxLines;
  final TextOverflow textOverflow;

  /// Optional Padding around the Text(label) widget
  final EdgeInsetsGeometry? labelPadding;

  /// Optional callback providing the current selection state
  final ValueChanged<bool>? onPressed;

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
  final bool isSelected;

  /// Optional outline color is used when shape is null in style, in which
  /// case this color is applied to a BorderSide of a StadiumBorder.
  final Color? outlineColor;

  const CardChip({
    Key? key,
    required this.title,
    this.iconData,
    this.subtitle,
    this.maxLines = 1,
    this.textOverflow = TextOverflow.ellipsis,
    this.choices,
    this.labelPadding,
    this.onPressed,
    this.style,
    this.tooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.waitDuration = const Duration(seconds: 2),
    this.changeDuration,
    this.curve,
    this.isSelected = false,
    this.outlineColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CardChipState();
}

class CardChipState extends State<CardChip>
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
    final theme = Theme.of(context);
    ButtonStyle style = widget.style ?? defaultChipStyleOf(context);
    TextStyle? textStyle = style.textStyle?.resolve(states);
    Widget child = Flex(
      direction: Axis.vertical,
      clipBehavior: Clip.none,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flex(
          direction: Axis.horizontal,
          clipBehavior: Clip.none,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.subtitle1!.merge(
                textStyle?.copyWith(
                  color: textStyle.color?.withOpacity(0.87),
                ),
              ),
              maxLines: widget.maxLines,
              overflow: widget.textOverflow,
            ),
          ],
        ),
        if (widget.subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Flex(
              direction: Axis.horizontal,
              clipBehavior: Clip.none,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.subtitle!,
                  style: theme.textTheme.bodyText2!.merge(
                    textStyle?.copyWith(
                      color: textStyle.color?.withOpacity(0.73),
                    ),
                  ),
                  maxLines: widget.maxLines,
                  overflow: widget.textOverflow,
                ),
              ],
            ),
          ),
        if (widget.choices != null)
          SizeTransition(
            sizeFactor: _controller.view,
            axisAlignment: -1,
            axis: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Wrap(
                clipBehavior: Clip.none,
                spacing: 8.0,
                runSpacing: 8.0,
                children: widget.choices!,
              ),
            ),
          ),
      ],
    );
    child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: child,
    );
    if (widget.iconData != null) {
      child = Flex(
        direction: Axis.horizontal,
        clipBehavior: Clip.none,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizeTransition(
            sizeFactor: _controller.view,
            axis: Axis.horizontal,
            axisAlignment: -1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: FadeTransition(
                opacity: _controller.view,
                child: Icon(
                  widget.iconData,
                  color: textStyle?.color?.withOpacity(0.73),
                ),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      );
    }
    OutlinedBorder shape = style.shape?.resolve(states) ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        );
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
                  if (states.contains(MaterialState.selected)) {
                    states.remove(MaterialState.selected);
                    widget.onPressed!(false);
                    _controller.reverse();
                  } else {
                    states.add(MaterialState.selected);
                    widget.onPressed!(true);
                    _controller.forward();
                  }
                }
                states.remove(MaterialState.pressed);
              });
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
    final padding = style.padding?.resolve(states);
    if (padding != null) {
      button = Padding(
        padding: padding,
        child: button,
      );
    }
    return button;
  }

  @override
  void didUpdateWidget(covariant CardChip oldWidget) {
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
