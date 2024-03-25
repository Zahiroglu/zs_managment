import 'dart:convert';

class ModelRequestInOut {
  List<UserRole> userRole;
  String startDate;
  String endDate;

  ModelRequestInOut({
    required this.userRole,
    required this.startDate,
    required this.endDate,
  });

  factory ModelRequestInOut.fromRawJson(String str) => ModelRequestInOut.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelRequestInOut.fromJson(Map<String, dynamic> json) => ModelRequestInOut(
    userRole: List<UserRole>.from(json["user"].map((x) => UserRole.fromJson(x))),
    startDate: json["startDate"],
    endDate: json["endDate"],
  );

  Map<String, dynamic> toJson() => {
    "user": List<dynamic>.from(userRole.map((x) => x.toJson())),
    "startDate": startDate,
    "endDate": endDate,
  };
}

class UserRole {
  String code;
  String role;

  UserRole({
    required this.code,
    required this.role,
  });

  factory UserRole.fromRawJson(String str) => UserRole.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
    code: json["code"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "role": role,
  };
}
