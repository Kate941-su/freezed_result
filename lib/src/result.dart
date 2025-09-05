import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<S, T> with _$Result<S, T> {
  const factory Result.success(S value) = Success<S, T>;
  const factory Result.failure(T error) = Failure<S, T>;
}

