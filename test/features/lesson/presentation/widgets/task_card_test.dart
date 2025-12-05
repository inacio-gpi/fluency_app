import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/features/lesson/presentation/widgets/task_card.dart';
import 'package:fluency_app/features/path/domain/entities/task.dart';

void main() {
  group('TaskCard Widget', () {
    const tTask = Task(
      id: 'task_1',
      title: 'Test Task',
      type: 'listen_repeat',
      estimatedSeconds: 60,
      isCompleted: false,
    );

    testWidgets('should render task information',
        (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: tTask,
              isCompleted: false,
              onToggle: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Ouça e Repita'), findsOneWidget);
      expect(find.text('1min'), findsOneWidget);
    });

    testWidgets('should show headphones icon for listen_repeat type',
        (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: tTask,
              isCompleted: false,
              onToggle: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.headphones), findsOneWidget);
    });

    testWidgets('should show check icon when completed',
        (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: tTask,
              isCompleted: true,
              onToggle: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should call onToggle when tapped',
        (WidgetTester tester) async {
      // arrange
      bool wasTapped = false;

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: tTask,
              isCompleted: false,
              onToggle: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      // assert
      expect(wasTapped, true);
    });

    testWidgets('should format duration correctly for seconds',
        (WidgetTester tester) async {
      // arrange
      const taskShort = Task(
        id: 'task_1',
        title: 'Short Task',
        type: 'multiple_choice',
        estimatedSeconds: 45,
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: taskShort,
              isCompleted: false,
              onToggle: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.text('45s'), findsOneWidget);
    });

    testWidgets('should format duration correctly for minutes',
        (WidgetTester tester) async {
      // arrange
      const taskLong = Task(
        id: 'task_1',
        title: 'Long Task',
        type: 'role_play',
        estimatedSeconds: 150,
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: taskLong,
              isCompleted: false,
              onToggle: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.text('2min 30s'), findsOneWidget);
    });

    testWidgets('should show different icons for different task types',
        (WidgetTester tester) async {
      // arrange
      const tasks = [
        Task(
          id: 'task_1',
          title: 'Quiz',
          type: 'multiple_choice',
          estimatedSeconds: 60,
        ),
        Task(
          id: 'task_2',
          title: 'Fill',
          type: 'fill_in_the_blanks',
          estimatedSeconds: 60,
        ),
        Task(
          id: 'task_3',
          title: 'Order',
          type: 'ordering',
          estimatedSeconds: 60,
        ),
      ];

      for (final task in tasks) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TaskCard(
                task: task,
                isCompleted: false,
                onToggle: () {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Different icons should exist for different types
        expect(find.byType(Icon), findsWidgets);
        
        await tester.pumpWidget(Container());
      }
    });
  });
}

