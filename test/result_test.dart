import 'package:test/test.dart';
import 'package:fresult/fresult.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should create a success result', () {
        const result = Result<String, String>.success('Hello');

        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.valueOrNull, equals('Hello'));
        expect(result.errorOrNull, isNull);
      });

      test('should return value when calling valueOrThrow', () {
        const result = Result<String, String>.success('Hello');

        expect(result.valueOrThrow, equals('Hello'));
      });

      test('should return value when calling valueOr', () {
        const result = Result<String, String>.success('Hello');

        expect(result.valueOr('Default'), equals('Hello'));
      });
    });

    group('Failure', () {
      test('should create a failure result', () {
        const result = Result<String, String>.failure('Error');

        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.valueOrNull, isNull);
        expect(result.errorOrNull, equals('Error'));
      });

      test('should throw error when calling valueOrThrow', () {
        try {
          const result = Result<String, String>.failure('Error');
          final value = result.valueOrThrow;
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should return default when calling valueOr', () {
        const result = Result<String, String>.failure('Error');
        expect(result.valueOr('Default'), equals('Default'));
      });
    });

    group('map', () {
      test('should map success value', () {
        const result = Result<int, String>.success(5);
        final mapped = result.mapResult((value) => value * 2);

        expect(mapped.isSuccess, isTrue);
        expect(mapped.valueOrNull, equals(10));
      });

      test('should not map failure', () {
        const result = Result<int, String>.failure('Error');
        final mapped = result.mapResult((value) => value * 2);

        expect(mapped.isFailure, isTrue);
        expect(mapped.errorOrNull, equals('Error'));
        expect(mapped.valueOrNull, isNull);
      });
    });

    group('mapError', () {
      test('should not map success error', () {
        const result = Result<int, String>.success(5);
        final mapped = result.mapErrorResult((error) => 'Mapped: $error');

        expect(mapped.isSuccess, isTrue);
        expect(mapped.valueOrNull, equals(5));
      });

      test('should map failure error', () {
        const result = Result<int, String>.failure('Error');
        final mapped = result.mapErrorResult((error) => 'Mapped: $error');

        expect(mapped.isFailure, isTrue);
        expect(mapped.errorOrNull, equals('Mapped: Error'));
      });
    });

    group('flatMap', () {
      test('should chain success to success', () {
        const result = Result<int, String>.success(5);
        final chained =
            result.flatMapResult((value) => Result.success(value * 2));

        expect(chained.isSuccess, isTrue);
        expect(chained.valueOrNull, equals(10));
      });

      test('should chain success to failure', () {
        const result = Result<int, String>.success(5);
        final chained =
            result.flatMapResult((value) => Result.failure('Chained error'));

        expect(chained.isFailure, isTrue);
        expect(chained.errorOrNull, equals('Chained error'));
      });

      test('should not chain failure', () {
        const result = Result<int, String>.failure('Original error');
        final chained =
            result.flatMapResult((value) => Result.success(value * 2));

        expect(chained.isFailure, isTrue);
        expect(chained.errorOrNull, equals('Original error'));
      });
    });

    group('when', () {
      test('should call success callback for success', () {
        const result = Result<String, String>.success('Hello');
        String? capturedValue;

        result.when(
          success: (value) => capturedValue = value,
          failure: (error) => fail('Should not call failure callback'),
        );

        expect(capturedValue, equals('Hello'));
      });

      test('should call failure callback for failure', () {
        const result = Result<String, String>.failure('Error');
        String? capturedError;

        result.when(
          success: (value) => fail('Should not call success callback'),
          failure: (error) => capturedError = error,
        );

        expect(capturedError, equals('Error'));
      });
    });
  });
}
