import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';
import 'package:iconic_button/src/style.dart';

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
    final ButtonStyle style = widget.style ?? defaultSelectableStyleOf(context);
    final shape = style.shape?.resolve(states) ?? kDefaultShape;
    final bool isDisabled = states.contains(MaterialState.disabled);
    Widget button = IconicMaterial(
      backgroundColor:
          style.backgroundColor?.resolve(states) ?? theme.primaryColor,
      shape: shape,
      elevation: style.elevation?.resolve(states) ?? kDefaultElevation,
      shadowColor: style.shadowColor?.resolve(states) ?? kDefaultShadow,
      splashFactory: style.splashFactory ?? kDefaultSplash,
      onTap: isDisabled
          ? null
          : () {
              widget.onPressed();
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
      child: IconicContent(
        iconData: widget.iconData,
        label: widget.label,
        color: style.foregroundColor?.resolve(states) ??
            theme.colorScheme.onPrimary,
        shape: shape.copyWith(side: BorderSide.none),
        size: style.fixedSize?.resolve(states) ?? kDefaultSize,
        textStyle: style.textStyle?.resolve(states) ?? theme.textTheme.caption!,
        padding: style.padding?.resolve(states) ?? kDefaultPadding,
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
