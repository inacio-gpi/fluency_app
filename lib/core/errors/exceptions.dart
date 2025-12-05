abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' (code: $code)' : ''}';
}

class CacheException extends AppException {
  const CacheException({required super.message, super.code});
}

class DataParsingException extends AppException {
  const DataParsingException({required super.message, super.code});
}

