import 'package:fluency_app/features/lesson/presentation/controller/lesson_controller.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_state.dart';
import 'package:fluency_app/features/lesson/presentation/pages/lesson_tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixtures.dart';
import 'lesson_tasks_page_test.mocks.dart';

@GenerateMocks([LessonController])
void main() {
  late MockLessonController mockController;

  setUp(() {
    mockController = MockLessonController();
  });

  Widget createWidgetUnderTest(String lessonId) {
    return MaterialApp(
      home: LessonTasksPage(lessonId: lessonId, controller: mockController),
    );
  }

  group('LessonTasksPage', () {
    final tLesson = Fixtures.currentLesson;
    const tLessonId = 'lesson_2';

    testWidgets('should show loading indicator when state is Loading', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockController.state).thenReturn(LessonLoading());
      when(mockController.addListener(any)).thenReturn(null);
      when(mockController.removeListener(any)).thenReturn(null);

      // act
      await tester.pumpWidget(createWidgetUnderTest(tLessonId));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when state is Error', (
      WidgetTester tester,
    ) async {
      // arrange
      when(
        mockController.state,
      ).thenReturn(const LessonError(message: 'Error occurred'));
      when(mockController.addListener(any)).thenReturn(null);
      when(mockController.removeListener(any)).thenReturn(null);

      // act
      await tester.pumpWidget(createWidgetUnderTest(tLessonId));

      // assert
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('should show lesson content when state is Loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      when(
        mockController.state,
      ).thenReturn(LessonLoaded(lesson: tLesson, completedTaskIds: const {}));
      when(mockController.addListener(any)).thenReturn(null);
      when(mockController.removeListener(any)).thenReturn(null);

      // act
      await tester.pumpWidget(createWidgetUnderTest(tLessonId));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Test Lesson 2'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
