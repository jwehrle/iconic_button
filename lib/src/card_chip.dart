import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';
import 'package:iconic_button/src/material_state_controller.dart';
import 'package:iconic_button/src/style.dart';

// const OutlinedBorder _kDefaultShape = RoundedRectangleBorder(
//   borderRadius: BorderRadius.all(
//     Radius.circular(4.0),
//   ),
// );

class CardChip extends StatefulWidget {
  /// ListTile parameters
  final String title;
  final String? subtitle;

  /// Typically IconicChip
  final List<Widget>? choices;
  final IconData? selectedIconData;
  final IconData? unSelectedIconData;
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
    this.selectedIconData,
    this.unSelectedIconData,
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
    with SingleTickerProviderStateMixin, MaterialStateDetectorMixin {
  late final AnimationController _controller;
  late final MaterialStateController _stateController;
  late final Duration _duration;

  @override
  void initState() {
    super.initState();
    Set<MaterialState> states = {};
    if (widget.onPressed == null) {
      states.add(MaterialState.disabled);
    }
    if (widget.isSelected) {
      states.add(MaterialState.selected);
    }
    _stateController = MaterialStateController(states: states);
    _duration = widget.changeDuration ?? kThemeChangeDuration;
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
      lowerBound: 0.0,
      upperBound: 1.0,
      value: states.contains(MaterialState.selected) ? 1.0 : 0.0,
    );
    initStateDetector(
      controller: _stateController,
      onSelect: widget.onPressed,
      animateForward: _controller.forward,
      animateReverse: _controller.reverse,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
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
                  style: theme.textTheme.titleMedium!.merge(
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
                      style: theme.textTheme.bodyMedium!.merge(
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
        if (widget.selectedIconData != null) {
          Widget icon;
          if (widget.unSelectedIconData != null) {
            icon = Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: AnimatedSwitcher(
                duration: _duration,
                child: states.contains(MaterialState.selected)
                    ? Icon(
                        widget.selectedIconData,
                        key: ValueKey('selected_icon'),
                        color: textStyle?.color?.withOpacity(0.73),
                      )
                    : Icon(
                        widget.unSelectedIconData,
                        key: ValueKey('unselected_icon'),
                        color: textStyle?.color?.withOpacity(0.73),
                      ),
              ),
            );
          } else {
            icon = SizeTransition(
              sizeFactor: _controller.view,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: FadeTransition(
                  opacity: _controller.view,
                  child: Icon(
                    widget.selectedIconData,
                    color: textStyle?.color?.withOpacity(0.73),
                  ),
                ),
              ),
            );
          }
          child = Flex(
            direction: Axis.horizontal,
            clipBehavior: Clip.none,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              Expanded(child: child),
            ],
          );
        }
        final bool isDisabled = states.contains(MaterialState.disabled);
        Widget button = IconicMaterial(
          backgroundColor:
              style.backgroundColor?.resolve(states) ?? theme.primaryColor,
          shape: style.shape?.resolve(states) ?? kDefaultShape,
          elevation: style.elevation?.resolve(states) ?? kDefaultElevation,
          shadowColor: style.shadowColor?.resolve(states) ?? kDefaultShadow,
          splashFactory: style.splashFactory ?? kDefaultSplash,
          onTap: isDisabled ? null : onTap,
          onTapDown: isDisabled ? null : onTapDown,
          onTapCancel: onTapCancel,
          onHover: isDisabled ? null : onHover,
          onFocusChange: isDisabled ? null : onFocusChanged,
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
      },
    );
  }

  @override
  void didUpdateWidget(covariant CardChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final Set<MaterialState> toAdd = {};
    final Set<MaterialState> toRemove = {};
    if (widget.onPressed != oldWidget.onPressed) {
      if (widget.onPressed == null) {
        toAdd.add(MaterialState.disabled);
      } else {
        toRemove.add(MaterialState.disabled);
      }
    }
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        toAdd.add(MaterialState.selected);
        _controller.forward();
      } else {
        toRemove.add(MaterialState.selected);
        _controller.reverse();
      }
    }
    if (toAdd.isNotEmpty || toRemove.isNotEmpty) {
      _stateController.update(toAdd: toAdd, toRemove: toRemove);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _stateController.dispose();
    super.dispose();
  }
}
