import 'package:dartz/dartz.dart';
import 'package:fluency_app/features/path/domain/usecases/reset_progress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ResetProgress useCase;
  late MockPathRepository mockRepository;

  setUp(() {
    mockRepository = MockPathRepository();
    useCase = ResetProgress(mockRepository);
  });

  group('ResetProgress', () {
    test('should reset progress in repository', () async {
      // arrange
      when(
        mockRepository.resetProgress(),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(null));
      verify(mockRepository.resetProgress());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
