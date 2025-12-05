import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/core/presentation/widgets/animated_linear_progress_indicator.dart';

void main() {
  group('AnimatedLinearProgressIndicator Widget', () {
    testWidgets('should render correctly with given progress',
        (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedLinearProgressIndicator(
              progress: 0.5,
              progressColor: Colors.blue,
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(AnimatedLinearProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
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
                    AnimatedLinearProgressIndicator(
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
      expect(find.byType(AnimatedLinearProgressIndicator), findsOneWidget);

      // Complete animation
      await tester.pumpAndSettle();
      final linearIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(linearIndicator.value, 1.0);
    });

    testWidgets('should use custom colors', (WidgetTester tester) async {
      // arrange
      const testColor = Colors.green;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedLinearProgressIndicator(
              progress: 0.75,
              progressColor: testColor,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      final linearIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(linearIndicator.valueColor?.value, testColor);
    });

    testWidgets('should respect custom height', (WidgetTester tester) async {
      // arrange
      const customHeight = 10.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedLinearProgressIndicator(
              progress: 0.5,
              progressColor: Colors.blue,
              height: customHeight,
            ),
          ),
        ),
      );

      // assert
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AnimatedLinearProgressIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.height, customHeight);
    });
  });
}

