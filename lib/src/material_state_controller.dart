import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/material.dart';

/// Controller for a Set<MaterialState> with listenable, update, and dispose.
/// Intended to be used with a [SetListenableBuilder] using [listenable].
class MaterialStateController {
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

class MaterialStateDetectorMixin {
  MaterialStateController? controller;
  ValueChanged<bool>? onSelect;
  VoidCallback? onPressed;
  bool? selectable;
  VoidCallback? animateForward;
  VoidCallback? animateReverse;
  bool _initialized = false;
  bool _useOnSelect = false;
  bool _useOnPressed = false;

  void initStateDetector({
    required MaterialStateController controller,
    ValueChanged<bool>? onSelect,
    VoidCallback? onPressed,
    bool? selectable,
    VoidCallback? animateForward,
    VoidCallback? animateReverse,
  }) {
    assert(!_initialized, 'MaterialStateDetectorMixin should not be initialized more than once.');
    assert(onSelect == null || onPressed == null, 'May only use one of onSelect or onPressed, not both.');
    _initialized = true;
    this.controller = controller;
    this.onSelect = onSelect;
    _useOnSelect = onSelect != null;
    this.onPressed = onPressed;
    _useOnPressed = onPressed != null;
    this.selectable = selectable;
    this.animateForward = animateForward;
    this.animateReverse = animateReverse;
  }

  void onTap() {
    if (controller == null) {
      return;
    }
    Set<MaterialState> add = {};
    Set<MaterialState> remove = {};
    if (_useOnSelect || _useOnPressed) {
      if (selectable ?? true) {
        if (controller!.states.contains(MaterialState.selected)) {
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
    controller!.update(toRemove: remove, toAdd: add);
  }

  void onTapDown(TapDownDetails details) {
    if (controller == null) {
      return;
    }
    controller!..update(toAdd: {MaterialState.pressed});
  }

  void onTapCancel() {
    if (controller == null) {
      return;
    }
    controller!.update(toRemove: {MaterialState.pressed});
  }

  void onHover(bool isHovering) {
    if (controller == null) {
      return;
    }
    if (isHovering) {
      controller!.update(toAdd: {MaterialState.hovered});
    } else {
      controller!.update(toRemove: {MaterialState.hovered});
    }
  }

  void onFocusChanged(bool isFocused) {
    if (controller == null) {
      return;
    }
    if (isFocused) {
      controller!.update(toAdd: {MaterialState.focused});
    } else {
      controller!.update(toRemove: {MaterialState.focused});
    }
  }
}
