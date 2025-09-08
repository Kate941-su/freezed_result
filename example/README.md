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

The package includes comprehensive example applications:

```bash
# Basic usage and transformations
dart run example/basic_usage.dart

# Real-world API example with error handling
dart run example/api_example.dart
```

### Example 1: Basic Usage (`example/basic_usage.dart`)

Demonstrates fundamental Result operations:
- Creating success and failure results
- Pattern matching with `when`
- Using extensions for side effects
- Value extraction with defaults
- Transformations and chaining
- Working with nullable values
- Error handling patterns

### Example 2: API Example (`example/api_example.dart`)

A comprehensive real-world example showing:
- Custom error types (NetworkError, ValidationError, etc.)
- User service with CRUD operations
- Complex error handling scenarios
- Chaining async operations
- Error transformation to user-friendly messages
- Side effects with extensions