# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2025-09-08
## Change
- Delete unnecesarry dependencies

## [1.1.0] - 2025-09-08
## Add
- Add freezed patter matching features
- Add a freeezed generated file in the project

## Change
- Update libraries versions

## [1.0.1] - 2025-09-05
## Change
- Change README.md

## [1.0.0] - 2025-09-05

### Added
- Initial release of `freezed_result` package
- `Result<T, E>` sealed class with `Success` and `Failure` variants
- Comprehensive set of methods for working with Results:
  - `map()` - Transform success values
  - `mapError()` - Transform failure errors
  - `mapBoth()` - Transform both success and failure
  - `flatMap()` - Chain operations that return Results
  - `valueOr()` - Get value with default fallback
  - `valueOrElse()` - Get value with computed fallback
  - `valueOrThrow()` - Get value or throw error
  - `when()` - Pattern matching for success/failure
- Extensions for enhanced functionality:
  - `onSuccess()` and `onFailure()` for side effects
  - `NullableToResult` extension for converting nullable values
  - `FutureResultExtensions` for working with async Results
- Comprehensive test suite with 100% coverage
- Example applications demonstrating various use cases
- Full documentation with API reference
- Linting configuration with strict rules

### Features
- Type-safe error handling without exceptions
- Immutable Result types using Freezed
- Functional programming patterns
- Async/await support
- Null safety support
- Comprehensive documentation and examples
