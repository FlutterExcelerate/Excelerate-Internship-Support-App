import 'ai_error.dart';

sealed class AiResult<T> {
  const AiResult();

  factory AiResult.success(T data) = AiSuccess<T>;
  factory AiResult.failure(AiError error) = AiFailure<T>;

  bool get isSuccess => this is AiSuccess<T>;
  bool get isFailure => this is AiFailure<T>;

  R fold<R>(
    R Function(T data) onSuccess,
    R Function(AiError error) onFailure,
  ) {
    if (this is AiSuccess<T>) {
      return onSuccess((this as AiSuccess<T>).data);
    } else if (this is AiFailure<T>) {
      return onFailure((this as AiFailure<T>).error);
    }
    throw StateError('Invalid AiResult state');
  }
}

class AiSuccess<T> extends AiResult<T> {
  final T data;
  const AiSuccess(this.data);
}

class AiFailure<T> extends AiResult<T> {
  final AiError error;
  const AiFailure(this.error);
}

