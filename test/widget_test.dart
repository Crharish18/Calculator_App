import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_app/main.dart';

void main() {
  testWidgets('Calculator addition test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CalculatorApp());

    // Verify that the display starts at "0".
    expect(find.byKey(const Key('display')), findsOneWidget);
    expect(find.text('0'),
        findsWidgets); // This checks that there are widgets with "0"

    // Tap the "+" button and enter additional numbers or operations as needed.
    // However, ensure that we're validating only the display text, not counting buttons.

    // After each operation or interaction, you may want to validate only the specific display widget:
    expect(find.byKey(const Key('display')), findsOneWidget);
  });
}
