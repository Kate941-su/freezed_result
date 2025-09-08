import 'package:fresult/fresult.dart';
import 'package:test/test.dart';

void main() {
  group('ResultExtensions', () {
    group('onSuccess', () {
      test('should execute callback for success', () {
        const result = Result<String, String>.success('Hello');
        String? capturedValue;

        final returnedResult = result.onSuccess((value) {
          capturedValue = value;
        });

        expect(capturedValue, equals('Hello'));
        expect(returnedResult, equals(result));
      });

      test('should not execute callback for failure', () {
        const result = Result<String, String>.failure('Error');
        var callbackExecuted = false;

        result.onSuccess((value) {
          callbackExecuted = true;
        });

        expect(callbackExecuted, isFalse);
      });
    });

    group('onFailure', () {
      test('should execute callback for failure', () {
        const result = Result<String, String>.failure('Error');
        String? capturedError;

        final returnedResult = result.onFailure((error) {
          capturedError = error;
        });

        expect(capturedError, equals('Error'));
        expect(returnedResult, equals(result));
      });

      test('should not execute callback for success', () {
        const result = Result<String, String>.success('Hello');
        var callbackExecuted = false;

        result.onFailure((error) {
          callbackExecuted = true;
        });

        expect(callbackExecuted, isFalse);
      });
    });
  });

  group('NullableToResult', () {
    test('should convert non-null value to success', () {
      const value = 'Hello';
      final result = value.toResult();

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, equals('Hello'));
    });

    test('should convert null value to failure with default message', () {
      const String? value = null;
      final result = value.toResult();

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, equals('Value is null'));
    });

    test('should convert null value to failure with custom message', () {
      const String? value = null;
      final result = value.toResult('Custom error message');

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, equals('Custom error message'));
    });
  });

  group('FutureResultExtensions', () {
    group('map', () {
      test('should map success value of Future Result', () async {
        final futureResult = Future.value(const Result<int, String>.success(5));
        final mapped = await futureResult.mapResult((value) => value * 2);

        expect(mapped.isSuccess, isTrue);
        expect(mapped.valueOrNull, equals(10));
      });

      test('should not map failure of Future Result', () async {
        final futureResult =
            Future.value(const Result<int, String>.failure('Error'));
        final mapped = await futureResult.mapResult((value) => value * 2);

        expect(mapped.isFailure, isTrue);
        expect(mapped.errorOrNull, equals('Error'));
      });
    });

    group('mapError', () {
      test('should not map success error of Future Result', () async {
        final futureResult = Future.value(const Result<int, String>.success(5));
        final mapped =
            await futureResult.mapErrorResult((error) => 'Mapped: $error');

        expect(mapped.isSuccess, isTrue);
        expect(mapped.valueOrNull, equals(5));
      });

      test('should map failure error of Future Result', () async {
        final futureResult =
            Future.value(const Result<int, String>.failure('Error'));
        final mapped =
            await futureResult.mapErrorResult((error) => 'Mapped: $error');

        expect(mapped.isFailure, isTrue);
        expect(mapped.errorOrNull, equals('Mapped: Error'));
      });
    });

    group('flatMap', () {
      test('should chain success to success in Future Result', () async {
        final futureResult = Future.value(const Result<int, String>.success(5));
        final chained = await futureResult
            .flatMapResult((value) => Result.success(value * 2));
        expect(chained.isSuccess, isTrue);
        expect(chained.valueOrNull, equals(10));
      });

      test('should chain success to failure in Future Result', () async {
        final futureResult = Future.value(const Result<int, String>.success(5));
        final chained = await futureResult
            .flatMapResult((value) => const Result.failure('Chained error'));
        expect(chained.isFailure, isTrue);
        expect(chained.errorOrNull, equals('Chained error'));
      });

      test('should not chain failure in Future Result', () async {
        final futureResult =
            Future.value(const Result<int, String>.failure('Original error'));
        final chained = await futureResult
            .flatMapResult((value) => Result.success(value * 2));

        expect(chained.isFailure, isTrue);
        expect(chained.errorOrNull, equals('Original error'));
      });
    });
  });
}
