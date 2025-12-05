import 'package:dartz/dartz.dart';
import 'package:fluency_app/core/errors/exceptions.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/features/path/data/datasources/path_local_datasource.dart';
import 'package:fluency_app/features/path/data/datasources/path_mock_datasource.dart';
import 'package:fluency_app/features/path/data/models/learning_path_model.dart';
import 'package:fluency_app/features/path/data/models/lesson_model.dart';
import 'package:fluency_app/features/path/data/models/task_model.dart';
import 'package:fluency_app/features/path/domain/entities/learning_path.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';
import 'package:fluency_app/features/path/domain/repositories/path_repository.dart';

class PathRepositoryImpl implements PathRepository {
  final PathMockDataSource mockDataSource;
  final PathLocalDataSource localDataSource;

  PathRepositoryImpl({
    required this.mockDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LearningPath>> getLearningPath() async {
    try {
      await _simulateDelayLoading();

      LearningPathModel? cachedPath = await localDataSource.getCachedPath();

      if (cachedPath == null) {
        cachedPath = await mockDataSource.getMockPath();
        await localDataSource.cachePath(cachedPath);
      }

      final updatedLessons = await Future.wait(
        cachedPath.lessons.map((lesson) async {
          final completedTaskIds = await localDataSource.getCompletedTaskIds(
            lesson.id,
          );
          final savedStatus = await localDataSource.getLessonStatus(lesson.id);

          LessonStatus lessonStatus = lesson.status;
          if (savedStatus != null) {
            lessonStatus = _statusFromString(savedStatus);
          }

          if (completedTaskIds == null || completedTaskIds.isEmpty) {
            return LessonModel(
              id: lesson.id,
              title: lesson.title,
              position: lesson.position,
              status: lessonStatus,
              xp: lesson.xp,
              estimatedMinutes: lesson.estimatedMinutes,
              tasks: lesson.tasks,
            );
          }

          final updatedTasks = lesson.tasks.map((task) {
            final isCompleted = completedTaskIds.contains(task.id);
            return TaskModel(
              id: task.id,
              title: task.title,
              type: task.type,
              estimatedSeconds: task.estimatedSeconds,
              isCompleted: isCompleted,
            );
          }).toList();

          return LessonModel(
            id: lesson.id,
            title: lesson.title,
            position: lesson.position,
            status: lessonStatus,
            xp: lesson.xp,
            estimatedMinutes: lesson.estimatedMinutes,
            tasks: updatedTasks,
          );
        }),
      );

      final updatedPath = LearningPathModel(
        id: cachedPath.id,
        name: cachedPath.name,
        description: cachedPath.description,
        lessons: updatedLessons,
      );

      return Right(updatedPath);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unexpected error: $e'));
    }
  }

  LessonStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return LessonStatus.completed;
      case 'current':
        return LessonStatus.current;
      case 'locked':
        return LessonStatus.locked;
      default:
        return LessonStatus.locked;
    }
  }

  String _statusToString(LessonStatus status) {
    switch (status) {
      case LessonStatus.completed:
        return 'completed';
      case LessonStatus.current:
        return 'current';
      case LessonStatus.locked:
        return 'locked';
    }
  }

  @override
  Future<Either<Failure, void>> updateLessonProgress(
    String lessonId,
    List<String> completedTaskIds,
  ) async {
    try {
      await localDataSource.cacheTaskProgress(lessonId, completedTaskIds);

      final pathResult = await getLearningPath();

      return pathResult.fold((failure) => Left(failure), (path) async {
        final currentLesson = path.lessons.firstWhere((l) => l.id == lessonId);
        final allTasksCompleted =
            completedTaskIds.length == currentLesson.tasks.length;

        if (allTasksCompleted && currentLesson.status == LessonStatus.current) {
          await localDataSource.cacheLessonStatus(
            lessonId,
            _statusToString(LessonStatus.completed),
          );

          final currentIndex = path.lessons.indexWhere((l) => l.id == lessonId);
          if (currentIndex >= 0 && currentIndex < path.lessons.length - 1) {
            final nextLesson = path.lessons[currentIndex + 1];
            await localDataSource.cacheLessonStatus(
              nextLesson.id,
              _statusToString(LessonStatus.current),
            );
          }
        }

        return const Right(null);
      });
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update progress: $e'));
    }
  }

  @override
  Future<Either<Failure, Lesson>> getLesson(String lessonId) async {
    try {
      await _simulateDelayLoading();

      final pathResult = await getLearningPath();

      return pathResult.fold((failure) => Left(failure), (path) {
        final lesson = path.lessons.firstWhere(
          (l) => l.id == lessonId,
          orElse: () => throw DataParsingException(
            message: 'Lesson not found',
            code: '404',
          ),
        );
        return Right(lesson);
      });
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get lesson: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetProgress() async {
    try {
      await _simulateDelayLoading();

      await localDataSource.clearAllProgress();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to reset progress: $e'));
    }
  }

  Future<void> _simulateDelayLoading() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
