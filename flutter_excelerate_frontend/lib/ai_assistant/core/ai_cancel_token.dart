import 'dart:async';

class AiCancelToken {
  bool _isCancelled = false;
  final Completer<void> _completer = Completer<void>();
  String? _cancelReason;

  bool get isCancelled => _isCancelled;
  String? get cancelReason => _cancelReason;
  Future<void> get onCancel => _completer.future;

  void cancel([String? reason]) {
    if (!_isCancelled) {
      _isCancelled = true;
      _cancelReason = reason;
      _completer.complete();
    }
  }
}
