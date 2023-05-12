import 'package:flutter/material.dart';

enum ButtonState { selected, unselected, enabled, disabled }

/// Controls the [ButtonState] of an [IconicButton]. Created primarily
/// because MaterialStates do not contain a state for selection vs
/// unselected and because I needed a systematic way to modify the
/// state of buttons.
class ButtonController extends ValueNotifier<ButtonState> {
  /// Creates a [ButtonController] with an optional [ButtonState] which
  /// defaults to enabled if none is provided. As this class extends
  /// [ValueNotifier] it can be listened to and used in [ValueListenableBuilder]
  ButtonController({ButtonState? value}) : super(value ?? ButtonState.enabled);

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  /// Convenience function for setting value to selected
  select() {
    if (!_isDisposed) {
      value = ButtonState.selected;
    }
  }

  /// Convenience function for setting value to unselected
  unSelect() {
    if (!_isDisposed) {
      value = ButtonState.unselected;
    }
  }

  /// Convenience function for setting value to enabled
  enable() {
    if (!_isDisposed) {
      value = ButtonState.enabled;
    }
  }

  /// Convenience function for setting value to disabled
  disable() {
    if (!_isDisposed) {
      value = ButtonState.disabled;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
