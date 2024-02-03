// To parse this JSON data, do
//
//     final baseResponce = baseResponceFromJson(jsonString);

import 'dart:convert';

class BaseResponce {
  int? code;
  dynamic result;
  Exception? exception;

  BaseResponce({
    this.code,
    this.result,
    this.exception,
  });

  BaseResponce copyWith({
    int? code,
    dynamic result,
    Exception? exception,
  }) =>
      BaseResponce(
        code: code ?? this.code,
        result: result ?? this.result,
        exception: exception ?? this.exception,
      );

  factory BaseResponce.fromRawJson(String str) => BaseResponce.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BaseResponce.fromJson(Map<String, dynamic> json) => BaseResponce(
    code: json["code"],
    result: json["result"],
    exception: json["exception"] == null ? null : Exception.fromJson(json["exception"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "result": result,
    "exception": exception?.toJson(),
  };

  @override
  String toString() {
    return 'BaseResponce{code: $code, result: $result, exception: $exception}';
  }
}

class Exception {
  String? code;
  String? message;
  String? level;
  dynamic validationMessage;

  Exception({
    this.code,
    this.message,
    this.level,
    this.validationMessage,
  });

  Exception copyWith({
    String? code,
    String? message,
    String? level,
    dynamic validationMessage,
  }) =>
      Exception(
        code: code ?? this.code,
        message: message ?? this.message,
        level: level ?? this.level,
        validationMessage: validationMessage ?? this.validationMessage,
      );

  factory Exception.fromRawJson(String str) => Exception.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Exception.fromJson(Map<String, dynamic> json) => Exception(
    code: json["code"],
    message: json["message"],
    level: json["level"],
    validationMessage: json["validationMessage"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "level": level,
    "validationMessage": validationMessage.toJson(),
  };

  @override
  String toString() {
    return 'Exception{code: $code, message: $message, level: $level, validationMessage: $validationMessage}';
  }
}


