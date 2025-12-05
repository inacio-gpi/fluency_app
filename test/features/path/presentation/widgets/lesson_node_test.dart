import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';
import 'package:fluency_app/features/path/domain/entities/task.dart';
import 'package:fluency_app/features/path/presentation/widgets/lesson_node.dart';

void main() {
  group('LessonNode Widget', () {
    const tTask = Task(
      id: 'task_1',
      title: 'Test Task',
      type: 'listen_repeat',
      estimatedSeconds: 60,
      isCompleted: true,
    );

    testWidgets('should render lesson with completed status',
        (WidgetTester tester) async {
      // arrange
      const lesson = Lesson(
        id: 'lesson_1',
        title: 'Test Lesson',
        position: 1,
        status: LessonStatus.completed,
        xp: 20,
        estimatedMinutes: 5,
        tasks: [tTask],
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(LessonNode), findsOneWidget);
      expect(find.text('Test Lesson'), findsOneWidget);
      expect(find.text('20 XP'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should render lesson with current status',
        (WidgetTester tester) async {
      // arrange
      const lesson = Lesson(
        id: 'lesson_2',
        title: 'Current Lesson',
        position: 2,
        status: LessonStatus.current,
        xp: 25,
        estimatedMinutes: 6,
        tasks: [],
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('should render lesson with locked status',
        (WidgetTester tester) async {
      // arrange
      const lesson = Lesson(
        id: 'lesson_3',
        title: 'Locked Lesson',
        position: 3,
        status: LessonStatus.locked,
        xp: 30,
        estimatedMinutes: 7,
        tasks: [],
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should show progress bar when tasks are completed',
        (WidgetTester tester) async {
      // arrange
      const lesson = Lesson(
        id: 'lesson_1',
        title: 'Test Lesson',
        position: 1,
        status: LessonStatus.current,
        xp: 20,
        estimatedMinutes: 5,
        tasks: [tTask],
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should call onTap when tapped and not locked',
        (WidgetTester tester) async {
      // arrange
      bool wasTapped = false;
      const lesson = Lesson(
        id: 'lesson_1',
        title: 'Test Lesson',
        position: 1,
        status: LessonStatus.current,
        xp: 20,
        estimatedMinutes: 5,
        tasks: [],
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // assert
      expect(wasTapped, true);
    });

    testWidgets('should not call onTap when locked',
        (WidgetTester tester) async {
      // arrange
      bool wasTapped = false;
      const lesson = Lesson(
        id: 'lesson_1',
        title: 'Test Lesson',
        position: 1,
        status: LessonStatus.locked,
        xp: 20,
        estimatedMinutes: 5,
        tasks: [],
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // assert
      expect(wasTapped, false);
    });
  });
}

