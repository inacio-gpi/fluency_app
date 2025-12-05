import 'package:dartz/dartz.dart';
import 'package:fluency_app/core/errors/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

abstract class NoParamsUseCase<T> {
  Future<Either<Failure, T>> call();
}

