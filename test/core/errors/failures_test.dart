import 'package:fluency_app/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failures', () {
    group('CacheFailure', () {
      test('should have correct message', () {
        const failure = CacheFailure(message: 'Cache error');
        expect(failure.message, 'Cache error');
      });

      test('should have correct code', () {
        const failure = CacheFailure(message: 'Error', code: '404');
        expect(failure.code, '404');
      });

      test('should be a subclass of Failure', () {
        const failure = CacheFailure(message: 'Error');
        expect(failure, isA<Failure>());
      });

      test('should have toString representation', () {
        const failure = CacheFailure(message: 'Cache error', code: '404');
        expect(failure.toString(), contains('Cache error'));
        expect(failure.toString(), contains('404'));
      });
    });

    group('DataParsingFailure', () {
      test('should have correct message', () {
        const failure = DataParsingFailure(message: 'Parsing error');
        expect(failure.message, 'Parsing error');
      });

      test('should have correct code', () {
        const failure = DataParsingFailure(message: 'Error', code: '400');
        expect(failure.code, '400');
      });

      test('should be a subclass of Failure', () {
        const failure = DataParsingFailure(message: 'Error');
        expect(failure, isA<Failure>());
      });
    });

    group('UnknownFailure', () {
      test('should have correct message', () {
        const failure = UnknownFailure(message: 'Unknown error');
        expect(failure.message, 'Unknown error');
      });

      test('should have correct code', () {
        const failure = UnknownFailure(message: 'Error', code: '500');
        expect(failure.code, '500');
      });

      test('should be a subclass of Failure', () {
        const failure = UnknownFailure(message: 'Error');
        expect(failure, isA<Failure>());
      });
    });
  });
}
