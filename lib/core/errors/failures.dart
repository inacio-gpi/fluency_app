abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class DataParsingFailure extends Failure {
  const DataParsingFailure({required super.message, super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});
}

