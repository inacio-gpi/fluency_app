import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/core/usecase/usecase.dart';
import 'package:fluency_app/features/path/domain/repositories/path_repository.dart';

class UpdateLessonProgress implements UseCase<void, UpdateLessonProgressParams> {
  final PathRepository repository;

  UpdateLessonProgress(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateLessonProgressParams params) async {
    return await repository.updateLessonProgress(
      params.lessonId,
      params.completedTaskIds,
    );
  }
}

class UpdateLessonProgressParams extends Equatable {
  final String lessonId;
  final List<String> completedTaskIds;

  const UpdateLessonProgressParams({
    required this.lessonId,
    required this.completedTaskIds,
  });

  @override
  List<Object?> get props => [lessonId, completedTaskIds];
}

