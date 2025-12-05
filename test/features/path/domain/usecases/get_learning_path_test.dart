import 'package:dartz/dartz.dart';
import 'package:fluency_app/features/path/domain/usecases/get_learning_path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetLearningPath useCase;
  late MockPathRepository mockRepository;

  setUp(() {
    mockRepository = MockPathRepository();
    useCase = GetLearningPath(mockRepository);
  });

  group('GetLearningPath', () {
    final tLearningPath = Fixtures.learningPath;

    test('should get learning path from repository', () async {
      // arrange
      when(mockRepository.getLearningPath())
          .thenAnswer((_) async => Right(tLearningPath));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(tLearningPath));
      verify(mockRepository.getLearningPath());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

