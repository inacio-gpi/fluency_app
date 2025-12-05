import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/features/path/presentation/controller/path_controller.dart';
import 'package:fluency_app/features/path/presentation/controller/path_event.dart';
import 'package:fluency_app/features/path/presentation/controller/path_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fluency_app/features/path/domain/usecases/get_learning_path.dart';
import 'package:fluency_app/features/path/domain/usecases/reset_progress.dart';

import '../../../../fixtures/fixtures.dart';
import 'path_controller_test.mocks.dart';

@GenerateMocks([GetLearningPath, ResetProgress])
void main() {
  late PathController controller;
  late MockGetLearningPath mockGetLearningPath;
  late MockResetProgress mockResetProgress;

  setUp(() {
    mockGetLearningPath = MockGetLearningPath();
    mockResetProgress = MockResetProgress();
    controller = PathController(
      getLearningPath: mockGetLearningPath,
      resetProgress: mockResetProgress,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('PathController', () {
    final tLearningPath = Fixtures.learningPath;

    test('initial state should be PathInitial', () {
      expect(controller.state, isA<PathInitial>());
    });

    group('LoadPathEvent', () {
      test('should emit [PathLoading, PathLoaded] when data is gotten successfully',
          () async {
        // arrange
        when(mockGetLearningPath())
            .thenAnswer((_) async => Right(tLearningPath));

        // assert later
        final expected = [
          PathLoading(),
          PathLoaded(path: tLearningPath),
        ];

        expectLater(
          controller.stream,
          emitsInOrder(expected),
        );

        // act
        controller.handleEvent(LoadPathEvent());
      });

      test('should emit [PathLoading, PathError] when getting data fails',
          () async {
        // arrange
        when(mockGetLearningPath())
            .thenAnswer((_) async => const Left(CacheFailure(message: 'Cache error')));

        // assert later
        final expected = [
          PathLoading(),
          const PathError(message: 'Cache error'),
        ];

        expectLater(
          controller.stream,
          emitsInOrder(expected),
        );

        // act
        controller.handleEvent(LoadPathEvent());
      });
    });

    group('RefreshPathEvent', () {
      test('should emit [PathLoaded] when refresh is successful', () async {
        // arrange
        when(mockGetLearningPath())
            .thenAnswer((_) async => Right(tLearningPath));

        // assert later
        expectLater(
          controller.stream,
          emits(PathLoaded(path: tLearningPath)),
        );

        // act
        controller.handleEvent(RefreshPathEvent());
      });
    });

    group('ResetProgressEvent', () {
      test('should emit [PathLoading, PathLoaded] when reset is successful',
          () async {
        // arrange
        when(mockResetProgress())
            .thenAnswer((_) async => const Right(null));
        when(mockGetLearningPath())
            .thenAnswer((_) async => Right(tLearningPath));

        // assert later
        final expected = [
          PathLoading(),
          PathLoaded(path: tLearningPath),
        ];

        expectLater(
          controller.stream,
          emitsInOrder(expected),
        );

        // act
        controller.handleEvent(ResetProgressEvent());
      });
    });
  });
}

