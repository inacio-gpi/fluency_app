import 'package:dartz/dartz.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/features/path/domain/entities/learning_path.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';

abstract class PathRepository {
  Future<Either<Failure, LearningPath>> getLearningPath();
  Future<Either<Failure, void>> updateLessonProgress(
    String lessonId,
    List<String> completedTaskIds,
  );
  Future<Either<Failure, Lesson>> getLesson(String lessonId);
  Future<Either<Failure, void>> resetProgress();
}
