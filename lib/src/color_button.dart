import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';
import 'package:iconic_button/src/style.dart';
import 'package:iconic_button/src/material_state_controller.dart';
import 'package:collection_value_notifier/collection_value_notifier.dart';

const List<double> _kHalfStops = [0.0, 0.5, 0.5];

class ColorButton extends StatefulWidget {
  final Color color;
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
    required this.color,
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
    final ButtonStyle style = widget.style ?? defaultColorStyleOf(context);
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
        final shape = style.shape?.resolve(states) ?? kDefaultShape;
        final bool isDisabled = states.contains(MaterialState.disabled);
        final icon = Icon(widget.iconData, color: widget.iconColor);
        final selIcon = states.contains(MaterialState.selected) ? icon : null;
        final child = widget.usePersistentIcon
            ? icon
            : widget.selectable
                ? AnimatedContainer(
                    duration: widget.changeDuration ?? kThemeChangeDuration,
                    child: selIcon,
                  )
                : null;
        Widget button = IconicMaterial(
          backgroundColor: widget.color,
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
          child: child,
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

class HalfAndHalfColorButton extends StatefulWidget {
  final Color startColor;
  final Color endColor;
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
  final Color iconStartColor;
  final Color iconEndColor;
  final IconData iconData;

  const HalfAndHalfColorButton({
    Key? key,
    required this.startColor,
    required this.endColor,
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
    this.iconStartColor = Colors.black,
    this.iconEndColor = Colors.white,
    this.iconData = Icons.check,
  })  : assert(
            !usePersistentIcon || !selectable,
            'ColorButton cannot both persistently show an icon AND show an icon'
            ' only when button is selected.'),
        super(key: key);

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
    final ButtonStyle style = widget.style ?? defaultColorStyleOf(context);
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
        final shape = style.shape?.resolve(states) ?? kDefaultShape;
        final bool isDisabled = states.contains(MaterialState.disabled);
        final icon = HalfAndHalfIcon(
          iconData: widget.iconData,
          startColor: widget.iconStartColor,
          endColor: widget.iconEndColor,
        );
        final selIcon = states.contains(MaterialState.selected) ? icon : null;
        final child = widget.usePersistentIcon
            ? icon
            : widget.selectable
                ? AnimatedContainer(
                    duration: widget.changeDuration ?? kThemeChangeDuration,
                    child: selIcon,
                  )
                : null;
        final colors = <Color>[
          widget.startColor,
          widget.startColor,
          widget.endColor,
        ];
        Widget button = IconicGradientMaterial(
          gradient: LinearGradient(stops: _kHalfStops, colors: colors),
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
          child: child,
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

class HalfAndHalfIcon extends StatelessWidget {
  final IconData iconData;
  final Color startColor;
  final Color endColor;

  HalfAndHalfIcon({
    required this.iconData,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          stops: _kHalfStops,
          colors: [startColor, startColor, startColor.withOpacity(0)],
        ).createShader(rect);
      },
      child: Icon(iconData, color: endColor),
    );
  }
}
