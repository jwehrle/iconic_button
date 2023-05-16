# iconic_button

An alternative to Flutter ToggleButtons which supports modular selectable button usage without having to know the size
of the button or having to group buttons. These buttons focus on icons with optional labels in chips, expansion tiles 
and simple buttons. Additionally, this package exposes a controller to programmatically enable, disable, select or
unselect buttons without calling setState().

This package uses ButtonStyles, MaterialStates, and InkWell to follow Material Design themes but is extremely 
customizable and is based loosely on the ElevatedButton.

What this button offers:

1 Optionally labeled icons. Icons are great but on their own can be mystifying. Built in tool tips. Implicit animations.
Default built-ins for Material and InkWell parameters that make reactive designs easier.

2 Selection and disabling methods which give direct, explicit control over button states.

3 Resettable properties: Icon, label, and style can be changed in reaction to your own custom events.

This package was built to serve needs I have found in other projects of mine. I am making it available publicly as I
have benefited from the hard work of others.

## Usage

    //Import
    import 'package:iconic_button/iconic_button.dart';

    // For IconicButton make a controller 
    final ButtonController controller = ButtonController();
    
    // Add listener
    IconicButton(
        controller: controller,
        iconData: Icons.undo,
        onPressed: () {},
        label: 'Label',
    )

    // To change the state of the button, use the controller
    controller.select();
    controller.unSelect();
    controller.enable();
    controller.disable();

    // Remember to dispose just as you would for a ValueNotifier
    listNotifier.dispose();

## Installing

    flutter pub add iconic_button

## Repository (Github)

[https://github.com/jwehrle/iconic_button.git](https://github.com/jwehrle/iconic_button.git)