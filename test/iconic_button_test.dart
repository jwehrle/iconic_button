import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconic_button/iconic_button.dart';

main() {
  testWidgets('IconicButton tap select', (tester) async {
    ThemeData theme = ThemeData();
    ButtonController controller = ButtonController();

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Material(
          child: IconicButton(
            controller: controller,
            iconData: Icons.undo,
            onPressed: () {},
            label: 'Test Label',
          ),
        ),
      ),
    );

    // Check before tap
    final beforeMaterialFinder = find.byType(IconicMaterial);
    expect(beforeMaterialFinder, findsOneWidget);
    final beforeMaterial =
        tester.widget(beforeMaterialFinder) as IconicMaterial;
    expect(beforeMaterial.elevation, kDefaultElevation);
    expect(beforeMaterial.shape, kDefaultRectangularShape);
    expect(beforeMaterial.shadowColor, kDefaultShadow);
    expect(beforeMaterial.splashFactory, kDefaultSplash);
    expect(beforeMaterial.backgroundColor, theme.primaryColor);
    final beforeContentFinder = find.byType(IconicContent);
    expect(beforeContentFinder, findsOneWidget);
    final beforeContent = tester.widget(beforeContentFinder) as IconicContent;
    expect(beforeContent.iconData, Icons.undo);
    expect(beforeContent.label, 'Test Label');
    expect(beforeContent.color, theme.colorScheme.onPrimary);
    final expectedStyle = theme.textTheme.bodySmall;
    expect(beforeContent.textStyle?.color, expectedStyle?.color);
    expect(beforeContent.textStyle?.fontFamily, expectedStyle?.fontFamily);
    expect(beforeContent.textStyle?.fontSize, 12.0);

    // Programmatically select
    controller.select();
    await tester.pumpAndSettle();

    // After tap
    final afterMaterialFinder = find.byType(IconicMaterial);
    expect(afterMaterialFinder, findsOneWidget);
    final afterMaterial = tester.widget(afterMaterialFinder) as IconicMaterial;
    expect(afterMaterial.elevation, kDefaultElevation);
    expect(afterMaterial.shape, kDefaultRectangularShape);
    expect(afterMaterial.shadowColor, kDefaultShadow);
    expect(afterMaterial.splashFactory, kDefaultSplash);
    expect(afterMaterial.backgroundColor, theme.colorScheme.onPrimary);
    final afterContentFinder = find.byType(IconicContent);
    expect(afterContentFinder, findsOneWidget);
    final afterContent = tester.widget(afterContentFinder) as IconicContent;
    expect(afterContent.iconData, Icons.undo);
    expect(afterContent.label, 'Test Label');
    expect(afterContent.color, theme.colorScheme.primary);
    expect(afterContent.textStyle?.color, expectedStyle?.color);
    expect(afterContent.textStyle?.fontFamily, expectedStyle?.fontFamily);
    expect(afterContent.textStyle?.fontSize, 12.0);

    controller.dispose();
  });

  testWidgets('BaseIconicButton tap select', (tester) async {
    ThemeData theme = ThemeData();

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Material(
          child: BaseIconicButton(
            isSelected: false,
            isEnabled: true,
            iconData: Icons.undo,
            onPressed: () {},
            label: 'Test Label',
          ),
        ),
      ),
    );

    // Check before tap
    final beforeMaterialFinder = find.byType(IconicMaterial);
    expect(beforeMaterialFinder, findsOneWidget);
    final beforeMaterial =
        tester.widget(beforeMaterialFinder) as IconicMaterial;
    expect(beforeMaterial.elevation, kDefaultElevation);
    expect(beforeMaterial.shape, kDefaultRectangularShape);
    expect(beforeMaterial.shadowColor, kDefaultShadow);
    expect(beforeMaterial.splashFactory, kDefaultSplash);
    expect(beforeMaterial.backgroundColor, theme.primaryColor);
    final beforeContentFinder = find.byType(IconicContent);
    expect(beforeContentFinder, findsOneWidget);
    final beforeContent = tester.widget(beforeContentFinder) as IconicContent;
    expect(beforeContent.iconData, Icons.undo);
    expect(beforeContent.label, 'Test Label');
    expect(beforeContent.color, theme.colorScheme.onPrimary);
    final expectedStyle = theme.textTheme.bodySmall;
    expect(beforeContent.textStyle?.color, expectedStyle?.color);
    expect(beforeContent.textStyle?.fontFamily, expectedStyle?.fontFamily);
    expect(beforeContent.textStyle?.fontSize, 12.0);

    // Tap button
    final buttonFinder = find.byType(BaseIconicButton);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // After tap
    final afterMaterialFinder = find.byType(IconicMaterial);
    expect(afterMaterialFinder, findsOneWidget);
    final afterMaterial = tester.widget(afterMaterialFinder) as IconicMaterial;
    expect(afterMaterial.elevation, kDefaultElevation);
    expect(afterMaterial.shape, kDefaultRectangularShape);
    expect(afterMaterial.shadowColor, kDefaultShadow);
    expect(afterMaterial.splashFactory, kDefaultSplash);
    expect(afterMaterial.backgroundColor, theme.colorScheme.onPrimary);
    final afterContentFinder = find.byType(IconicContent);
    expect(afterContentFinder, findsOneWidget);
    final afterContent = tester.widget(afterContentFinder) as IconicContent;
    expect(afterContent.iconData, Icons.undo);
    expect(afterContent.label, 'Test Label');
    expect(afterContent.color, theme.colorScheme.primary);
    expect(afterContent.textStyle?.color, expectedStyle?.color);
    expect(afterContent.textStyle?.fontFamily, expectedStyle?.fontFamily);
    expect(afterContent.textStyle?.fontSize, 12.0);
  });

  testWidgets('ColorButton tap select', (tester) async {
    ThemeData theme = ThemeData();

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Material(
          child: ColorButton(
            color: Colors.amber,
            selectable: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Check before tap
    final beforeMaterialFinder = find.byType(IconicMaterial);
    expect(beforeMaterialFinder, findsOneWidget);
    final beforeMaterial =
        tester.widget(beforeMaterialFinder) as IconicMaterial;
    expect(beforeMaterial.elevation, kDefaultElevation);
    expect(beforeMaterial.shape, kDefaultCircularShape);
    expect(beforeMaterial.shadowColor, kDefaultShadow);
    expect(beforeMaterial.splashFactory, kDefaultSplash);
    expect(beforeMaterial.backgroundColor, Colors.amber);
    final beforeIconFinder = find.byType(Icon);
    expect(beforeIconFinder, findsNothing);

    // Tap button
    final buttonFinder = find.byType(ColorButton);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // After tap
    final afterIconFinder = find.byType(Icon);
    expect(afterIconFinder, findsOneWidget);
    final icon = tester.widget(afterIconFinder) as Icon;
    expect(icon.color, Colors.white);
    expect(icon.icon, Icons.check);
    final afterMaterialFinder = find.byType(IconicMaterial);
    expect(afterMaterialFinder, findsOneWidget);
    final afterMaterial = tester.widget(afterMaterialFinder) as IconicMaterial;
    expect(afterMaterial.elevation, kDefaultElevation);
    expect(afterMaterial.shape, kDefaultCircularShape);
    expect(afterMaterial.shadowColor, kDefaultShadow);
    expect(afterMaterial.splashFactory, kDefaultSplash);
    expect(afterMaterial.backgroundColor, Colors.amber);
  });

  testWidgets('IconicChip tap select', (tester) async {
    ThemeData theme = ThemeData();

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Material(
          child: IconicChip(
            label: 'Test IconicChip',
            selectable: true,
            isSelected: false,
            onPressed: (value) {},
          ),
        ),
      ),
    );

    // Check before tap
    final beforeMaterialFinder = find.byType(IconicMaterial);
    expect(beforeMaterialFinder, findsOneWidget);
    final beforeMaterial =
        tester.widget(beforeMaterialFinder) as IconicMaterial;
    expect(beforeMaterial.elevation, 1.0);
    expect(beforeMaterial.shape, StadiumBorder());
    expect(beforeMaterial.shadowColor, kDefaultShadow);
    expect(beforeMaterial.splashFactory, kDefaultSplash);
    final beforeFadeFinder = find.byType(FadeTransition);
    expect(beforeFadeFinder, findsOneWidget);
    final beforeFade = tester.widget(beforeFadeFinder) as FadeTransition;
    expect(beforeFade.opacity.value, 0.0);

    // Tap button
    final buttonFinder = find.byType(IconicChip);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // After tap
    final afterFadeFinder = find.byType(FadeTransition);
    expect(afterFadeFinder, findsOneWidget);
    final afterFade = tester.widget(afterFadeFinder) as FadeTransition;
    expect(afterFade.opacity.value, 1.0);
    final afterIconFinder = find.byType(Icon);
    expect(afterIconFinder, findsOneWidget);
    final icon = tester.widget(afterIconFinder) as Icon;
    expect(icon.icon, Icons.check);
    final afterMaterialFinder = find.byType(IconicMaterial);
    expect(afterMaterialFinder, findsOneWidget);
    final afterMaterial = tester.widget(afterMaterialFinder) as IconicMaterial;
    expect(afterMaterial.elevation, 1.0);
    expect(afterMaterial.shape, StadiumBorder());
    expect(afterMaterial.shadowColor, kDefaultShadow);
    expect(afterMaterial.splashFactory, kDefaultSplash);
  });

  testWidgets('CardChip tap select', (tester) async {

    ThemeData theme = ThemeData();

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Material(
          child: CardChip(
            title: 'Test CardChip',
            leadingSwitch: SwitchIcons(
              unSelected: Icons.check_box_outline_blank,
              selected: Icons.check_box,
            ),
            isSelected: false,
            onPressed: (value) {},
            actions: [Text('one'), Text('two')],
          ),
        ),
      ),
    );

    // Check before tap
    final beforeMaterialFinder = find.byType(IconicMaterial);
    expect(beforeMaterialFinder, findsOneWidget);
    final beforeMaterial =
        tester.widget(beforeMaterialFinder) as IconicMaterial;
    expect(beforeMaterial.elevation, 1.0);
    expect(beforeMaterial.shape, kDefaultRectangularShape);
    expect(beforeMaterial.shadowColor, kDefaultShadow);
    expect(beforeMaterial.splashFactory, kDefaultSplash);
    expect(beforeMaterial.backgroundColor, theme.cardColor);
    final beforeSizeFinder = find.byType(SizeTransition);
    expect(beforeSizeFinder, findsOneWidget);
    final beforeSize = tester.widget(beforeSizeFinder) as SizeTransition;
    expect(beforeSize.sizeFactor.value, 0.0);
    final beforeIconFinder = find.byType(Icon);
    expect(beforeIconFinder, findsOneWidget);
    final beforeIcon = tester.widget(beforeIconFinder) as Icon;
    expect(beforeIcon.icon, Icons.check_box_outline_blank);

    // Tap button
    final buttonFinder = find.byType(CardChip);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // After tap
    final afterSizeFinder = find.byType(SizeTransition);
    expect(afterSizeFinder, findsOneWidget);
    final afterSize = tester.widget(afterSizeFinder) as SizeTransition;
    expect(afterSize.sizeFactor.value, 1.0);
    final afterIconFinder = find.byType(Icon);
    expect(afterIconFinder, findsOneWidget);
    final afterIcon = tester.widget(afterIconFinder) as Icon;
    expect(afterIcon.icon, Icons.check_box);
    final afterMaterialFinder = find.byType(IconicMaterial);
    expect(afterMaterialFinder, findsOneWidget);
    final afterMaterial = tester.widget(afterMaterialFinder) as IconicMaterial;
    expect(afterMaterial.elevation, 1.0);
    expect(afterMaterial.shape, kDefaultRectangularShape);
    expect(afterMaterial.shadowColor, kDefaultShadow);
    expect(afterMaterial.splashFactory, kDefaultSplash);
  });
}
