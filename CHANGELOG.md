## 1.2.0

* Upgraded to Flutter 3.10.5 and Dart 3.0.5
* Breaking Change: ButtonState enum which now only has selected and enabled
* Breaking Change: ButtonController now extends SetNotifier based on a Set<ButtonState>
* Breaking Change: There are no more top level ButtonStyle returning Functions in style.dart. Instead, Each type of button in this package has a theme extension. Please example for usage.
* Breaking Change: Buttons no longer accept ButtonStyle parameters. Instead, pass individual style elements that you want to change from your theme. Please see example for usage.

## 1.0.1

* Upgraded example Gradle to 7.3.0

## 1.0.0

* Updated to Flutter 3.10.4 and Dart 3.0.3.
* Upgraded collection_value_notifier dependency 

## 0.0.3

* Added a gif of example app to README along with a bit more information.

## 0.0.2

* Added unit tests and improved readability of example.

## 0.0.1

* Toggle-like icon-based modular buttons, chips, expansion cards, which simplify button usage that conforms to Material Design themes.
