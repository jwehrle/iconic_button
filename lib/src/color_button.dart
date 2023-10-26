import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';
import 'package:iconic_button/src/half_and_half_icon.dart';
import 'package:iconic_button/src/style.dart';
import 'package:iconic_button/src/material_state_controller.dart';
import 'package:collection_value_notifier/collection_value_notifier.dart';

/// Base for both ColorButton and HalfAndHalfColorButton
abstract class ColorButtonBase extends StatefulWidget {
  /// Callback when this button is pressed.
  final VoidCallback? onPressed;

  /// Optional tooltip for this button. If not null, widget is wrapped in a
  /// Tooltip.
  final String? tooltip;

  /// Optional offset of optional Tooltip, see [tooltip]
  final double? tooltipOffset;

  /// Optional location preference of optional Tooltip, see [tooltip]
  final bool? preferTooltipBelow;

  /// Optional wait duration of optional Tooltip, see [tooltip]
  final Duration waitDuration;

  /// Curve for implicit animations - default is Curves.linear
  final Curve? curve;

  /// Whether the icon of this button should be shown both when selected and
  /// unselected.
  final bool usePersistentIcon;

  /// Whether this button should behave as a toggle (when selectable is true)
  /// or as a non-toggle button (when selectable is false), default is true.
  final bool selectable;

  /// Whether this button is selected
  final bool isSelected;

  /// Color for the icon of this button
  final Color iconColor;

  /// IconData of icon of this button
  final IconData iconData;

  /// Optional shadowColor will replace ColorButtonTheme.shadowColor if not null
  /// /// See [ColorButtonTheme] for defaults
  final Color? shadowColor;

  /// Optional elevation will replace ColorButtonTheme.elevation if not null
  /// /// See [ColorButtonTheme] for defaults
  final double? elevation;

  /// Optional size of avatar will replace ColorButtonTheme.fixedSize if not null
  /// /// See [ColorButtonTheme] for defaults
  final Size? fixedSize;

  /// Optional shape of button will replace ColorButtonTheme.shape if not null
  /// /// See [ColorButtonTheme] for defaults
  final OutlinedBorder? shape;

  /// Optional implicit animation duration replaces ColorButtonTheme.animationDuration if not null
  /// /// See [ColorButtonTheme] for defaults
  final Duration? animationDuration;

  /// Optional splash factory replaces ColorButtonTheme.splashFactory if not null
  /// See [ColorButtonTheme] for defaults
  final InteractiveInkFeatureFactory? splashFactory;

  final ButtonStyle? style;

  /// Abstract base class for [ColorButton] and [HalfAndHalfColorButton].
  /// Encapsulates common member fields.
  const ColorButtonBase({
    super.key,
    required this.iconData,
    required this.iconColor,
    required this.isSelected,
    required this.selectable,
    required this.waitDuration,
    required this.usePersistentIcon,
    this.onPressed,
    this.tooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.curve,
    this.shadowColor,
    this.elevation,
    this.fixedSize,
    this.shape,
    this.animationDuration,
    this.splashFactory,
    this.style,
  });
}

/// A toggle button with a color background and an optional icon which can be
/// shown all the time or only when selected.
class ColorButton extends ColorButtonBase {

  /// Creates a toggle button with a color background and an optional icon
  /// which can be shown all the time or only when selected.
  const ColorButton({
    super.key,
    required this.color,
    super.onPressed,
    super.tooltip,
    super.tooltipOffset,
    super.preferTooltipBelow,
    super.waitDuration = const Duration(seconds: 2),
    super.curve,
    super.usePersistentIcon = false,
    super.selectable = true,
    super.isSelected = false,
    super.iconColor = Colors.white,
    super.iconData = Icons.check,
    super.shadowColor,
    super.elevation,
    super.fixedSize,
    super.shape,
    super.animationDuration,
    super.splashFactory,
    super.style,
  }) : assert(
            !usePersistentIcon || !selectable,
            'ColorButton cannot both persistently show an icon AND show an icon'
            ' only when button is selected.');

  /// The color this color button shows.
  final Color color;

  @override
  State<StatefulWidget> createState() => ColorButtonState();
}

class ColorButtonState extends State<ColorButton>
    with MaterialStateDetectorMixin {
  late final MaterialStateController _stateController;

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
    initStateDetector(
      controller: _stateController,
      onPressed: widget.onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).extension<ColorButtonTheme>() ??
        ColorButtonTheme.of(context);
    final effectiveStyle;
    if (widget.style != null) {
      effectiveStyle = widget.style;
    } else {
      colorTheme = colorTheme.copyWith(
        shadowColor: widget.shadowColor,
        elevation: widget.elevation,
        fixedSize: widget.fixedSize,
        shape: widget.shape,
        animationDuration: widget.animationDuration,
        splashFactory: widget.splashFactory,
      );
      effectiveStyle = colorTheme.style;
    }
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
        final shape = effectiveStyle.shape?.resolve(states);
        final effectiveShape = shape ?? kDefaultCircularShape;
        final elevation = effectiveStyle.elevation?.resolve(states);
        final effectiveElevation = elevation ?? kDefaultElevation;
        final shadow = effectiveStyle.shadowColor?.resolve(states);
        final effectiveShadow = shadow ?? kDefaultShadow;
        final splash = effectiveStyle.splashFactory;
        final effectiveSplash = splash ?? kDefaultSplash;
        final bool isDisabled = states.contains(MaterialState.disabled);
        final bool isSelected = states.contains(MaterialState.selected);
        final icon = Icon(widget.iconData, color: widget.iconColor);
        Widget button = IconicMaterial(
          backgroundColor: widget.color,
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
          child: widget.usePersistentIcon
              ? icon
              : widget.selectable
                  ? AnimatedContainer(
                      duration: effectiveStyle.animationDuration ??
                          kThemeChangeDuration,
                      child: isSelected ? icon : null,
                    )
                  : null,
        );
        final size = effectiveStyle.fixedSize?.resolve(states);
        final effectiveSize = size ?? kDefaultCircularSize;
        button = SizedBox.fromSize(
          size: effectiveSize,
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
      },
    );
  }

  @override
  void didUpdateWidget(covariant ColorButton oldWidget) {
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
      } else {
        toRemove.add(MaterialState.selected);
      }
    }
    _stateController.update(toAdd: toAdd, toRemove: toRemove);
  }

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }
}

