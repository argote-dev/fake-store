sealed class Result<T> {
  const Result();
  factory Result.success(T value) => Success(value);
  factory Result.failure(Exception error) => Failure(error);

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T value) success,
    required R Function(Exception error) failure,
  }) {
    return switch (this) {
      Success(value: final v) => success(v),
      Failure(error: final e) => failure(e),
    };
  }

  Result<R> map<R>(R Function(T) transform) {
    return switch (this) {
      Success(value: final v) => Result.success(transform(v)),
      Failure(error: final e) => Result.failure(e),
    };
  }
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final Exception error;
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}
