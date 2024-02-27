// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:digital_calculator/main.dart';

void main() {
  testWidgets('Addition Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalCalculatorApp());

    // Tap the 6 Digit Button
    await tester.tap(find.text("6"));
    await tester.pump();

    // Tap the 2 Digit Button
    await tester.tap(find.text("2"));
    await tester.pump();

    // Tap the Addition Button
    await tester.tap(find.text("+"));
    await tester.pump();

    // Tap the 2 Digit Button
    await tester.tap(find.text("7"));
    await tester.pump();

    // Tap the Equals Button
    await tester.tap(find.text("="));
    await tester.pump();

    // Verify that addition is successful
    expect(find.text('69'), findsOneWidget);
  });

  testWidgets('Subtraction Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalCalculatorApp());

    // Tap the 4 Digit Button
    await tester.tap(find.text("4"));
    await tester.pump();

    // Tap the 2 Digit Button
    await tester.tap(find.text("2"));
    await tester.pump();

    // Tap the 0 Digit Button
    await tester.tap(find.text("0"));
    await tester.pump();

    // Tap the Subtraction Button
    await tester.tap(find.text("-"));
    await tester.pump();

    // Tap the 3 Digit Button
    await tester.tap(find.text("3"));
    await tester.pump();

    // Tap the 5 Digit Button
    await tester.tap(find.text("5"));
    await tester.pump();

    // Tap the 1 Digit Button
    await tester.tap(find.text("1"));
    await tester.pump();

    // Tap the Equals Button
    await tester.tap(find.text("="));
    await tester.pump();

    // Verify that subtraction is successful
    expect(find.text('69'), findsOneWidget);
  });

  testWidgets('Multiplication Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalCalculatorApp());

    // Tap the 2 Digit Button
    await tester.tap(find.text("2"));
    await tester.pump();

    // Tap the 3 Digit Button
    await tester.tap(find.text("3"));
    await tester.pump();

    // Tap the Multiplication Button
    await tester.tap(find.text("X"));
    await tester.pump();

    // Tap the 3 Digit Button
    await tester.tap(find.text("3"));
    await tester.pump();

    // Tap the Equals Button
    await tester.tap(find.text("="));
    await tester.pump();

    // Verify that multiplication is successful
    expect(find.text('69'), findsOneWidget);
  });

  testWidgets('Division Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalCalculatorApp());

    // Tap the 2 Digit Button
    await tester.tap(find.text("2"));
    await tester.pump();

    // Tap the 7 Digit Button
    await tester.tap(find.text("7"));
    await tester.pump();

    // Tap the 6 Digit Button
    await tester.tap(find.text("6"));
    await tester.pump();

    // Tap the Division Button
    await tester.tap(find.text("÷"));
    await tester.pump();

    // Tap the 4 Digit Button
    await tester.tap(find.text("4"));
    await tester.pump();

    // Tap the Equals Button
    await tester.tap(find.text("="));
    await tester.pump();

    // Verify that division is successful
    expect(find.text('69'), findsOneWidget);
  });

  testWidgets('Percentage Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalCalculatorApp());

    // Tap the 6 Digit Button
    await tester.tap(find.text("6"));
    await tester.pump();

    // Tap the 9 Digit Button
    await tester.tap(find.text("9"));
    await tester.pump();

    // Tap the Percentage Digit Button
    await tester.tap(find.text("%"));
    await tester.pump();

    // Tap the Equals Button
    await tester.tap(find.text("="));
    await tester.pump();

    // Verify that percentage function is successful
    expect(find.text('0.69'), findsOneWidget);
  });

  testWidgets('Clear Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalCalculatorApp());

    // Tap the 6 Digit Button
    await tester.tap(find.text("6"));
    await tester.pump();

    // Tap the 9 Digit Button
    await tester.tap(find.text("9"));
    await tester.pump();

    expect(find.text("69"), findsOneWidget);

    // Tap the All Clear Button
    await tester.tap(find.text("C"));
    await tester.pump();

    expect(find.text('6'), findsExactly(2));
  });

  testWidgets('All Clear Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalCalculatorApp());

    // Tap the 6 Digit Button
    await tester.tap(find.text("6"));
    await tester.pump();

    // Tap the 9 Digit Button
    await tester.tap(find.text("9"));
    await tester.pump();

    expect(find.text("69"), findsOneWidget);

    // Hold the Clear Button
    await tester.longPress(find.text("C"));
    await tester.pump();

    expect(find.text('0'), findsExactly(2));
  });

  testWidgets('Sign Change Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalCalculatorApp());

    // Tap the 6 Digit Button
    await tester.tap(find.text("6"));
    await tester.pump();

    // Tap the 9 Digit Button
    await tester.tap(find.text("9"));
    await tester.pump();

    expect(find.text("69"), findsOneWidget);

    // Tap the Sign Change Button
    await tester.tap(find.text("+/-"));
    await tester.pump();

    expect(find.text('-69'), findsOneWidget);
  });
}