/// A toggle button with a two-color background and an optional icon which can
/// be shown all the time or only when selected. Good for a dynamic option
/// such as when a color will change depending on app brightness.
class HalfAndHalfColorButton extends ColorButtonBase {
  
  /// Creates a toggle button with a two-color background and an optional icon
  /// which can be shown all the time or only when selected. Good for a dynamic
  /// option such as when a color will change depending on app brightness.
  const HalfAndHalfColorButton({
    super.key,
    required this.startColor,
    required this.endColor,
    this.iconStartColor = Colors.black,
    this.iconEndColor = Colors.white,
    super.onPressed,
    super.tooltip,
    super.tooltipOffset,
    super.preferTooltipBelow,
    super.waitDuration = const Duration(seconds: 2),
    super.curve,
    super.usePersistentIcon = false,
    super.selectable = true,
    super.isSelected = false,
    super.iconColor = Colors.white,
    super.iconData = Icons.check,
    super.shadowColor,
    super.elevation,
    super.fixedSize,
    super.shape,
    super.animationDuration,
    super.splashFactory,
    super.style,
  }) : assert(
            !usePersistentIcon || !selectable,
            'ColorButton cannot both persistently show an icon AND show an icon'
            ' only when button is selected.');

  /// Color of left half of background
  final Color startColor;

  /// Color of right half of background
  final Color endColor;

  /// Color of left half of forground
  final Color iconStartColor;

  /// Color of right half of foreground
  final Color iconEndColor;

  @override
  State<StatefulWidget> createState() => HalfAndHalfColorButtonState();
}

class HalfAndHalfColorButtonState extends State<HalfAndHalfColorButton>
    with MaterialStateDetectorMixin {
  late final MaterialStateController _stateController;

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
    initStateDetector(
      controller: _stateController,
      onPressed: widget.onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle effectiveStyle;
    if (widget.style != null) {
      effectiveStyle = widget.style!;
    } else {
      ColorButtonTheme colorTheme = Theme.of(context).extension<ColorButtonTheme>() ??
          ColorButtonTheme.of(context);
      colorTheme = colorTheme.copyWith(
        shadowColor: widget.shadowColor,
        elevation: widget.elevation,
        fixedSize: widget.fixedSize,
        shape: widget.shape,
        animationDuration: widget.animationDuration,
        splashFactory: widget.splashFactory,
      );
      effectiveStyle = colorTheme.style;
    }
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
        final shape = effectiveStyle.shape?.resolve(states);
        final effectiveShape = shape ?? kDefaultRectangularShape;
        final elevation = effectiveStyle.elevation?.resolve(states);
        final effectiveElevation = elevation ?? kDefaultElevation;
        final shadow = effectiveStyle.shadowColor?.resolve(states);
        final effectiveShadow = shadow ?? kDefaultShadow;
        final splash = effectiveStyle.splashFactory;
        final effectiveSplash = splash ?? kDefaultSplash;
        final size = effectiveStyle.fixedSize?.resolve(states);
        final effectiveSize = size ?? kDefaultCircularSize;
        final isSelected = states.contains(MaterialState.selected);
        final isDisabled = states.contains(MaterialState.disabled);
        final icon = HalfAndHalfIcon(
          iconData: widget.iconData,
          startColor: widget.iconStartColor,
          endColor: widget.iconEndColor,
        );
        final child = widget.usePersistentIcon
            ? icon
            : widget.selectable
                ? AnimatedContainer(
                    duration: effectiveStyle.animationDuration ??
                        kThemeChangeDuration,
                    child: isSelected ? icon : null,
                  )
                : null;
        final colors = <Color>[
          widget.startColor,
          widget.startColor,
          widget.endColor,
        ];
        Widget button = IconicGradientMaterial(
          gradient: LinearGradient(stops: kHalfStops, colors: colors),
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
          child: child,
        );
        button = SizedBox.fromSize(
          size: effectiveSize,
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
      },
    );
  }

  @override
  void didUpdateWidget(covariant HalfAndHalfColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
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
      } else {
        toRemove.add(MaterialState.selected);
      }
    }
    _stateController.update(toAdd: toAdd, toRemove: toRemove);
  }

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }
}