import 'package:dartz/dartz.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/core/usecase/usecase.dart';
import 'package:fluency_app/features/path/domain/entities/learning_path.dart';
import 'package:fluency_app/features/path/domain/repositories/path_repository.dart';

class GetLearningPath implements NoParamsUseCase<LearningPath> {
  final PathRepository repository;

  GetLearningPath(this.repository);

  @override
  Future<Either<Failure, LearningPath>> call() async {
    return await repository.getLearningPath();
  }
}

