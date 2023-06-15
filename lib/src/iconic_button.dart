import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';
import 'package:iconic_button/src/button_controller.dart';
import 'package:iconic_button/src/style.dart';
import 'package:iconic_button/src/material_state_controller.dart';
import 'package:collection_value_notifier/collection_value_notifier.dart';

/// A toggle-type button with icon, label, and controller. Also offers options
/// like an alert dot, [ButtonStyle], tooltip, and animation modifiers.
class IconicButton extends StatelessWidget {
  /// Creates an [IconicButton] that shows an icon and optional label with
  /// toggle features and a controller.
  const IconicButton({
    Key? key,
    required this.controller,
    required this.iconData,
    required this.onPressed,
    this.isSelectable = true,
    this.label,
    this.tooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.waitDuration = const Duration(seconds: 2),
    this.curve,
    this.showAlertDot = false,
    this.alertDotColor = Colors.red,
    this.primary,
    this.onPrimary,
    this.onSurface,
    this.shadowColor,
    this.elevation,
    this.textStyle,
    this.padding,
    this.shape,
    this.animationDuration,
    this.splashFactory,
  }) : super(key: key);

  /// A ValueNotifier<ButtonState> for controlling whether BaseIconicButton is
  /// enabled, disabled, selected, or unSelected.
  final ButtonController controller;

  /// An icon is always shown. Will be scaled to fit in tile
  final IconData iconData;

  /// Called when button is enabled and tapped
  final VoidCallback onPressed;

  /// Whether this button should behave like a toggle. If false, the button
  /// behaves like a non-toggle button.
  final bool isSelectable;

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

  /// Curve of animated changes to this button. Default is linear.
  final Curve? curve;

  /// Whether to show an alert dot (usually indicative of a notification) on
  /// top of this button. Defaults to false
  final bool showAlertDot;

  /// The color of the optional alert dot. Defaults to [Colors.red]
  final Color alertDotColor;

  /// The foreground color when selected and background color when unselected.
  final Color? primary;

  /// The background color when selected and foreground color when unselected.
  final Color? onPrimary;

  /// The foreground color when disabled.
  final Color? onSurface;

  /// Color of the shadow when elevation is > 0.0
  final Color? shadowColor;

  /// The elevation of the button, defaults to 0.0
  final double? elevation;

  /// The TextStyle of the label, defaults to TextStyle()
  final TextStyle? textStyle;

  /// Padding around the foreground contents of the button. Defaults to
  /// ThemeData.buttonTheme.padding
  final EdgeInsetsGeometry? padding;

  /// The shape of the button, by default a RoundedRectangle with radius of 4.0
  final OutlinedBorder? shape;

  /// The duration of animations, defaults to [kThemeChangeDuration]
  final Duration? animationDuration;

  /// The splash factory, defaults to InkRipple.splashFactory
  final InteractiveInkFeatureFactory? splashFactory;

  void _onSelect(bool isSelected) {
    if (isSelected) {
      controller.select();
    } else {
      controller.unSelect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SetListenableBuilder<ButtonState>(
      valueListenable: controller,
      builder: (context, state, _) {
        return BaseIconicButton(
          isSelected: state.contains(ButtonState.selected),
          isEnabled: state.contains(ButtonState.enabled),
          iconData: iconData,
          onPressed: onPressed,
          isSelectable: isSelectable,
          onSelect: _onSelect,
          label: label,
          tooltip: tooltip,
          tooltipOffset: tooltipOffset,
          preferTooltipBelow: preferTooltipBelow,
          waitDuration: waitDuration,
          curve: curve,
          showAlertDot: showAlertDot,
          alertDotColor: alertDotColor,
          primary: primary,
          onPrimary: onPrimary,
          onSurface: onSurface,
          shadowColor: shadowColor,
          elevation: elevation,
          textStyle: textStyle,
          padding: padding,
          shape: shape,
          animationDuration: animationDuration,
          splashFactory: splashFactory,
        );
      },
    );
  }
}

/// Similar to [IconicButton] but without a [ButtonController]. Instead, this
/// button uses the required fields of [isSelected] and [isEnabled] to define its
/// behavior. (This is the button [IconicButton] builds within a
/// [SetListenableBuilder].)
class BaseIconicButton extends StatefulWidget {
  const BaseIconicButton({
    Key? key,
    required this.isSelected,
    required this.isEnabled,
    required this.iconData,
    required this.onPressed,
    this.onSelect,
    this.isSelectable = true,
    this.label,
    this.tooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.waitDuration = const Duration(seconds: 2),
    this.curve,
    this.showAlertDot = false,
    this.alertDotColor = Colors.red,
    this.primary,
    this.onPrimary,
    this.onSurface,
    this.shadowColor,
    this.elevation,
    this.textStyle,
    this.padding,
    this.shape,
    this.animationDuration,
    this.splashFactory,
  }) : super(key: key);

  /// Whether this button is selected
  final bool isSelected;

  /// Whether this button is enabled
  final bool isEnabled;

  /// Callback with selection state
  final ValueChanged<bool>? onSelect;

  /// Whether this button should behave like a toggle. If false, the button
  /// behaves like a non-toggle button.
  final bool isSelectable;

  /// An icon is always shown. Will be scaled to fit in tile
  final IconData iconData;

  /// Called when button is enabled and tapped
  final VoidCallback onPressed;

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
  // final Duration? changeDuration;

  /// Curve of animated changes to this button. Default is linear.
  final Curve? curve;

