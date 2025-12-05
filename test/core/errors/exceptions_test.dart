import 'package:fluency_app/core/errors/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exceptions', () {
    group('CacheException', () {
      test('should have correct message and code', () {
        const exception = CacheException(message: 'Cache error', code: '404');
        expect(exception.message, 'Cache error');
        expect(exception.code, '404');
      });

      test('should be a subclass of AppException', () {
        const exception = CacheException(message: 'Error', code: '404');
        expect(exception, isA<AppException>());
      });

      test('should have toString representation', () {
        const exception = CacheException(message: 'Cache error', code: '404');
        expect(exception.toString(), 'CacheException: Cache error (code: 404)');
      });

      test('should work without code', () {
        const exception = CacheException(message: 'Cache error');
        expect(exception.message, 'Cache error');
        expect(exception.code, isNull);
      });
    });

    group('DataParsingException', () {
      test('should have correct message and code', () {
        const exception = DataParsingException(
          message: 'Parsing error',
          code: '400',
        );
        expect(exception.message, 'Parsing error');
        expect(exception.code, '400');
      });

      test('should be a subclass of AppException', () {
        const exception = DataParsingException(message: 'Error', code: '400');
        expect(exception, isA<AppException>());
      });

      test('should have toString representation', () {
        const exception = DataParsingException(
          message: 'Parse failed',
          code: '400',
        );
        expect(
          exception.toString(),
          'DataParsingException: Parse failed (code: 400)',
        );
      });

      test('should work without code', () {
        const exception = DataParsingException(message: 'Parse error');
        expect(exception.message, 'Parse error');
        expect(exception.code, isNull);
      });
    });
  });
}
