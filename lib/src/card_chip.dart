import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/material.dart';
import 'package:iconic_button/src/animated_widgets.dart';
import 'package:iconic_button/src/icon_rotator.dart';
import 'package:iconic_button/src/icon_switcher.dart';
import 'package:iconic_button/src/material_state_controller.dart';
import 'package:iconic_button/src/style.dart';

/// A customizable, fully animated, expanding Card which uses ListTile for
/// the always-displayed area and a Wrap of actions for the expanding section.
class CardChip extends StatefulWidget {

  /// Creates a customizable, fully animated, expanding Card which uses ListTile
  /// for the always-displayed area and a Wrap of actions for the expanding
  /// section.
  const CardChip({
    super.key,
    required this.title,
    required this.actions,
    this.leadingSwitch,
    this.trailingSwitch,
    this.leadingSpin,
    this.trailingSpin,
    this.subtitle,
    this.onPressed,
    this.background,
    this.selected,
    this.foreground,
    this.titleStyle,
    this.subtitleStyle,
    this.pressedElevation,
    this.defaultElevation,
    this.margin,
    this.shape,
    this.animationDuration,
    this.splashFactory,
    this.actionPadding,
    this.actionSpacing,
    this.tooltip,
    this.tooltipOffset,
    this.preferTooltipBelow,
    this.waitDuration = const Duration(seconds: 2),
    this.transitionDuration,
    this.curve,
    this.isSelected = false,
    this.style,
  })  : assert(
            leadingSwitch == null || leadingSpin == null, "Can only use one"),
        assert(
            trailingSwitch == null || trailingSpin == null, "Can only use one");

  /// String wrapped in Text for [ListTile.title]
  final String title;

  /// String wrapped in Text for [ListTile.subtitle]
  final String? subtitle;

  /// Typically IconicChip
  final List<Widget> actions;

  /// Optional [SwitchIcons] used in [ListTile.leading]. Only one leading
  /// widget is allowed.
  /// Switches between a selected (or nothing if null) and
  /// unselected icon based on selection state.
  final SwitchIcons? leadingSwitch;

  /// Optional [SwitchIcons] used in [ListTile.trailing]. Only one trailing
  /// widget is allowed.
  /// Switches between a selected (or nothing if null) and
  /// unselected icon based on selection state.
  final SwitchIcons? trailingSwitch;

  /// Optional [IconData] wrapped in [IconRotator] used in [ListTile.leading].
  /// Only one leading widget is allowed.
  /// Rotates the icon 1/2 turn based on selection state: Unselected ==
  /// Icon rotated 0 turns, Selected == Icon rotated 1/2 turn.
  final IconData? leadingSpin;

  /// Optional [IconData] wrapped in [IconRotator] used in [ListTile.trailing].
  /// Only one trailing widget is allowed.
  /// Rotates the icon 1/2 turn based on selection state: Unselected ==
  /// Icon rotated 0 turns, Selected == Icon rotated 1/2 turn.
  final IconData? trailingSpin;

  /// Optional padding around actions in the extended area of the card.
  /// Defaults to EdgeInsets.all(16.0)
  final EdgeInsets? actionPadding;

  /// Optional padding between actions in the extended area of the card.
  /// Defaults to 8.0
  final double? actionSpacing;

  /// Optional callback providing the current selection state
  final ValueChanged<bool>? onPressed;

  /// If not null, background color to use instead of IconicCardTheme.background
  final Color? background;

  /// If not null, selected color to use instead of IconicCardTheme.selected
  final Color? selected;

  /// If not null, foreground color to use instead of IconicCardTheme.foreground
  final Color? foreground;

  /// If not null, title TextStyle to use instead of IconicCardTheme.titleStyle
  final TextStyle? titleStyle;

  /// If not null, subtitle TextStyle to use instead of IconicCardTheme.subtitleStyle
  final TextStyle? subtitleStyle;

  /// If not null, elevation to use instead of IconicCardTheme.pressedElevation
  final double? pressedElevation;

  /// If not null, elevation to use instead of IconicCardTheme.defaultElevation
  final double? defaultElevation;

  /// If not null, margin to use instead of IconicCardTheme.margin
  final EdgeInsetsGeometry? margin;

  /// If not null, shape to use instead of IconicCardTheme.shape
  final OutlinedBorder? shape;

  /// If not null, duration to use instead of IconicCardTheme.animationDuration
  final Duration? animationDuration;

  /// If not null, splash to use instead of IconicCardTheme.splashFactory
  final InteractiveInkFeatureFactory? splashFactory;

  /// Optional Tooltip message
  /// A Tooltip will be added only if [tooltip] is not null.
  final String? tooltip;

  /// Optional Tooltip offset
  /// /// A Tooltip will be added only if [tooltip] is not null.
  final double? tooltipOffset;

  /// Optional Tooltip location preference
  /// /// A Tooltip will be added only if [tooltip] is not null.
  final bool? preferTooltipBelow;

  /// Optional Tooltip wait duration when hovering, default is 2 seconds
  /// /// A Tooltip will be added only if [tooltip] is not null.
  final Duration waitDuration;

