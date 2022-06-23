import 'package:flutter/material.dart';
import 'package:iconic_button/button.dart';

class SwitchChip extends StatefulWidget {
  const SwitchChip({
    Key? key,
    required this.selectedLabel,
    required this.unselectedLabel,
    this.maxLines = 1,
    this.textOverflow = TextOverflow.ellipsis,
    this.onPressed,
    this.selectedAvatar,
    this.unselectedAvatar,
    this.labelPadding,
    this.style,
    this.selectedTooltip,
    this.unselectedTooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.waitDuration = const Duration(seconds: 2),
    this.changeDuration = kThemeChangeDuration,
    this.curve,
    this.usePersistentIcon = false,
    this.isSelected = false,
    this.outlineColor,
  })  : assert(selectedAvatar == null || unselectedAvatar != null),
        assert(selectedTooltip == null || unselectedTooltip != null),
        super(key: key);

  /// Generally a CircleAvatar. In this library, the avatar is not darkened
  /// when selected. That is the primary reason for this class as I did not
  /// like the stock Material version of FilterChip
  final Widget? selectedAvatar;
  final Widget? unselectedAvatar;

  /// A label is required for a chip.
  final String selectedLabel;
  final String unselectedLabel;
  final int maxLines;
  final TextOverflow textOverflow;

  /// Optional Padding around the Text(label) widget
  final EdgeInsetsGeometry? labelPadding;

  /// Optional callback providing the current selection state
  final ValueChanged<bool>? onPressed;

  /// Optional styling for this widget. Defaults will be used if null.
  final ButtonStyle? style;

  /// Optional tooltip parameters
  final String? selectedTooltip;
  final String? unselectedTooltip;
  final double? tooltipOffset;
  final bool? preferTooltipBelow;
  final Duration waitDuration;

  /// Animation parameters.
  final Duration? changeDuration;
  final Curve? curve;

  /// Selection parameters
  final bool usePersistentIcon;
  final bool isSelected;

  /// Optional outline color is used when shape is null in style, in which
  /// case this color is applied to a BorderSide of a StadiumBorder.
  final Color? outlineColor;

  @override
  State<StatefulWidget> createState() => SwitchChipState();
}

class SwitchChipState extends State<SwitchChip> {
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
    final ButtonStyle style = widget.style ?? defaultChipStyleOf(context);
    final shape = style.shape?.resolve(states) ??
        (widget.outlineColor != null
            ? StadiumBorder(side: BorderSide(color: widget.outlineColor!))
            : StadiumBorder());
    final TextStyle? textStyle = style.textStyle?.resolve(states);
    Widget child = AnimatedSwitcher(
      duration: widget.changeDuration!,
      child: states.contains(MaterialState.selected)
          ? Text(
              widget.selectedLabel,
              key: ValueKey('selected label'),
              style: textStyle,
              maxLines: widget.maxLines,
              overflow: widget.textOverflow,
            )
          : Text(
              widget.unselectedLabel,
              key: ValueKey('unselected label'),
              style: textStyle,
              maxLines: widget.maxLines,
              overflow: widget.textOverflow,
            ),
    );
    if (widget.labelPadding != null) {
      child = Padding(
        padding: widget.labelPadding!,
        child: child,
      );
    }
    child = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.selectedAvatar != null)
          states.contains(MaterialState.selected)
              ? Container(
                  key: ValueKey('selected avatar'),
                  child: widget.selectedAvatar,
                )
              : Container(
                  key: ValueKey('unselected avatar'),
                  child: widget.unselectedAvatar,
                ),
        child,
      ],
    );
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
                  if (states.contains(MaterialState.selected)) {
                    states.remove(MaterialState.selected);
                    widget.onPressed!(false);
                  } else {
                    states.add(MaterialState.selected);
                    widget.onPressed!(true);
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
    if (widget.selectedTooltip != null) {
      if (widget.isSelected) {
        button = Tooltip(
          message: widget.selectedTooltip!,
          verticalOffset: widget.tooltipOffset,
          preferBelow: widget.preferTooltipBelow,
          waitDuration: widget.waitDuration,
          child: button,
        );
      } else {
        button = Tooltip(
          message: widget.unselectedTooltip!,
          verticalOffset: widget.tooltipOffset,
          preferBelow: widget.preferTooltipBelow,
          waitDuration: widget.waitDuration,
          child: button,
        );
      }
    }
    return button;
  }

  @override
  void didUpdateWidget(covariant SwitchChip oldWidget) {
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
