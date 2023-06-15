import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconic_button/iconic_button.dart';

const kDefaultMediumPadding = EdgeInsets.all(8.0);

const String iconicButtonDescription = '''
A toggle-like button that uses an icon and an optional label and customizable styling. This primary version of the button uses a controller which is handy when you need to control button states selection or enabled. (Rocket icon is just random.)''';
const String baseIconicButtonDescription = '''
BaseIconicButton is the base class used by IconicButton and has no controller.
This Row of BaseIconicButtons is set up like radio buttons with one showing a notification dot.''';
const String colorButtonDescription = '''
A toggle-like circular button with optional icon - great for selecting a color.''';
const String halfDescription = '''
I made this strange version of a CircularButton because I had a peculiar use case. Maybe it will be helpful for others.''';
const String iconicChipDescription = '''
A toggle-like version of Chip with optional icon (permanent or dynamic) and optional long press.''';
const String card1Desc =
    '''A toggle-like, expanding Card with optional icons. This example contains: leading SwitchIcon, a trailing SpinIcon, and IconicChip actions.''';
const String card2Desc =
    '''This example contains: trailing SwitchIcon with a null unselected icon, no leading icon, and IconicChip actions.''';
const String card3Desc =
    '''This example contains: a leading SpinIcon, no trailing icon, and IconicChip actions.''';
const String card4Desc =
    '''This example contains: no leading icon, no trailing icon, and IconicChip actions.''';

/// Example colors encapsulated for convenience
class ExampleColors {
  late final Color chipBackground;
  late final Color cardBackground;
  late final Color chipSelected;
  late final Color cardSelected;
  late final Color foreground;

  ExampleColors(bool isDark) {
    chipBackground = isDark ? Colors.grey.shade700 : Colors.white;
    cardBackground = isDark ? Colors.grey.shade800 : Colors.white;
    chipSelected = isDark ? Colors.grey.shade600 : Colors.grey.shade300;
    cardSelected = isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    foreground = isDark ? Colors.white : Colors.black87;
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Change to play around
  final bool isDark = false;

  @override
  Widget build(BuildContext context) {
    // Use your own colors. This is just an example.
    ExampleColors exampleColors = ExampleColors(isDark);
    return MaterialApp(
      title: 'Iconic Button Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
          listTileTheme:
              const ListTileThemeData(contentPadding: kDefaultMediumPadding),
          primarySwatch: Colors.blue,
          extensions: [
            IconicButtonTheme(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
              padding: kDefaultMediumPadding,
              elevation: 2.0,
            ),
            ColorButtonTheme(),
            IconicChipTheme(
              background: exampleColors.chipBackground,
              selected: exampleColors.chipSelected,
              foreground: exampleColors.foreground,
            ),
            IconicCardTheme(
              background: exampleColors.cardBackground,
              selected: exampleColors.cardSelected,
              foreground: exampleColors.foreground,
            ),
          ]),
      home: const MyHomePage(title: 'Iconic Button Package'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Examples(),
          ),
        ),
      ),
    );
  }
}

class Examples extends StatelessWidget {
  const Examples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        IconicButtonExample(),
        BasicExample(),
        ColorExample(),
        ChipExample(),
        CardExample(),
      ],
    );
  }
}

/// Example of [IconicButton]
class IconicButtonExample extends StatefulWidget {
  const IconicButtonExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => IconicButtonExampleState();
}

