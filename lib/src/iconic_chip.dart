import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/material.dart';
import 'package:iconic_button/iconic_button.dart';
import 'package:iconic_button/src/material_state_controller.dart';

/// A Button based on the standard Chip but which maintains a state,
/// [isSelected] which enables more complex behavior such as avatar widgets
/// that change based on selection status, visual changes based on
/// [MaterialState] and all visual changes mediated through implicit animations.
///
/// Unlike [FilterChip] the avatar is NOT darkened based on [isSelected] state.
class IconicChip extends StatefulWidget {
  const IconicChip({
    Key? key,
    required this.label,
    this.maxLines = 1,
    this.textOverflow = TextOverflow.ellipsis,
    this.onPressed,
    this.onLongPress,
    this.avatar,
    this.background,
    this.selected,
    this.foreground,
    this.outline,
    this.padding,
    this.labelStyle,
    this.labelPadding,
    this.pressedElevation,
    this.defaultElevation,
    this.fixedSize,
    this.shape,
    this.animationDuration,
    this.splashFactory,
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
    this.outlineColor,
  }) : super(key: key);

  /// Generally a CircleAvatar. In this library, the avatar is not darkened
  /// when selected. That is the primary reason for this class as I did not
  /// like the stock Material version of FilterChip
  final Widget? avatar;

  /// A label is required for a chip.
  final String label;

  /// Max lines of label, defaults to 1.
  final int maxLines;

  /// How to handle text overflow, defaults to [TextOverflow.ellipsis]
  final TextOverflow textOverflow;

  /// Optional callback providing the current selection state. Defines whether
  /// chip state is [MaterialState.disabled] or not (null == disabled).
  final ValueChanged<bool>? onPressed;

  /// Optional long press callback
  final VoidCallback? onLongPress;

  /// Optional styling for this widget. Defaults will be used if null.
  final ButtonStyle? style;

  /// Optional unselected background color, defaults to theme
  final Color? background;

  /// Optional selected background color, defaults to theme
  final Color? selected;

  /// Optional forground color, defaults to theme
  final Color? foreground;

  /// Optional outline color, defaults to theme
  final Color? outline;

  /// Optional label style, defaults to theme
  final TextStyle? labelStyle;

  /// Optional Padding around the Text(label) widget
  final EdgeInsetsGeometry? labelPadding;

  /// Optional size
  final Size? fixedSize;

  /// Optional pressed elevation
  final double? pressedElevation;

  /// Optional default elevation
  final double? defaultElevation;

  /// Optional chip padding
  final EdgeInsetsGeometry? padding;

  /// Optional shape, defaults to Stadium
  final OutlinedBorder? shape;

  /// Optional animation duration, defaults to theme default
  final Duration? animationDuration;

  /// Optional splash factory, defaults to theme default
  final InteractiveInkFeatureFactory? splashFactory;

  /// Optional tooltip
  final String? tooltip;

  /// Offset of tooltip message
  final double? tooltipOffset;

  /// Preference location of tooltip
  final bool? preferTooltipBelow;

  /// Duration to wait for tooltip popup
  final Duration waitDuration;

  /// Animation duration for implicit changes.
  final Duration? changeDuration;

  /// Animation curve for implicit changes
  final Curve? curve;

  /// I true, icon will display regardless of selection state. If false,
  /// icon will be shown only if [isSelected] is true.
  final bool usePersistentIcon;

  /// Whether this widget changes state based on clicks.
  final bool selectable;

  /// The base state of this widget.
  final bool isSelected;

  /// The color of the icon, if shown.
  final Color? iconColor;

  /// The icon to display, defaults to [Icons.check]
  final IconData iconData;

  /// Optional outline color is used when shape is null in style, in which
  /// case this color is applied to a BorderSide of a StadiumBorder.
  final Color? outlineColor;

  @override
  State<StatefulWidget> createState() => IconicChipState();
}

