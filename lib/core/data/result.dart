/// Typed failure hierarchy for API errors.
///
/// Each subtype maps to a distinct failure mode so controllers can
/// pattern-match and show appropriate UI (offline banner, retry, etc.).
sealed class AppFailure {
  final String message;
  const AppFailure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Network unreachable, DNS failure, timeout.
class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

/// Request was explicitly cancelled (e.g. by CancelToken during rapid polling).
class CancelledFailure extends AppFailure {
  const CancelledFailure() : super('Request cancelled');
}

/// Server responded with a non-2xx status.
/// [errorCode] carries the server's structured code ("RATE_LIMIT", "VALIDATION_ERROR", etc.)
/// when the response uses the v2 error envelope `{ error: { code, message } }`.
class ServerFailure extends AppFailure {
  final int statusCode;
  final String? errorCode;
  const ServerFailure(this.statusCode, super.message, {this.errorCode});

  @override
  String toString() =>
      'ServerFailure($statusCode${errorCode != null ? ', $errorCode' : ''}): $message';
}

/// JSON decoding succeeded but `fromJson` threw, or response shape was unexpected.
class ParseFailure extends AppFailure {
  const ParseFailure(super.message);
}

/// Monadic result type — forces callers to handle both success and failure.
///
/// Usage with Dart 3 pattern matching:
/// ```dart
/// switch (result) {
///   case Ok(:final data): handleSuccess(data);
///   case Err(:final failure): handleError(failure);
/// }
/// ```
sealed class Result<T> {
  const Result();
  const factory Result.ok(T data) = Ok<T>;
  const factory Result.error(AppFailure failure) = Err<T>;

  /// True when this is an [Ok] result.
  bool get isOk => this is Ok<T>;
}

final class Ok<T> extends Result<T> {
  final T data;
  const Ok(this.data);
}

final class Err<T> extends Result<T> {
  final AppFailure failure;
  const Err(this.failure);
}
