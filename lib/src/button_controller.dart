import 'package:flutter/material.dart';

enum ButtonState { selected, unselected, enabled, disabled }

class ButtonController extends ValueNotifier<ButtonState> {
  ButtonController({ButtonState? value}) : super(value ?? ButtonState.enabled);
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  select() {
    if (!_isDisposed) {
      value = ButtonState.selected;
    }
  }

  unSelect() {
    if (!_isDisposed) {
      value = ButtonState.unselected;
    }
  }

  enable() {
    if (!_isDisposed) {
      value = ButtonState.enabled;
    }
  }

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
