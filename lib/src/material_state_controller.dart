import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/material.dart';

/// Controller for a Set<MaterialState> with listenable, update, and dispose.
/// Intended to be used with a [SetListenableBuilder] using [listenable].
class MaterialStateController {

  /// Creates a controller for a [Set] of [MaterialState]
  MaterialStateController({Set<MaterialState> states = const <MaterialState>{}})
      : this._stateNotifier = SetNotifier(states);

  final SetNotifier<MaterialState> _stateNotifier;

  SetListenable<MaterialState> get listenable => _stateNotifier;

  Set<MaterialState> get states => _stateNotifier.value;

  void update({
    Set<MaterialState> toAdd = const {},
    Set<MaterialState> toRemove = const {},
  }) {
    if (toAdd.isNotEmpty || toRemove.isNotEmpty) {
      _stateNotifier.syncEditBlock((set) {
        set.addAll(toAdd);
        set.removeAll(toRemove);
        return set;
      });
    }
  }

  void dispose() {
    _stateNotifier.dispose();
  }
}

/// Provides a [MaterialStateController] management, callbacks and states useful
/// to widgets that depend on a Set<MaterialState>
mixin MaterialStateDetectorMixin {
  late final MaterialStateController controller;
  ValueChanged<bool>? onSelect;
  VoidCallback? onPressed;
  bool? selectable;
  VoidCallback? animateForward;
  VoidCallback? animateReverse;
  bool _initialized = false;
  bool _useOnSelect = false;
  bool _useOnPressed = false;

  /// Must be called once and only once (usually in State.initSate) in order to
  /// initialize members.
  void initStateDetector({
    required MaterialStateController controller,
    ValueChanged<bool>? onSelect,
    VoidCallback? onPressed,
    bool? isSelectable,
    VoidCallback? animateForward,
    VoidCallback? animateReverse,
  }) {
    assert(!_initialized, 'MaterialStateDetectorMixin should not be initialized more than once.');
    _initialized = true;
    this.controller = controller;
    this.onSelect = onSelect;
    _useOnSelect = onSelect != null;
    this.onPressed = onPressed;
    _useOnPressed = onPressed != null;
    this.selectable = isSelectable;
    this.animateForward = animateForward;
    this.animateReverse = animateReverse;
  }

  /// Changes [controller] in reaction to onTap based on initialized parameters.
  void onTap() {
    Set<MaterialState> add = {};
    Set<MaterialState> remove = {};
    if (_useOnSelect || _useOnPressed) {
      if (selectable ?? true) {
        if (controller.states.contains(MaterialState.selected)) {
          remove.add(MaterialState.selected);
          if (_useOnSelect) {
            onSelect!(false);
          }
          if (_useOnPressed) {
            onPressed!();
          }
          if (animateReverse != null) {
            animateReverse!();
          }
        } else {
          add.add(MaterialState.selected);
          if (_useOnSelect) {
            onSelect!(true);
          }
          if (_useOnPressed) {
            onPressed!();
          }
          if (animateForward != null) {
            animateForward!();
          }
        }
      } else {
        if (_useOnSelect) {
          onSelect!(false);
        }
        if (_useOnPressed) {
          onPressed!();
        }
      }
    }
    remove.add(MaterialState.pressed);
    controller.update(toRemove: remove, toAdd: add);
  }

  /// Changes [controller] in reaction to onTapDown.
  void onTapDown(TapDownDetails details) {
    controller.update(toAdd: {MaterialState.pressed});
  }

  /// Changes [controller] in reaction to onTapCancel
  void onTapCancel() {
    controller.update(toRemove: {MaterialState.pressed});
  }

  /// Changes [controller] in reaction to onTapDown.
  void onHover(bool isHovering) {
    if (isHovering) {
      controller.update(toAdd: {MaterialState.hovered});
    } else {
      controller.update(toRemove: {MaterialState.hovered});
    }
  }

  void onFocusChanged(bool isFocused) {
    if (isFocused) {
      controller.update(toAdd: {MaterialState.focused});
    } else {
      controller.update(toRemove: {MaterialState.focused});
    }
  }
}
