import 'package:flutter/material.dart';
import 'package:iconic_button/button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum SelectableState { oneA, oneB }

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<SelectableState> _oneNotifier =
      ValueNotifier(SelectableState.oneA);
  bool twoSelected = false;
  bool threeSelected = false;

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
    final textStyle = Theme.of(context).textTheme.caption;
    double width = iconicRowWidth(
      [labelOne, labelTwo],
      textStyle,
      MediaQuery.of(context).textScaleFactor,
      padding,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder<SelectableState>(
                valueListenable: _oneNotifier,
                builder: (context, value, _) {
                  return SizedBox(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: BaseIconicButton(
                            state: value == SelectableState.oneA
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
                                _oneNotifier.value = SelectableState.oneA,
                          ),
                        ),
                        Expanded(
                          child: BaseIconicButton(
                            state: value == SelectableState.oneB
                                ? ButtonState.selected
                                : ButtonState.unselected,
                            // controller: controllerOne,
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
                                _oneNotifier.value = SelectableState.oneB,
                          ),
                        )
                      ],
                    ),
                  );
                }),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            ColorButton(
              colorInt: Colors.deepOrange.value,
              selectable: true,
              iconData: Icons.check,
              isSelected: twoSelected,
              style: colorStyleFrom(
                fixedSize: const Size(45.0, 45.0),
                shape: const CircleBorder(),
              ),
              onPressed: () => setState(() => twoSelected = !twoSelected),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
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
              padding: EdgeInsets.only(top: 8.0),
            ),
            CardChip(
              title: 'CardChip',
              subtitle: 'Like a ListTile',
              iconData: Icons.check,
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    _oneNotifier.dispose();
    super.dispose();
  }
}
