import 'package:dartz/dartz.dart';
import 'package:fluency_app/features/path/domain/usecases/get_lesson.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetLesson useCase;
  late MockPathRepository mockRepository;

  setUp(() {
    mockRepository = MockPathRepository();
    useCase = GetLesson(mockRepository);
  });

  group('GetLesson', () {
    final tLesson = Fixtures.currentLesson;
    const tLessonId = 'lesson_2';

    test('should get lesson from repository', () async {
      // arrange
      when(mockRepository.getLesson(any))
          .thenAnswer((_) async => Right(tLesson));

      // act
      final result = await useCase(tLessonId);

      // assert
      expect(result, Right(tLesson));
      verify(mockRepository.getLesson(tLessonId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

