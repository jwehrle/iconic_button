import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';
import 'package:iconic_button/src/button_controller.dart';
import 'package:iconic_button/src/style.dart';
import 'package:iconic_button/src/material_state_controller.dart';
import 'package:collection_value_notifier/collection_value_notifier.dart';

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
    this.showAlertDot = false,
    this.alertDotColor = Colors.red,
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

  final bool showAlertDot;

  final Color alertDotColor;

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
          showAlertDot: showAlertDot,
          alertDotColor: alertDotColor,
        );
      },
    );
  }
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
    this.showAlertDot = false,
    this.alertDotColor = Colors.red,
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

  final bool showAlertDot;

  final Color alertDotColor;

  @override
  State<StatefulWidget> createState() => BaseIconicButtonState();
}

class BaseIconicButtonState extends State<BaseIconicButton>
    with MaterialStateDetectorMixin {
  late final MaterialStateController _stateController;

  @override
  void initState() {
    super.initState();
    Set<MaterialState> states = {};
    if (widget.state == ButtonState.selected) {
      states.add(MaterialState.selected);
    }
    if (widget.state == ButtonState.disabled) {
      states.add(MaterialState.disabled);
    }
    _stateController = MaterialStateController(states: states);
    initStateDetector(
      controller: _stateController,
      onPressed: widget.onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ButtonStyle style = widget.style ?? defaultSelectableStyleOf(context);
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
        final shape = style.shape?.resolve(states) ?? kDefaultShape;
        final bool isDisabled = states.contains(MaterialState.disabled);
        Widget button = IconicMaterial(
          backgroundColor:
              style.backgroundColor?.resolve(states) ?? theme.primaryColor,
          shape: shape,
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
          child: IconicContent(
            iconData: widget.iconData,
            label: widget.label,
            color: style.foregroundColor?.resolve(states) ??
                theme.colorScheme.onPrimary,
            shape: shape.copyWith(side: BorderSide.none),
            size: style.fixedSize?.resolve(states) ?? kDefaultSize,
            textStyle:
                style.textStyle?.resolve(states) ?? theme.textTheme.bodySmall!,
            padding: style.padding?.resolve(states) ?? kDefaultPadding,
            duration: widget.changeDuration,
            curve: widget.curve,
            showAlertDot: widget.showAlertDot,
            alertDotColor: widget.alertDotColor,
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
      },
    );
  }

  @override
  void didUpdateWidget(covariant BaseIconicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      Set<MaterialState> toAdd = {};
      Set<MaterialState> toRemove = {};
      switch (widget.state) {
        case ButtonState.selected:
          toAdd.add(MaterialState.selected);
          toRemove.add(MaterialState.disabled);
          break;
        case ButtonState.unselected:
          toRemove.add(MaterialState.selected);
          toRemove.add(MaterialState.disabled);
          break;
        case ButtonState.enabled:
          toRemove.add(MaterialState.disabled);
          break;
        case ButtonState.disabled:
          toAdd.add(MaterialState.disabled);
          toRemove.add(MaterialState.selected);
          break;
      }
      _stateController.update(toAdd: toAdd, toRemove: toRemove);
    }
  }

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }
}
