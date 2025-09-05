import 'result.dart';

extension ResultExtensions<S, E> on Result<S, E> {
  /// Returns true if this is a Success result
  bool get isSuccess => this is Success<S, E>;

  /// Returns true if this is a Failure result
  bool get isFailure => this is Failure<S, E>;

  /// Returns the value if Success, null if Failure
  S? get valueOrNull => when(success: (value) => value, failure: (_) => null);

  /// Returns the error if Failure, null if Success
  E? get errorOrNull => when(success: (_) => null, failure: (error) => error);

  /// Transforms the success value using the provided function
  Result<T, E> mapResult<T>(T Function(S) transform) => when(
        success: (value) => Result.success(transform(value)),
        failure: (error) => Result.failure(error),
      );

  /// Maps the failure error to a new type.
  Result<S, F> mapErrorResult<F>(F Function(E) mapper) => when(
        success: (value) => Result.success(value),
        failure: (error) => Result.failure(mapper(error)),
      );

  /// Transforms the success value using an async function
  Future<Result<T, E>> mapAsyncResult<T>(
      Future<T> Function(S) transform) async {
    return when(
      success: (value) async => Result.success(await transform(value)),
      failure: (error) async => Result.failure(error),
    );
  }

  /// Chains another Result-returning operation
  Result<T, E> flatMapResult<T>(Result<T, E> Function(S) transform) => when(
        success: (value) => transform(value),
        failure: (error) => Result.failure(error),
      );

  /// Chains another async Result-returning operation
  Future<Result<T, E>> flatMapAsyncResult<T>(
    Future<Result<T, E>> Function(S) transform,
  ) async {
    return when(
      success: (value) async => await transform(value),
      failure: (error) async => Result.failure(error),
    );
  }

  /// Returns the success value or throws the error
  S get valueOrThrow => when(
        success: (value) => value,
        failure: (error) => throw Exception('${error.toString()}'),
      );

  /// Returns the success value or the provided default
  S? valueOr(S? defaultValue) =>
      when(success: (value) => value, failure: (_) => defaultValue);

  /// Executes a function if this is a Success
  Result<S, E> onSuccess(void Function(S) action) {
    if (this is Success<S, E>) {
      action((this as Success<S, E>).value);
    }
    return this;
  }

  /// Executes a function if this is a Failure
  Result<S, E> onFailure(void Function(E) action) {
    if (this is Failure<S, E>) {
      action((this as Failure<S, E>).error);
    }
    return this;
  }
}

/// Extensions for working with nullable values and converting them to Results.
extension NullableToResult<T> on T? {
  /// Converts a nullable value to a Result.
  /// Returns [Result.success] if the value is not null, otherwise [Result.failure].
  Result<T, String> toResult([String? errorMessage]) {
    if (this != null) {
      return Result.success(this!);
    }
    return Result.failure(errorMessage ?? 'Value is null');
  }
}

/// Extensions for working with Future Results.
extension FutureResultExtensions<T, E> on Future<Result<T, E>> {
  /// Maps the success value of a Future Result to a new type.
  Future<Result<U, E>> mapResult<U>(U Function(T) mapper) async {
    final result = await this;
    return result.mapResult(mapper);
  }

  /// Maps the failure error of a Future Result to a new type.
  Future<Result<T, F>> mapErrorResult<F>(F Function(E) mapper) async {
    final result = await this;
    return result.mapErrorResult(mapper);
  }

  /// Chains another async operation that returns a Result.
  Future<Result<U, E>> flatMapResult<U>(Result<U, E> Function(T) mapper) async {
    final result = await this;
    return result.flatMapResult((value) => mapper(value));
  }
}
