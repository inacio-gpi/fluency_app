import 'package:dartz/dartz.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/core/usecase/usecase.dart';
import 'package:fluency_app/features/path/domain/repositories/path_repository.dart';

class ResetProgress implements NoParamsUseCase<void> {
  final PathRepository repository;

  ResetProgress(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.resetProgress();
  }
}

