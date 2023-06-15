import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/material.dart';

/// States used by [ButtonController] to track and notify [IconicButton]
enum ButtonState { selected, enabled }

/// Controls the [ButtonState] of an [IconicButton]. Created primarily
/// because MaterialStates do not contain a state for selection vs
/// unselected and because I needed a systematic way to modify the
/// state of buttons.
class ButtonController extends SetNotifier<ButtonState> {
  /// Creates a [ButtonController] with an optional [ButtonState] which
  /// defaults to enabled if none is provided. As this class extends
  /// [ValueNotifier] it can be listened to and used in [ValueListenableBuilder]
  ButtonController({Set<ButtonState>? value}) : super(value ?? <ButtonState>{ButtonState.enabled});

  /// Private safety flag to prevent modification after disposal.
  bool _isDisposed = false;

  /// Whether this controller has been disposed.
  bool get isDisposed => _isDisposed;

  /// Whether this controller's underlying Set contains ButtonState.selected
  bool get isSelected => contains(ButtonState.selected);

  /// Whether this controller's underlying Set contains ButtonState.enabled
  bool get isEnabled => contains(ButtonState.enabled);

  /// Adds ButtonState.selected to this controller's underlying Set and
  /// notifies listeners if ButtonState.selected was not already present.
  select() {
    if (!_isDisposed) {
      add(ButtonState.selected);
    }
  }

  /// Removes ButtonState.selected from this controller's underlying Set and
  /// notifies listeners if ButtonState.selected was present.
  unSelect() {
    if (!_isDisposed) {
      remove(ButtonState.selected);
    }
  }

  /// Adds ButtonState.enabled to this controller's underlying Set and
  /// notifies listeners if ButtonState.enabled was not already present.
  enable() {
    if (!_isDisposed) {
      add(ButtonState.enabled);
    }
  }

  /// Removes ButtonState.enabled from this controller's underlying Set and
  /// notifies listeners if ButtonState.enabled was present.
  disable() {
    if (!_isDisposed) {
      remove(ButtonState.enabled);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
