import 'package:dartz/dartz.dart';
import 'package:fluency_app/core/errors/exceptions.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/features/path/data/repositories_impl/path_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late PathRepositoryImpl repository;
  late MockPathMockDataSource mockMockDataSource;
  late MockPathLocalDataSource mockLocalDataSource;

  setUp(() {
    mockMockDataSource = MockPathMockDataSource();
    mockLocalDataSource = MockPathLocalDataSource();
    repository = PathRepositoryImpl(
      mockDataSource: mockMockDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('PathRepositoryImpl', () {
    final tLearningPath = Fixtures.learningPathModel;

    group('getLearningPath', () {
      test('should return learning path from local when available', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedPath(),
        ).thenAnswer((_) async => tLearningPath);

        // act
        final result = await repository.getLearningPath();

        // assert
        verify(mockLocalDataSource.getCachedPath());
        expect(result, Right(tLearningPath));
      });

      test('should return learning path from mock when local fails', () async {
        // arrange
        when(mockLocalDataSource.getCachedPath()).thenAnswer((_) async => null);
        when(
          mockMockDataSource.getMockPath(),
        ).thenAnswer((_) async => tLearningPath);
        when(
          mockLocalDataSource.cachePath(any),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.getLearningPath();

        // assert
        verify(mockLocalDataSource.getCachedPath());
        verify(mockMockDataSource.getMockPath());
        verify(mockLocalDataSource.cachePath(tLearningPath));
        expect(result, Right(tLearningPath));
      });

      test('should return CacheFailure when both sources fail', () async {
        // arrange
        when(mockLocalDataSource.getCachedPath()).thenAnswer((_) async => null);
        when(
          mockMockDataSource.getMockPath(),
        ).thenThrow(const DataParsingException(message: 'Parse error'));

        // act
        final result = await repository.getLearningPath();

        // assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<DataParsingFailure>()),
          (_) => fail('Should return failure'),
        );
      });
    });

    group('getLesson', () {
      final tLesson = Fixtures.currentLesson;
      const tLessonId = 'lesson_2';

      test('should return lesson when found', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedPath(),
        ).thenAnswer((_) async => tLearningPath);

        // act
        final result = await repository.getLesson(tLessonId);

        // assert
        expect(result, Right(tLesson));
      });

      test('should return CacheFailure when lesson not found', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedPath(),
        ).thenAnswer((_) async => tLearningPath);

        // act
        final result = await repository.getLesson('invalid_id');

        // assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Should return failure'),
        );
      });
    });

    group('resetProgress', () {
      test('should clear all progress and return success', () async {
        // arrange
        when(
          mockLocalDataSource.clearAllProgress(),
        ).thenAnswer((_) async => Future.value());
        when(
          mockMockDataSource.getMockPath(),
        ).thenAnswer((_) async => tLearningPath);
        when(
          mockLocalDataSource.cachePath(any),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.resetProgress();

        // assert
        verify(mockLocalDataSource.clearAllProgress());
        expect(result, const Right(null));
      });

      test('should return CacheFailure when reset fails', () async {
        // arrange
        when(
          mockLocalDataSource.clearAllProgress(),
        ).thenThrow(const CacheException(message: 'Clear failed'));

        // act
        final result = await repository.resetProgress();

        // assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Should return failure'),
        );
      });
    });
  });
}