class IconicButtonExampleState extends State<IconicButtonExample> {
  final ButtonController _iconicController = ButtonController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: kDefaultMediumPadding,
        child: Column(
          children: [
            const ListTile(
              title: Text('IconicButton'),
              subtitle: Text(iconicButtonDescription),
            ),
            Row(
              children: [
                IconicButton(
                  controller: _iconicController,
                  iconData: Icons.rocket_launch,
                  label: "Tap To Select",
                  onPressed: () {},
                ),
                Flexible(
                  child: IconicExampleSwitches(
                    iconicController: _iconicController,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _iconicController.dispose();
    super.dispose();
  }
}

class IconicExampleSwitches extends StatelessWidget {
  final ButtonController iconicController;

  const IconicExampleSwitches({
    Key? key,
    required this.iconicController,
  }) : super(key: key);

  void _onSelectChanged(value) {
    if (value != iconicController.isSelected) {
      if (value) {
        iconicController.select();
      } else {
        iconicController.unSelect();
      }
    }
  }

  void _onEnableChanged(value) {
    if (value != iconicController.isEnabled) {
      if (value) {
        iconicController.enable();
      } else {
        iconicController.disable();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SetListenableBuilder(
      valueListenable: iconicController,
      builder: (context, set, _) {
        return Column(
          children: [
            SwitchListTile(
              value: set.contains(ButtonState.selected),
              onChanged: _onSelectChanged,
              title: const Text('Select/Unselect:'),
              dense: true,
            ),
            SwitchListTile(
              value: set.contains(ButtonState.enabled),
              onChanged: _onEnableChanged,
              title: const Text('Enable/Disable:'),
              dense: true,
            )
          ],
        );
      },
    );
  }
}

/// Example of [BaseIconicButton]
class BasicExample extends StatelessWidget {
  const BasicExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: kDefaultMediumPadding,
        child: Column(
          children: [
            ListTile(
              title: Text('BaseIconicButton'),
              subtitle: Text(baseIconicButtonDescription),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: SizedBox(
                child: IntrinsicWidth(
                  child: BasicExampleRow(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BasicExampleRow extends StatefulWidget {
  const BasicExampleRow({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BasicExampleRowState();
}

class BasicExampleRowState extends State<BasicExampleRow> {
  final ValueNotifier<bool> isLeftSelected = ValueNotifier(true);

  void toggle() => isLeftSelected.value = !isLeftSelected.value;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLeftSelected,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: BasicExampleButton(
                isLeft: true,
                isSelected: value,
                showDot: true,
                toggle: toggle,
              ),
            ),
            Expanded(
              child: BasicExampleButton(
                isLeft: false,
                isSelected: !value,
                toggle: toggle,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    isLeftSelected.dispose();
    super.dispose();
  }
}

class BasicExampleButton extends StatelessWidget {
  final bool isLeft;
  final bool isSelected;
  final VoidCallback toggle;
  final bool showDot;

  const BasicExampleButton({
    Key? key,
    required this.isLeft,
    required this.isSelected,
    required this.toggle,
    this.showDot = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseIconicButton(
      showAlertDot: showDot,
      alertDotColor: Colors.deepOrange,
      isSelected: isSelected,
      isEnabled: true,
      iconData: Icons.label,
      label: isLeft ? 'Left Button' : 'Right Button',
      shape: RoundedRectangleBorder(
        borderRadius: isLeft
            ? const BorderRadius.only(
          topLeft: Radius.circular(4.0),
          bottomLeft: Radius.circular(4.0),
        )
            : const BorderRadius.only(
          topRight: Radius.circular(4.0),
          bottomRight: Radius.circular(4.0),
        ),
      ),
      onPressed: toggle,
    );
  }
}

/// Example of [ColorButton] and [HalfAndHalfColorButton]
class ColorExample extends StatefulWidget {
  const ColorExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ColorExampleState();
}

class ColorExampleState extends State<ColorExample> {
  bool _isColorSelected = false;
  bool _isHalfSelected = false;

  void toggleColor() => setState(() => _isColorSelected = !_isColorSelected);

  void toggleHalf() => setState(() => _isHalfSelected = !_isHalfSelected);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: kDefaultMediumPadding,
        child: Column(
          children: [
            ListTile(
              leading: ColorButton(
                color: Colors.deepOrange,
                iconData: Icons.check,
                isSelected: _isColorSelected,
                onPressed: toggleColor,
              ),
              title: const Text('ColorButton'),
              subtitle: const Text(colorButtonDescription),
            ),
            ListTile(
              leading: HalfAndHalfColorButton(
                startColor: Colors.black87,
                endColor: Colors.white,
                iconStartColor: Colors.white,
                iconEndColor: Colors.black87,
                iconData: Icons.check,
                isSelected: _isHalfSelected,
                onPressed: toggleHalf,
              ),
              title: const Text('HalfAndHalfColorButton'),
              subtitle: const Text(halfDescription),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of [IconicChip]
class ChipExample extends StatelessWidget {
  const ChipExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: IconicChip(
                label: 'IconicChip',
                avatar: const CircleAvatar(),
                iconColor: Colors.white,
                selectable: true,
                onPressed: (selected) {},
              ),
              title: const Text('IconicChip'),
              subtitle: const Text(iconicChipDescription),
            ),
          ],
        ),
      ),
    );
  }
}

/// Examples of [CardChip]
class CardExample extends StatelessWidget {
  const CardExample({Key? key}) : super(key: key);

  List<Widget> _makeCardChipActions(int numChips) {
    List<Widget> chips = [];
    for (int i = 0; i < numChips; i++) {
      chips.add(
        IconicChip(
          label: 'Option ${i + 1}',
          selectable: true,
          background: Colors.cyan,
          selected: Colors.cyanAccent,
          onPressed: (selected) {
            if (kDebugMode) {
              print(
                  'IconicChip ${i + 1} is ${selected ? 'selected' : 'not selected'}');
            }
          },
        ),
      );
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardChip(
          title: 'CardChip',
          subtitle: card1Desc,
          leadingSwitch: SwitchIcons(
            unSelected: Icons.check_box_outline_blank,
            selected: Icons.check_box_outlined,
          ),
          trailingSpin: Icons.expand_more_rounded,
          onPressed: (selected) {},
          actions: _makeCardChipActions(3),
        ),
        CardChip(
          title: 'CardChip Variations',
          subtitle: card2Desc,
          trailingSwitch: SwitchIcons(selected: Icons.check),
          onPressed: (selected) {},
          actions: _makeCardChipActions(4),
        ),
        CardChip(
          title: 'CardChip Variations',
          subtitle: card3Desc,
          leadingSpin: Icons.expand_more_rounded,
          onPressed: (selected) {},
          actions: _makeCardChipActions(5),
        ),
        CardChip(
          title: 'CardChip Variations',
          subtitle: card4Desc,
          onPressed: (selected) {},
          actions: _makeCardChipActions(6),
        ),
      ],
    );
  }
}