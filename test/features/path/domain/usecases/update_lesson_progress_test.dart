import 'package:dartz/dartz.dart';
import 'package:fluency_app/features/path/domain/usecases/update_lesson_progress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late UpdateLessonProgress useCase;
  late MockPathRepository mockRepository;

  setUp(() {
    mockRepository = MockPathRepository();
    useCase = UpdateLessonProgress(mockRepository);
  });

  group('UpdateLessonProgress', () {
    const tLessonId = 'lesson_1';
    const tCompletedTaskIds = ['task_1', 'task_2'];
    const tParams = UpdateLessonProgressParams(
      lessonId: tLessonId,
      completedTaskIds: tCompletedTaskIds,
    );

    test('should update lesson progress in repository', () async {
      // arrange
      when(
        mockRepository.updateLessonProgress(any, any),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.updateLessonProgress(tLessonId, tCompletedTaskIds));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
