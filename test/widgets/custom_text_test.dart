
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brill_prime/ui/widgets/custom_text.dart';

void main() {
  group('CustomText Widget Tests', () {
    testWidgets('should display text correctly', (WidgetTester tester) async {
      const testText = 'Hello World';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomText(text: testText),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('should apply custom style correctly', (WidgetTester tester) async {
      const testText = 'Styled Text';
      const textStyle = TextStyle(fontSize: 20, color: Colors.red);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomText(
              text: testText,
              style: textStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text(testText));
      expect(textWidget.style?.fontSize, 20);
      expect(textWidget.style?.color, Colors.red);
    });
  });
}
