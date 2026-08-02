class AiError {
  final String message;
  final String code;
  final Map<String, dynamic>? details;

  const AiError({
    required this.message,
    this.code = 'UNKNOWN_ERROR',
    this.details,
  });

  AiError copyWith({
    String? message,
    String? code,
    Map<String, dynamic>? details,
  }) {
    return AiError(
      message: message ?? this.message,
      code: code ?? this.code,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      if (details != null) 'details': details,
    };
  }

  factory AiError.fromJson(Map<String, dynamic> json) {
    return AiError(
      message: json['message'] as String? ?? 'Unknown error occurred.',
      code: json['code'] as String? ?? 'UNKNOWN_ERROR',
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiError && 
           other.message == message && 
           other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() => 'AiError(code: $code, message: $message)';
}