class IconicChipState extends State<IconicChip>
    with SingleTickerProviderStateMixin, MaterialStateDetectorMixin {
  late final AnimationController _controller;
  late final MaterialStateController _stateController;

  /// Assign [_states] based [widget.onSelect] and [widget.isSelected] and
  /// initialize [_controller].
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
    _controller = AnimationController(
      vsync: this,
      duration: widget.changeDuration ?? kThemeChangeDuration,
      lowerBound: 0.0,
      upperBound: 1.0,
      value: states.contains(MaterialState.selected) ? 1.0 : 0.0,
    );
    initStateDetector(
      controller: _stateController,
      onSelect: widget.onPressed,
      isSelectable: widget.selectable,
      animateForward: _controller.forward,
      animateReverse: _controller.reverse,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var chipTheme = theme.extension<IconicChipTheme>() ??
        IconicChipTheme.of(context);
    chipTheme = chipTheme.copyWith(
      background: widget.background,
      selected: widget.selected,
      foreground: widget.foreground,
      outline: widget.outline,
      padding: widget.padding,
      labelStyle: widget.labelStyle,
      labelPadding: widget.labelPadding,
      pressedElevation: widget.pressedElevation,
      defaultElevation: widget.defaultElevation,
      fixedSize: widget.fixedSize,
      shape: widget.shape,
      animationDuration: widget.animationDuration,
      splashFactory: widget.splashFactory,
    );
    final effectiveStyle = widget.style ?? chipTheme.style;
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
        final effectiveTextStyle = effectiveStyle.textStyle?.resolve(states);

        // Build up chip in stages
        Widget child = Text(
          widget.label,
          style: effectiveTextStyle,
          maxLines: widget.maxLines,
          overflow: widget.textOverflow,
        );

        child = Padding(
          padding: chipTheme.labelPadding ?? kDefaultLabelPadding,
          child: child,
        );

        final effectiveIconColor =
            widget.iconColor ?? effectiveTextStyle?.color;
        final icon = Center(
          child: Icon(
            widget.iconData,
            color: effectiveIconColor,
          ),
        );

        final size = effectiveStyle.fixedSize?.resolve(states);
        final effectiveSize = size ?? kDefaultAvatarSize;
        if (widget.usePersistentIcon) {
          child = Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: effectiveSize.width,
                height: effectiveSize.height,
                child: widget.avatar != null
                    ? Stack(children: [widget.avatar!, icon])
                    : icon,
              ),
              child,
            ],
          );
        } else if (widget.selectable) {
          final leading = widget.avatar != null
              ? SizedBox(
                  width: effectiveSize.width,
                  height: effectiveSize.height,
                  child: Stack(
                    children: [
                      widget.avatar!,
                      FadeTransition(opacity: _controller.view, child: icon),
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
                      width: effectiveSize.width,
                      height: effectiveSize.height,
                      child: icon,
                    ),
                  ),
                );

          child = Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading,
              child,
            ],
          );
        } else {
          child = Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.avatar != null ? [widget.avatar!, child] : [child],
          );
        }

        child = Padding(
          padding: effectiveStyle.padding?.resolve(states) ?? kDefaultIconicChipPadding,
          child: child,
        );

        final backColor = effectiveStyle.backgroundColor?.resolve(states);
        final effectiveBackColor = backColor ?? theme.primaryColor;
        final shape = effectiveStyle.shape?.resolve(states);
        final defaultShape = widget.outlineColor != null
            ? StadiumBorder(side: BorderSide(color: widget.outlineColor!))
            : StadiumBorder();
        final effectiveShape = shape ?? defaultShape;
        final elevation = effectiveStyle.elevation?.resolve(states);
        final effectiveElevation = elevation ?? kDefaultElevation;
        final shadow = effectiveStyle.shadowColor?.resolve(states);
        final effectiveShadow = shadow ?? kDefaultShadow;
        final splash = effectiveStyle.splashFactory;
        final effectiveSplash = splash ?? kDefaultSplash;
        final isDisabled = states.contains(MaterialState.disabled);
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
          onLongPress: widget.onLongPress,
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
      },
    );
  }

  /// Check for changes in [widget.onSelect] or [widget.isSelected] and
  /// instigate appropriate changes in [_states] and [_controller].
  @override
  void didUpdateWidget(covariant IconicChip oldWidget) {
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
