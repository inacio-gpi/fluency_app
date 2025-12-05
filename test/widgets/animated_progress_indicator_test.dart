import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/core/presentation/widgets/animated_progress_indicator.dart';

void main() {
  group('AnimatedProgressIndicator Widget', () {
    testWidgets('should render correctly with given progress',
        (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedProgressIndicator(
              progress: 0.5,
              progressColor: Colors.blue,
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(AnimatedProgressIndicator), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display correct percentage text',
        (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedProgressIndicator(
              progress: 0.75,
              progressColor: Colors.blue,
            ),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();

      // assert
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('should animate progress change',
        (WidgetTester tester) async {
      // arrange
      double progress = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AnimatedProgressIndicator(
                      progress: progress,
                      progressColor: Colors.blue,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          progress = 1.0;
                        });
                      },
                      child: const Text('Update'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // act
      await tester.tap(find.text('Update'));
      await tester.pump();

      // assert - animation should be in progress
      expect(find.byType(AnimatedProgressIndicator), findsOneWidget);

      // Complete animation
      await tester.pumpAndSettle();
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('should use custom colors', (WidgetTester tester) async {
      // arrange
      const testColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedProgressIndicator(
              progress: 0.5,
              progressColor: testColor,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
            ),
          ),
        ),
      );

      // assert
      final circularIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(circularIndicator.valueColor?.value, testColor);
    });
  });
}

