# freezed_result

[![pub package](https://img.shields.io/pub/v/freezed_result.svg)](https://pub.dev/packages/freezed_result)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Dart package providing Result types for better error handling using [Freezed](https://pub.dev/packages/freezed). This package helps you write more robust and functional code by avoiding exceptions and providing type-safe error handling.

## Features

- 🎯 **Type-safe error handling** - No more exceptions for expected errors
- 🔒 **Immutable Result types** - Built with Freezed for immutability
- 🔄 **Functional programming patterns** - Map, flatMap, and chain operations
- ⚡ **Async/await support** - Work seamlessly with Futures
- 🛡️ **Null safety** - Full null safety support
- 📚 **Comprehensive documentation** - Well-documented API with examples
- ✅ **100% test coverage** - Thoroughly tested

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  freezed_result: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
```

Then run:

```bash
dart pub get
dart run build_runner build
```

## Quick Start

```dart
import 'package:freezed_result/freezed_result.dart';

void main() {
  // Create a successful result
  final success = Result<String, String>.success('Hello World');
  
  // Create a failed result
  final failure = Result<String, String>.failure('Something went wrong');
  
  // Pattern matching with when
  success.when(
    success: (value) => print('Success: $value'),
    failure: (error) => print('Error: $error'),
  );
  
  // Check if result is success or failure
  if (success.isSuccess) {
    print('Value: ${success.valueOrNull}');
  }
  
  // Transform values
  final doubled = Result<int, String>.success(5)
      .map((value) => value * 2);
  
  // Chain operations
  final result = Result<int, String>.success(5)
      .flatMap((value) => value > 0 
          ? Result.success('Positive: $value')
          : Result.failure('Not positive'));
}
```

## API Reference

### Result<T, E>

A sealed class representing either a success with a value of type `T` or a failure with an error of type `E`.

#### Constructors

- `Result.success(T value)` - Creates a successful result
- `Result.failure(E error)` - Creates a failed result

#### Properties

- `bool isSuccess` - Returns true if this result is a success
- `bool isFailure` - Returns true if this result is a failure
- `T? valueOrNull` - Returns the value if success, otherwise null
- `E? errorOrNull` - Returns the error if failure, otherwise null

#### Methods

##### Pattern Matching

```dart
result.when(
  success: (value) => 'Success: $value',
  failure: (error) => 'Error: $error',
);
```

##### Value Extraction

```dart
// Get value with default
final value = result.valueOr('Default');

// Get value with computed default
final value = result.valueOrElse(() => 'Computed');

// Get value or throw error
final value = result.valueOrThrow;
```

##### Transformations

```dart
// Map success value
final mapped = result.map((value) => value.toString());

// Map error
final mapped = result.mapError((error) => 'Mapped: $error');

// Map both
final mapped = result.mapBoth(
  successMapper: (value) => 'Success: $value',
  failureMapper: (error) => 'Error: $error',
);

// Chain operations
final chained = result.flatMap((value) => 
    Result.success(value * 2));
```

### Extensions

#### ResultExtensions

```dart
// Execute side effects
result.onSuccess((value) => print('Success: $value'));
result.onFailure((error) => print('Error: $error'));
```

#### NullableToResult

```dart
// Convert nullable to Result
final result = nullableValue.toResult('Custom error message');
```

#### FutureResultExtensions

```dart
// Work with Future Results
final futureResult = Future.value(Result.success(5));

// Map async results
final mapped = await futureResult.map((value) => value * 2);

// Chain async operations
final chained = await futureResult.flatMap((value) => 
    Future.value(Result.success(value.toString())));
```

## Examples

### Basic Usage

```dart
import 'package:freezed_result/freezed_result.dart';

void main() {
  // Creating Results
  final success = Result<String, String>.success('Hello World');
  final failure = Result<String, String>.failure('Error occurred');
  
  // Pattern matching
  success.when(
    success: (value) => print('Success: $value'),
    failure: (error) => print('Error: $error'),
  );
  
  // Using extensions
  success.onSuccess((value) => print('Got value: $value'));
  failure.onFailure((error) => print('Got error: $error'));
}
```

### API Error Handling

```dart
sealed class ApiError {
  const ApiError();
}

class NetworkError extends ApiError {
  final String message;
  const NetworkError(this.message);
}

class ValidationError extends ApiError {
  final String field;
  final String message;
  const ValidationError(this.field, this.message);
}

class UserService {
  Future<Result<User, ApiError>> getUser(String id) async {
    if (id.isEmpty) {
      return Result.failure(ValidationError('id', 'ID cannot be empty'));
    }
    
    try {
      final user = await apiClient.getUser(id);
      return Result.success(user);
    } catch (e) {
      return Result.failure(NetworkError(e.toString()));
    }
  }
}
```

### Async Operations

```dart
Future<Result<String, String>> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return Result.success('Data fetched');
}

void main() async {
  final result = await fetchData()
      .map((data) => 'Processed: $data')
      .flatMap((processed) => 
          Future.value(Result.success('Final: $processed')));
  
  result.when(
    success: (value) => print('Final result: $value'),
    failure: (error) => print('Error: $error'),
  );
}
```

## Running Examples

The package includes several example applications:

```bash
# Basic usage
dart run example/basic_usage.dart

# Transformation examples
dart run example/transformation_examples.dart

# Async examples
dart run example/async_examples.dart

# Real-world example
dart run example/real_world_example.dart
```

## Testing

Run the test suite:

```bash
dart test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.

## Related Packages

- [freezed](https://pub.dev/packages/freezed) - Code generation for immutable classes
- [dartz](https://pub.dev/packages/dartz) - Functional programming in Dart
- [fpdart](https://pub.dev/packages/fpdart) - Functional programming in Dart

## Support

If you find this package helpful, please consider giving it a ⭐ on [pub.dev](https://pub.dev/packages/freezed_result)!
