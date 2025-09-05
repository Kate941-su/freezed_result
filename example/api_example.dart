import 'package:freezed_result/freezed_result.dart';

// Custom error types for better error handling
sealed class ApiError {
  const ApiError();
}

class NetworkError extends ApiError {
  final String message;
  const NetworkError(this.message);

  @override
  String toString() => 'NetworkError: $message';
}

class ValidationError extends ApiError {
  final String field;
  final String message;
  const ValidationError(this.field, this.message);

  @override
  String toString() => 'ValidationError($field): $message';
}

class NotFoundError extends ApiError {
  final String resource;
  const NotFoundError(this.resource);

  @override
  String toString() => 'NotFoundError: $resource not found';
}

class ServerError extends ApiError {
  final int statusCode;
  final String message;
  const ServerError(this.statusCode, this.message);

  @override
  String toString() => 'ServerError($statusCode): $message';
}

// User model
class User {
  final String id;
  final String name;
  final String email;
  final int age;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, age: $age)';

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'age': age,
      };

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        age: json['age'] as int,
      );
}

// Simulated API service
class UserService {
  // Simulate network delay
  Future<void> _delay() async {
    await Future.delayed(Duration(milliseconds: 100));
  }

  // Simulate network failure
  bool _shouldSimulateNetworkError() {
    return DateTime.now().millisecond % 10 == 0; // 10% chance
  }

  // Simulate server error
  bool _shouldSimulateServerError() {
    return DateTime.now().millisecond % 20 == 0; // 5% chance
  }

  /// Get user by ID
  Future<Result<User, ApiError>> getUserById(String id) async {
    await _delay();

    // Simulate network error
    if (_shouldSimulateNetworkError()) {
      return Result.failure(NetworkError('Connection timeout'));
    }

    // Simulate server error
    if (_shouldSimulateServerError()) {
      return Result.failure(ServerError(500, 'Internal server error'));
    }

    // Validate input
    if (id.isEmpty) {
      return Result.failure(ValidationError('id', 'ID cannot be empty'));
    }

    // Simulate not found
    if (id == 'not_found') {
      return Result.failure(NotFoundError('user'));
    }

    // Simulate success
    return Result.success(User(
      id: id,
      name: 'John Doe',
      email: 'john@example.com',
      age: 30,
    ));
  }

  /// Create a new user
  Future<Result<User, ApiError>> createUser({
    required String name,
    required String email,
    required int age,
  }) async {
    await _delay();

    // Simulate network error
    if (_shouldSimulateNetworkError()) {
      return Result.failure(NetworkError('Connection timeout'));
    }

    // Validate input
    if (name.isEmpty) {
      return Result.failure(ValidationError('name', 'Name cannot be empty'));
    }

    if (!email.contains('@')) {
      return Result.failure(ValidationError('email', 'Invalid email format'));
    }

    if (age < 0 || age > 150) {
      return Result.failure(
          ValidationError('age', 'Age must be between 0 and 150'));
    }

    // Simulate success
    return Result.success(User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      age: age,
    ));
  }

  /// Update user
  Future<Result<User, ApiError>> updateUser(
    String id, {
    String? name,
    String? email,
    int? age,
  }) async {
    await _delay();

    // First get the existing user
    final getUserResult = await getUserById(id);

    return getUserResult.flatMapResult((existingUser) {
      // Create updated user
      final updatedUser = User(
        id: existingUser.id,
        name: name ?? existingUser.name,
        email: email ?? existingUser.email,
        age: age ?? existingUser.age,
      );

      return Result.success(updatedUser);
    });
  }

  /// Delete user
  Future<Result<void, ApiError>> deleteUser(String id) async {
    await _delay();

    // Check if user exists
    final getUserResult = await getUserById(id);

    return getUserResult.flatMapResult((user) {
      // Simulate deletion
      return Result.success(null);
    });
  }
}

// Example usage
void main() async {
  print('🚀 API Example with Result Types\n');

  final userService = UserService();

  // Example 1: Get user by ID
  print('=== Example 1: Get User by ID ===');
  await _demonstrateGetUser(userService);

  // Example 2: Create user
  print('\n=== Example 2: Create User ===');
  await _demonstrateCreateUser(userService);

  // Example 3: Update user
  print('\n=== Example 3: Update User ===');
  await _demonstrateUpdateUser(userService);

  // Example 4: Delete user
  print('\n=== Example 4: Delete User ===');
  await _demonstrateDeleteUser(userService);

  // Example 5: Complex operation - Get user and create friend
  print('\n=== Example 5: Complex Operation ===');
  await _demonstrateComplexOperation(userService);

  // Example 6: Error handling patterns
  print('\n=== Example 6: Error Handling Patterns ===');
  await _demonstrateErrorHandling(userService);
}

