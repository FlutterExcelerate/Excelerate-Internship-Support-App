abstract class AiException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AiException(this.message, [this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AiException {
  final int? statusCode;

  const NetworkException(
    String message, {
    this.statusCode,
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}

class ContextException extends AiException {
  const ContextException(
    super.message, [
    super.stackTrace,
  ]);
}

class AiServiceException extends AiException {
  final String providerName;
  final int? statusCode;

  const AiServiceException(
    String message, {
    required this.providerName,
    this.statusCode,
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}

class ValidationException extends AiException {
  const ValidationException(
    super.message, [
    super.stackTrace,
  ]);
}

class CancellationException extends AiException {
  const CancellationException(
    super.message, [
    super.stackTrace,
  ]);
}
