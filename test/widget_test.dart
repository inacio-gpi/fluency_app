import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/main.dart';

void main() {
  testWidgets('Fluency app smoke test', (WidgetTester tester) async {
    // This is a placeholder test.
    // Implement actual widget tests based on your app's functionality.
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FluencyApp());

    // Verify that the app builds without errors.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
