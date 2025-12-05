import 'package:dartz/dartz.dart';
import 'package:fluency_app/core/errors/failures.dart';
import 'package:fluency_app/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

// Implementações de teste
class TestParams {
  final String value;
  const TestParams(this.value);
}

class TestUseCase extends UseCase<String, TestParams> {
  @override
  Future<Either<Failure, String>> call(TestParams params) async {
    return Right(params.value);
  }
}

class TestNoParamsUseCase extends NoParamsUseCase<String> {
  @override
  Future<Either<Failure, String>> call() async {
    return const Right('success');
  }
}

void main() {
  group('UseCase', () {
    late TestUseCase useCase;

    setUp(() {
      useCase = TestUseCase();
    });

    test('should be callable with params', () async {
      // act
      final result = await useCase(const TestParams('test'));

      // assert
      expect(result, const Right('test'));
    });

    test('should return Either<Failure, Type>', () async {
      // act
      final result = await useCase(const TestParams('test'));

      // assert
      expect(result, isA<Either<Failure, String>>());
    });
  });

  group('NoParamsUseCase', () {
    late TestNoParamsUseCase useCase;

    setUp(() {
      useCase = TestNoParamsUseCase();
    });

    test('should be callable without params', () async {
      // act
      final result = await useCase();

      // assert
      expect(result, const Right('success'));
    });

    test('should return Either<Failure, Type>', () async {
      // act
      final result = await useCase();

      // assert
      expect(result, isA<Either<Failure, String>>());
    });
  });
}
