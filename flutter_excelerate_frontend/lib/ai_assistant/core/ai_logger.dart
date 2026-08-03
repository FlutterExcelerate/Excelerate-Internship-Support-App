import 'package:flutter/foundation.dart';

class AiLogger {
  const AiLogger._();

  static void log(String message, {String? tag, Map<String, dynamic>? data}) {
    // Only execute logging in debug mode to ensure zero overhead in production.
    assert(() {
      final prefix = tag != null ? '[AI $tag]' : '[AI Module]';
      final payload = data != null ? ' | Data: $data' : '';
      debugPrint('$prefix $message$payload');
      return true;
    }());
  }

  static void error(String message, Object error, [StackTrace? stackTrace]) {
    assert(() {
      debugPrint('[AI ERROR] $message | Exception: $error');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
      return true;
    }());
  }
}
