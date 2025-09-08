import 'package:fresult/fresult.dart';

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

  print('🎯 Using the `when` method with Result types\n');

  // Example 1: Basic when usage
  print('=== Example 1: Basic when Usage ===');

  final successResult2 = Result<String, String>.success('Hello World');
  final failureResult2 = Result<String, String>.failure('Something went wrong');

  // Using when for pattern matching
  successResult2.when(
    success: (value) => print('✅ Success: $value'),
    failure: (error) => print('❌ Error: $error'),
  );

  failureResult2.when(
    success: (value) => print('✅ Success: $value'),
    failure: (error) => print('❌ Error: $error'),
  );

  // Example 2: when with return values
  print('\n=== Example 2: when with Return Values ===');

  final successMessage = successResult2.when(
    success: (value) => 'Got value: $value',
    failure: (error) => 'Got error: $error',
  );

  final failureMessage = failureResult2.when(
    success: (value) => 'Got value: $value',
    failure: (error) => 'Got error: $error',
  );

  print('Success message: $successMessage');
  print('Failure message: $failureMessage');

  // Example 3: when with different types
  print('\n=== Example 3: when with Different Types ===');

  final numberResult2 = Result<int, String>.success(42);
  final stringResult = numberResult2.when(
    success: (value) => 'The number is: $value',
    failure: (error) => 'Error: $error',
  );

  print('String result: $stringResult');

  // Example 4: when with complex operations
  print('\n=== Example 4: when with Complex Operations ===');

  final results2 = [
    Result.success(10),
    Result.failure('Network error'),
    Result.success(20),
    Result.failure('Validation error'),
    Result.success(30),
  ];

  print('Processing results with when:');
  for (final result in results2) {
    final processed = result.when(
      success: (value) {
        print('  ✅ Processing value: $value');
        return value * 2; // Double the value
      },
      failure: (error) {
        print('  ❌ Handling error: $error');
        return 0; // Default value for errors
      },
    );
    print('  Result: $processed');
  }

  // Example 5: when with async operations
  print('\n=== Example 5: when with Async Operations ===');

  final asyncResult = Result<String, String>.success('Async data');

  // Note: when itself is not async, but you can use it with async functions
  final asyncProcessed = asyncResult.when(
    success: (value) async {
      await Future.delayed(Duration(milliseconds: 100));
      return 'Processed: $value';
    },
    failure: (error) async {
      await Future.delayed(Duration(milliseconds: 50));
      return 'Error processed: $error';
    },
  );

  // Since when returns a Future, we need to await it
  asyncProcessed.then((result) {
    print('Async result: $result');
  });

  // Example 6: when with side effects
  print('\n=== Example 6: when with Side Effects ===');

  final userResult = Result<String, String>.success('john@example.com');

  userResult.when(
    success: (email) {
      print('📧 Sending welcome email to: $email');
      print('📊 Logging user registration');
      print('🎉 User successfully registered!');
    },
    failure: (error) {
      print('🚨 Registration failed: $error');
      print('📝 Logging error for debugging');
      print('🔄 Retrying registration...');
    },
  );

  // Example 7: when with conditional logic
  print('\n=== Example 7: when with Conditional Logic ===');

  final ageResult = Result<int, String>.success(25);

  final category = ageResult.when(
    success: (age) {
      if (age < 18) return 'Minor';
      if (age < 65) return 'Adult';
      return 'Senior';
    },
    failure: (error) => 'Unknown (Error: $error)',
  );

  print('Age category: $category');

  // Example 8: when with data transformation
  print('\n=== Example 8: when with Data Transformation ===');

  final dataResult = Result<Map<String, dynamic>, String>.success({
    'name': 'John Doe',
    'age': 30,
    'email': 'john@example.com',
  });

  final userInfo = dataResult.when(
    success: (data) => '${data['name']} (${data['age']}) - ${data['email']}',
    failure: (error) => 'Failed to load user data: $error',
  );

  print('User info: $userInfo');
}