  /// Whether to show an a small circular widget over the button
  final bool showAlertDot;

  /// The color to use with an alert dot
  final Color alertDotColor;

  /// The foreground color when selected and background color when unselected.
  final Color? primary;

  /// The background color when selected and foreground color when unselected.
  final Color? onPrimary;

  /// The foreground color when disabled.
  final Color? onSurface;

  /// Color of the shadow when elevation is > 0.0
  final Color? shadowColor;

  /// The elevation of the button, defaults to 0.0
  final double? elevation;

  /// The TextStyle of the label, defaults to TextStyle()
  final TextStyle? textStyle;

  /// Padding around the foreground contents of the button. Defaults to
  /// ThemeData.buttonTheme.padding
  final EdgeInsetsGeometry? padding;

  /// The shape of the button, by default a RoundedRectangle with radius of 4.0
  final OutlinedBorder? shape;

  /// The duration of animations, defaults to [kThemeChangeDuration]
  final Duration? animationDuration;

  /// The splash factory, defaults to InkRipple.splashFactory
  final InteractiveInkFeatureFactory? splashFactory;

  @override
  State<StatefulWidget> createState() => BaseIconicButtonState();
}

/// State that tracks an underlying Set<MaterialState> for this button.
class BaseIconicButtonState extends State<BaseIconicButton>
    with MaterialStateDetectorMixin {
  /// Controller for Set<MaterialState> of this button.
  late final MaterialStateController _stateController;

  @override
  void initState() {
    super.initState();
    // Translate widget states to Set<MaterialState>
    Set<MaterialState> states = {};
    if (widget.isSelected) {
      states.add(MaterialState.selected);
    }
    if (!widget.isEnabled) {
      states.add(MaterialState.disabled);
    }
    // Init controller
    _stateController = MaterialStateController(states: states);
    // Init MaterialState detection. animateForward and animateReverse are not
    // not used because this class uses only implicitly animated widgets.
    initStateDetector(
      controller: _stateController,
      onPressed: widget.onPressed,
      onSelect: widget.onSelect,
      isSelectable: widget.isSelectable,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var buttonTheme =
        theme.extension<IconicButtonTheme>() ?? IconicButtonTheme.of(context);
    buttonTheme = buttonTheme.copyWith(
      primary: widget.primary,
      onPrimary: widget.onPrimary,
      onSurface: widget.onSurface,
      shadowColor: widget.shadowColor,
      elevation: widget.elevation,
      textStyle: widget.textStyle,
      padding: widget.padding,
      shape: widget.shape,
      animationDuration: widget.animationDuration,
      splashFactory: widget.splashFactory,
    );
    final effectiveStyle = buttonTheme.style;
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
        final backColor = effectiveStyle.backgroundColor?.resolve(states);
        final effectiveBackColor = backColor ?? theme.primaryColor;
        final shape = effectiveStyle.shape?.resolve(states);
        final effectiveShape = shape ?? kDefaultRectangularShape;
        final elevation = effectiveStyle.elevation?.resolve(states);
        final effectiveElevation = elevation ?? kDefaultElevation;
        final shadow = effectiveStyle.shadowColor?.resolve(states);
        final effectiveShadow = shadow ?? kDefaultShadow;
        final splash = effectiveStyle.splashFactory;
        final effectiveSplash = splash ?? kDefaultSplash;
        final foreColor = effectiveStyle.foregroundColor?.resolve(states);
        final effectiveForeColor = foreColor ?? theme.colorScheme.onPrimary;
        final textStyle = effectiveStyle.textStyle?.resolve(states);
        final effectiveTextStyle = textStyle ?? theme.textTheme.bodySmall;
        final effectivePadding = effectiveStyle.padding?.resolve(states);
        final bool isDisabled = states.contains(MaterialState.disabled);
        Widget button = IconicMaterial(
          backgroundColor: effectiveBackColor,
          shape: effectiveShape,
          elevation: effectiveElevation,
          shadowColor: effectiveShadow,
          splashFactory: effectiveSplash,
          onTap: isDisabled ? null : onTap,
          onTapDown: isDisabled ? null : onTapDown,
          onTapCancel: onTapCancel,
          onHover: isDisabled ? null : onHover,
          onFocusChange: isDisabled ? null : onFocusChanged,
          duration: effectiveStyle.animationDuration,
          curve: widget.curve,
          child: IconicContent(
            color: effectiveForeColor,
            textStyle: effectiveTextStyle,
            padding: effectivePadding,
            iconData: widget.iconData,
            label: widget.label,
            duration: effectiveStyle.animationDuration,
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
    Set<MaterialState> toAdd = {};
    Set<MaterialState> toRemove = {};

    //unselected -> selected
    if (widget.isSelected && !oldWidget.isSelected) {
      toAdd.add(MaterialState.selected);
    }

    // selected -> unselected
    if (!widget.isSelected && oldWidget.isSelected) {
      toRemove.add(MaterialState.selected);
    }

    // disabled -> enabled
    if (widget.isEnabled && !oldWidget.isEnabled) {
      toRemove.add(MaterialState.disabled);
    }

    // enabled -> disabled
    if (!widget.isEnabled && oldWidget.isEnabled) {
      toAdd.add(MaterialState.disabled);
    }

    if (toAdd.isNotEmpty || toRemove.isNotEmpty) {
      _stateController.update(toAdd: toAdd, toRemove: toRemove);
    }
  }

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }
}
