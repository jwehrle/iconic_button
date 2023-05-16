import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconic_button/iconic_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iconic Button Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Iconic Button Package'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum SelectableState { oneA, oneB }

class _MyHomePageState extends State<MyHomePage> {
  bool twoSelected = false;
  bool threeSelected = false;
  bool halfAndHalfSelected = false;
  bool isLabelOne = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Color backgroundColor = isDark ? Colors.grey.shade700 : Colors.white;
    Color outlineColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;
    Color selectedColor = isDark ? Colors.grey.shade500 : Colors.grey.shade300;
    Color textColor = isDark ? Colors.white : Colors.black87;
    String labelOne = 'Label';
    String labelTwo = 'Longer Label';
    const padding = EdgeInsets.all(8.0);
    const spacing = EdgeInsets.only(top: 32.0);
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final labelStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text('HalfAndHalfColorButton', style: labelStyle),
              ),
              HalfAndHalfColorButton(
                startColor: Colors.black87,
                endColor: Colors.white,
                iconStartColor: Colors.white,
                iconEndColor: Colors.black87,
                selectable: true,
                iconData: Icons.check,
                isSelected: halfAndHalfSelected,
                onPressed: () =>
                    setState(() => halfAndHalfSelected = !halfAndHalfSelected),
                style: colorStyleFrom(
                  fixedSize: const Size(45.0, 45.0),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                ),
              ),
              const Padding(
                padding: spacing,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Text(
                  'Row of BaseIconicButton, one with a notification dot',
                  style: labelStyle,
                ),
              ),
              SizedBox(
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: BaseIconicButton(
                          showAlertDot: true,
                          alertDotColor: Colors.deepOrange,
                          state: isLabelOne
                              ? ButtonState.selected
                              : ButtonState.unselected,
                          iconData: Icons.label,
                          label: labelOne,
                          style: selectableStyleFrom(
                            textStyle: textStyle,
                            primary: theme.primaryColor,
                            onPrimary: theme.colorScheme.onPrimary,
                            onSurface: theme.colorScheme.onSurface,
                            padding: padding,
                            elevation: 2.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                bottomLeft: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          onPressed: () =>
                              setState(() => isLabelOne = !isLabelOne),
                        ),
                      ),
                      Expanded(
                        child: BaseIconicButton(
                          state: !isLabelOne
                              ? ButtonState.selected
                              : ButtonState.unselected,
                          iconData: Icons.label,
                          label: labelTwo,
                          style: selectableStyleFrom(
                            textStyle: textStyle,
                            primary: theme.primaryColor,
                            onPrimary: theme.colorScheme.onPrimary,
                            onSurface: theme.colorScheme.onSurface,
                            padding: padding,
                            elevation: 2.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4.0),
                                bottomRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          onPressed: () =>
                              setState(() => isLabelOne = !isLabelOne),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: spacing,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text('ColorButton', style: labelStyle),
              ),
              ColorButton(
                color: Colors.deepOrange,
                selectable: true,
                iconData: Icons.check,
                isSelected: twoSelected,
                style: colorStyleFrom(
                  fixedSize: const Size(45.0, 45.0),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                ),
                onPressed: () => setState(() => twoSelected = !twoSelected),
              ),
              const Padding(
                padding: spacing,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text('IconicChip', style: labelStyle),
              ),
              IconicChip(
                label: 'IconicChip',
                style: chipStyleFrom(
                  textStyle: TextStyle(color: textColor),
                  backgroundColor: backgroundColor,
                  selectedColor: selectedColor,
                  padding: const EdgeInsets.all(4.0),
                ),
                labelPadding: const EdgeInsets.all(4.0),
                avatar: const CircleAvatar(
                  radius: 22.5,
                  backgroundColor: Colors.teal,
                ),
                iconColor: Colors.white,
                selectable: true,
                isSelected: threeSelected,
                onPressed: (selected) {},
              ),
              const Padding(
                padding: spacing,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text('CardChip', style: labelStyle),
              ),
              SizedBox(
                child: IntrinsicWidth(
                  child: CardChip(
                    title: 'CardChip',
                    subtitle: 'Like a ListTile, with IconicChip options',
                    selectedIconData: Icons.check_box_outlined,
                    unSelectedIconData: Icons.check_box_outline_blank,
                    labelPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    style: chipStyleFrom(
                      textStyle: TextStyle(color: textColor),
                      backgroundColor: backgroundColor,
                      selectedColor: selectedColor,
                      defaultElevation: 2.0,
                      pressedElevation: 6.0,
                      padding: const EdgeInsets.all(4.0),
                    ),
                    onPressed: (selected) {},
                    choices: [
                      IconicChip(
                        label: 'Option A',
                        outlineColor: outlineColor,
                        style: chipStyleFrom(
                          textStyle: TextStyle(color: textColor),
                          backgroundColor: backgroundColor,
                          selectedColor: selectedColor,
                          padding: const EdgeInsets.all(4.0),
                        ),
                        labelPadding: const EdgeInsets.all(4.0),
                        selectable: true,
                        onPressed: (selected) {
                          setState(() {
                            threeSelected = selected;
                          });
                        },
                        onLongPress: () {
                          if (kDebugMode) {
                            print('A long pressed');
                          }
                        },
                      ),
                      IconicChip(
                        label: 'Option B',
                        outlineColor: outlineColor,
                        style: chipStyleFrom(
                          textStyle: TextStyle(color: textColor),
                          backgroundColor: backgroundColor,
                          selectedColor: selectedColor,
                          padding: const EdgeInsets.all(4.0),
                        ),
                        labelPadding: const EdgeInsets.all(4.0),
                        selectable: true,
                        onPressed: (selected) {},
                        onLongPress: () {
                          if (kDebugMode) {
                            print('B long pressed');
                          }
                        },
                      ),
                      IconicChip(
                        label: 'Option C',
                        outlineColor: outlineColor,
                        style: chipStyleFrom(
                          textStyle: TextStyle(color: textColor),
                          backgroundColor: backgroundColor,
                          selectedColor: selectedColor,
                          padding: const EdgeInsets.all(4.0),
                        ),
                        labelPadding: const EdgeInsets.all(4.0),
                        selectable: true,
                        onPressed: (selected) {},
                        onLongPress: () {
                          if (kDebugMode) {
                            print('C long pressed');
                          }
                        },
                      ),
                      IconicChip(
                        label: 'Option D',
                        outlineColor: outlineColor,
                        style: chipStyleFrom(
                          textStyle: TextStyle(color: textColor),
                          backgroundColor: backgroundColor,
                          selectedColor: selectedColor,
                          padding: const EdgeInsets.all(4.0),
                        ),
                        labelPadding: const EdgeInsets.all(4.0),
                        selectable: true,
                        onPressed: (selected) {},
                        onLongPress: () {
                          if (kDebugMode) {
                            print('D long pressed');
                          }
                        },
                      ),
                      IconicChip(
                        label: 'Option E',
                        outlineColor: outlineColor,
                        style: chipStyleFrom(
                          textStyle: TextStyle(color: textColor),
                          backgroundColor: backgroundColor,
                          selectedColor: selectedColor,
                          padding: const EdgeInsets.all(4.0),
                        ),
                        labelPadding: const EdgeInsets.all(4.0),
                        selectable: true,
                        onPressed: (selected) {},
                        onLongPress: () {
                          if (kDebugMode) {
                            print('E long pressed');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 16.0))
            ],
          ),
        ),
      ),
    );
  }
}
