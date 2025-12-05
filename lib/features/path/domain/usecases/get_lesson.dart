import 'package:dartz/dartz.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/core/usecase/usecase.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';
import 'package:fluency_app/features/path/domain/repositories/path_repository.dart';

class GetLesson implements UseCase<Lesson, String> {
  final PathRepository repository;

  GetLesson(this.repository);

  @override
  Future<Either<Failure, Lesson>> call(String lessonId) async {
    return await repository.getLesson(lessonId);
  }
}