  /// Animation duration. Default is [kThemeChangeDuration]
  final Duration? transitionDuration;

  /// Animation curve. Default is [Curves.linear]
  final Curve? curve;

  /// Selection state
  final bool isSelected;

  /// Optional ButtonStyle overrides style from theme
  final ButtonStyle? style;

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
    _duration = widget.transitionDuration ?? kThemeChangeDuration;
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
    var cardTheme =
        theme.extension<IconicCardTheme>() ?? IconicCardTheme.of(context);
    cardTheme = cardTheme.copyWith(
      background: widget.background,
      selected: widget.selected,
      foreground: widget.foreground,
      titleStyle: widget.titleStyle,
      subtitleStyle: widget.subtitleStyle,
      pressedElevation: widget.pressedElevation,
      defaultElevation: widget.defaultElevation,
      margin: widget.margin,
      shape: widget.shape,
      animationDuration: widget.animationDuration,
      splashFactory: widget.splashFactory,
    );
    final effectiveStyle = widget.style ?? cardTheme.style;
    bool useLeadingSwitch = widget.leadingSwitch != null;
    bool useTrailingSwitch = widget.trailingSwitch != null;
    bool useLeadingSpin = widget.leadingSpin != null;
    bool useTrailingSpin = widget.trailingSpin != null;
    return SetListenableBuilder<MaterialState>(
      valueListenable: _stateController.listenable,
      builder: (context, states, _) {
        bool isSelected = states.contains(MaterialState.selected);
        Widget? leading;
        if (useLeadingSwitch) {
          leading = IconSwitcher(
            switchIcons: widget.leadingSwitch!,
            isSelected: isSelected,
            duration: _duration,
          );
        }
        if (useLeadingSpin) {
          leading = IconRotator(
            icon: widget.leadingSpin!,
            isSelected: isSelected,
            duration: _duration,
          );
        }
        Widget? trailing;
        if (useTrailingSwitch) {
          trailing = IconSwitcher(
            switchIcons: widget.trailingSwitch!,
            isSelected: isSelected,
            duration: _duration,
          );
        }
        if (useTrailingSpin) {
          trailing = IconRotator(
            icon: widget.trailingSpin!,
            isSelected: isSelected,
            duration: _duration,
          );
        }

        Widget child = _Content(
          title: widget.title,
          titleStyle: cardTheme.titleStyle,
          subtitle: widget.subtitle,
          subtitleStyle: cardTheme.subtitleStyle,
          sizeFactor: _controller.view,
          leading: leading,
          trailing: trailing,
          actions: widget.actions,
          actionPadding: widget.actionPadding,
          actionSpacing: widget.actionSpacing,
        );
        if (widget.tooltip != null) {
          child = Tooltip(
            message: widget.tooltip!,
            verticalOffset: widget.tooltipOffset,
            preferBelow: widget.preferTooltipBelow,
            waitDuration: widget.waitDuration,
            child: child,
          );
        }
        final backColor = effectiveStyle.backgroundColor?.resolve(states);
        final effectiveBackColor = backColor ?? theme.primaryColor;
        final shape = effectiveStyle.shape?.resolve(states);
        final effectiveShape = shape ?? kDefaultCircularShape;
        final elevation = effectiveStyle.elevation?.resolve(states);
        final effectiveElevation = elevation ?? kDefaultElevation;
        final shadow = effectiveStyle.shadowColor?.resolve(states);
        final effectiveShadow = shadow ?? kDefaultShadow;
        final splash = effectiveStyle.splashFactory;
        final effectiveSplash = splash ?? kDefaultSplash;
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
          duration: widget.transitionDuration,
          curve: widget.curve,
          child: child,
        );
        final padding = effectiveStyle.padding?.resolve(states);
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

/// Content of a [CardChip]. Creates a [Flex] rather than a [Column] in order to
/// set clipBehavior to [Clip.none]. Children are a [ListTile] for the
/// always-visible section and a [SizeTransition] of [Wrap] of actions for the
/// expanding section.
class _Content extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> actions;
  final Animation<double> sizeFactor;
  final EdgeInsets? actionPadding;
  final double? actionSpacing;

  const _Content({
    Key? key,
    required this.title,
    required this.actions,
    required this.sizeFactor,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.leading,
    this.trailing,
    this.actionPadding,
    this.actionSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      clipBehavior: Clip.none,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: leading,
          title: Text(title),
          titleTextStyle: titleStyle,
          subtitle: subtitle != null ? Text(subtitle!) : null,
          subtitleTextStyle: subtitleStyle,
          trailing: trailing,
        ),
        Flexible(
          child: SizeTransition(
            sizeFactor: sizeFactor,
            axisAlignment: -1,
            axis: Axis.vertical,
            child: Padding(
              padding: actionPadding ?? kDefaultActionPadding,
              child: Wrap(
                clipBehavior: Clip.none,
                spacing: actionSpacing ?? kDefaultActionSpacing,
                runSpacing: actionSpacing ?? kDefaultActionSpacing,
                children: actions,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
