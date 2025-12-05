import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_controller.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_event.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_state.dart';
import 'package:fluency_app/features/path/domain/usecases/update_lesson_progress.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fluency_app/features/path/domain/usecases/get_lesson.dart';

import '../../../../fixtures/fixtures.dart';
import 'lesson_controller_test.mocks.dart';

@GenerateMocks([GetLesson, UpdateLessonProgress])
void main() {
  late LessonController controller;
  late MockGetLesson mockGetLesson;
  late MockUpdateLessonProgress mockUpdateLessonProgress;

  setUp(() {
    mockGetLesson = MockGetLesson();
    mockUpdateLessonProgress = MockUpdateLessonProgress();
    controller = LessonController(
      getLesson: mockGetLesson,
      updateLessonProgress: mockUpdateLessonProgress,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('LessonController', () {
    final tLesson = Fixtures.currentLesson;
    const tLessonId = 'lesson_2';

    test('initial state should be LessonInitial', () {
      expect(controller.state, isA<LessonInitial>());
    });

    group('LoadLessonEvent', () {
      test('should emit [LessonLoading, LessonLoaded] when successful',
          () async {
        // arrange
        when(mockGetLesson(any)).thenAnswer((_) async => Right(tLesson));

        // assert later
        final expected = [
          LessonLoading(),
          isA<LessonLoaded>(),
        ];

        expectLater(controller.stream, emitsInOrder(expected));

        // act
        controller.handleEvent(const LoadLessonEvent(lessonId: tLessonId));
      });

      test('should emit [LessonLoading, LessonError] when fails', () async {
        // arrange
        when(mockGetLesson(any))
            .thenAnswer((_) async => const Left(CacheFailure(message: 'Error')));

        // assert later
        final expected = [
          LessonLoading(),
          const LessonError(message: 'Error'),
        ];

        expectLater(controller.stream, emitsInOrder(expected));

        // act
        controller.handleEvent(const LoadLessonEvent(lessonId: tLessonId));
      });
    });

    group('ToggleTaskCompletionEvent', () {
      test('should add task to completed set when toggled', () async {
        // arrange - set initial state
        when(mockGetLesson(any)).thenAnswer((_) async => Right(tLesson));
        controller.handleEvent(const LoadLessonEvent(lessonId: tLessonId));
        await Future.delayed(const Duration(milliseconds: 100));

        // act
        controller.handleEvent(const ToggleTaskCompletionEvent(taskId: 'task_1'));
        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        final state = controller.state as LessonLoaded;
        expect(state.completedTaskIds.contains('task_1'), true);
      });

      test('should remove task from completed set when toggled again',
          () async {
        // arrange - set initial state with completed task
        when(mockGetLesson(any)).thenAnswer((_) async => Right(tLesson));
        controller.handleEvent(const LoadLessonEvent(lessonId: tLessonId));
        await Future.delayed(const Duration(milliseconds: 100));

        controller.handleEvent(const ToggleTaskCompletionEvent(taskId: 'task_1'));
        await Future.delayed(const Duration(milliseconds: 100));

        // act - toggle again to remove
        controller.handleEvent(const ToggleTaskCompletionEvent(taskId: 'task_1'));
        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        final state = controller.state as LessonLoaded;
        expect(state.completedTaskIds.contains('task_1'), false);
      });
    });

    group('SaveProgressEvent', () {
      test('should save progress successfully', () async {
        // arrange
        when(mockGetLesson(any)).thenAnswer((_) async => Right(tLesson));
        controller.handleEvent(const LoadLessonEvent(lessonId: tLessonId));
        await Future.delayed(const Duration(milliseconds: 100));

        when(mockUpdateLessonProgress(any))
            .thenAnswer((_) async => const Right(null));

        // act
        controller.handleEvent(SaveProgressEvent());
        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        verify(mockUpdateLessonProgress(any));
      });
    });
  });
}

