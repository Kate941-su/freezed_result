import 'package:freezed_result/freezed_result.dart';

void main() {
  print('🚀 Basic Result Usage Examples\n');

  // Example 1: Creating Results
  print('=== Example 1: Creating Results ===');

  final successResult = Result<String, String>.success('Hello World');
  final failureResult = Result<String, String>.failure('Something went wrong');

  print('Success Result:');
  print('  isSuccess: ${successResult.isSuccess}');
  print('  isFailure: ${successResult.isFailure}');
  print('  value: ${successResult.valueOrNull}');
  print('  error: ${successResult.errorOrNull}');

  print('\nFailure Result:');
  print('  isSuccess: ${failureResult.isSuccess}');
  print('  isFailure: ${failureResult.isFailure}');
  print('  value: ${failureResult.valueOrNull}');
  print('  error: ${failureResult.errorOrNull}');

  // Example 2: Pattern Matching with when
  print('\n=== Example 2: Pattern Matching with when ===');

  successResult.when(
    success: (value) => print('Success: $value'),
    failure: (error) => print('Error: $error'),
  );

  failureResult.when(
    success: (value) => print('Success: $value'),
    failure: (error) => print('Error: $error'),
  );

  // Example 3: Using Extensions
  print('\n=== Example 3: Using Extensions ===');

  successResult.onSuccess((value) => print('Success callback: $value'));
  failureResult.onFailure((error) => print('Failure callback: $error'));

  // Example 4: Getting Values with Defaults
  print('\n=== Example 4: Getting Values with Defaults ===');
  print('Success value or default: ${successResult.valueOr('Default')}');
  print('Failure value or default: ${failureResult.valueOr('Default')}');
  print(
      'Success value or computed: ${successResult.valueOrElse(() => 'Computed')}');
  print(
      'Failure value or computed: ${failureResult.valueOrElse(() => 'Computed')}');

  // Example 5: Transformations
  print('\n=== Example 5: Transformations ===');

  final numberResult = Result<int, String>.success(5);
  final doubledResult = numberResult.mapResult((value) => value * 2);

  print('Original: ${numberResult.valueOrNull}');
  print('Doubled: ${doubledResult.valueOrNull}');

  // Example 6: Error Transformations
  print('\n=== Example 6: Error Transformations ===');

  final errorResult = Result<int, String>.failure('Original error');
  final mappedErrorResult =
      errorResult.mapErrorResult((error) => 'Mapped: $error');

  print('Original error: ${errorResult.errorOrNull}');
  print('Mapped error: ${mappedErrorResult.errorOrNull}');

  // Example 7: Chaining Operations
  print('\n=== Example 7: Chaining Operations ===');

  final chainedResult = numberResult.flatMapResult((value) {
    if (value > 0) {
      return Result.success('Positive: $value');
    } else {
      return Result.failure('Not positive');
    }
  });

  print(
      'Chained result: ${chainedResult.valueOrNull ?? chainedResult.errorOrNull}');

  // Example 8: Working with Nullable Values
  print('\n=== Example 8: Working with Nullable Values ===');

  String? nullableValue = 'Hello';
  String? nullValue = null;

  final result1 = nullableValue.toResult();
  final result2 = nullValue.toResult('Custom error message');

  print('Nullable value result: ${result1.valueOrNull ?? result1.errorOrNull}');
  print('Null value result: ${result2.valueOrNull ?? result2.errorOrNull}');

  // Example 9: Error Handling Patterns
  print('\n=== Example 9: Error Handling Patterns ===');

  final results = [
    Result.success(10),
    Result.failure('Error 1'),
    Result.success(20),
    Result.failure('Error 2'),
    Result.success(30),
  ];

  print('Processing multiple results:');
  for (final result in results) {
    result.when(
      success: (value) => print('  ✅ Got value: $value'),
      failure: (error) => print('  ❌ Got error: $error'),
    );
  }

  // Example 10: Filtering Results
  print('\n=== Example 10: Filtering Results ===');

  final successValues = results
      .where((result) => result.isSuccess)
      .map((result) => result.valueOrNull)
      .whereType<int>()
      .toList();

  final errors = results
      .where((result) => result.isFailure)
      .map((result) => result.errorOrNull)
      .whereType<String>()
      .toList();

  print('Success values: $successValues');
  print('Errors: $errors');
}
