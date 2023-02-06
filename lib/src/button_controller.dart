import 'package:flutter/material.dart';

enum ButtonState { selected, unselected, enabled, disabled }

class ButtonController extends ValueNotifier<ButtonState> {
  ButtonController({ButtonState? value}) : super(value ?? ButtonState.enabled);
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  select() => value = ButtonState.selected;

  unSelect() => value = ButtonState.unselected;

  enable() => value = ButtonState.enabled;

  disable() => value = ButtonState.disabled;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