Future<void> _demonstrateGetUser(UserService userService) async {
  // Success case
  final successResult = await userService.getUserById('user123');
  successResult.when(
    success: (user) => print('✅ User found: $user'),
    failure: (error) => print('❌ Error: $error'),
  );

  // Validation error case
  final validationResult = await userService.getUserById('');
  validationResult.when(
    success: (user) => print('✅ User found: $user'),
    failure: (error) => print('❌ Error: $error'),
  );

  // Not found case
  final notFoundResult = await userService.getUserById('not_found');
  notFoundResult.when(
    success: (user) => print('✅ User found: $user'),
    failure: (error) => print('❌ Error: $error'),
  );
}

Future<void> _demonstrateCreateUser(UserService userService) async {
  // Success case
  final successResult = await userService.createUser(
    name: 'Jane Doe',
    email: 'jane@example.com',
    age: 25,
  );

  successResult.when(
    success: (user) => print('✅ User created: $user'),
    failure: (error) => print('❌ Error: $error'),
  );

  // Validation error case
  final validationResult = await userService.createUser(
    name: '',
    email: 'invalid-email',
    age: -5,
  );

  validationResult.when(
    success: (user) => print('✅ User created: $user'),
    failure: (error) => print('❌ Error: $error'),
  );
}

Future<void> _demonstrateUpdateUser(UserService userService) async {
  // Success case
  final successResult =
      await userService.updateUser('user123', name: 'John Updated');

  successResult.when(
    success: (user) => print('✅ User updated: $user'),
    failure: (error) => print('❌ Error: $error'),
  );

  // Error case (user not found)
  final errorResult =
      await userService.updateUser('not_found', name: 'New Name');

  errorResult.when(
    success: (user) => print('✅ User updated: $user'),
    failure: (error) => print('❌ Error: $error'),
  );
}

Future<void> _demonstrateDeleteUser(UserService userService) async {
  // Success case
  final successResult = await userService.deleteUser('user123');

  successResult.when(
    success: (_) => print('✅ User deleted successfully'),
    failure: (error) => print('❌ Error: $error'),
  );

  // Error case
  final errorResult = await userService.deleteUser('not_found');

  errorResult.when(
    success: (_) => print('✅ User deleted successfully'),
    failure: (error) => print('❌ Error: $error'),
  );
}

Future<void> _demonstrateComplexOperation(UserService userService) async {
  // Chain operations: Get user and create a friend
  final getUserResult = await userService.getUserById('user123');

  if (getUserResult.isSuccess) {
    final user = getUserResult.valueOrThrow;
    final createFriendResult = await userService.createUser(
      name: 'Friend of ${user.name}',
      email: 'friend@example.com',
      age: user.age + 1,
    );

    createFriendResult.when(
      success: (friendUser) => print('✅ Friend user created: $friendUser'),
      failure: (error) => print('❌ Error creating friend: $error'),
    );
  } else {
    print('❌ Error getting user: ${getUserResult.errorOrNull}');
  }
}

Future<void> _demonstrateErrorHandling(UserService userService) async {
  print('--- Using Extensions for Side Effects ---');

  // Using onSuccess and onFailure extensions
  final getUserResult = await userService.getUserById('user123');
  getUserResult
      .onSuccess((user) => print('📧 Sending welcome email to ${user.email}'))
      .onFailure((error) => print('🚨 Logging error: $error'));

  print('\n--- Using mapResult for Error Transformation ---');

  // Transform errors to user-friendly messages
  final userFriendlyResult = await userService
      .getUserById('not_found')
      .mapErrorResult((error) => switch (error) {
            NetworkError() => 'Please check your internet connection',
            ValidationError() => 'Please provide valid input',
            NotFoundError() => 'User not found',
            ServerError() => 'Server is temporarily unavailable',
          });

  userFriendlyResult.when(
    success: (user) => print('✅ User: $user'),
    failure: (error) => print('❌ User-friendly error: $error'),
  );

  print('\n--- Using valueOr for Default Values ---');

  // Get user or return a default
  final userResult = await userService.getUserById('user123');
  final userOrDefault =
      userResult.mapResult((user) => user.name).valueOr('Anonymous User');

  print('User name: $userOrDefault');

  print('\n--- Using mapResult for Data Transformation ---');

  // Transform user data
  final userSummary = await userService
      .getUserById('user123')
      .mapResult((user) => '${user.name} (${user.age} years old)');

  userSummary.when(
    success: (summary) => print('✅ User summary: $summary'),
    failure: (error) => print('❌ Error: $error'),
  );
}
