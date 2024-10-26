import 'dart:convert';

class ModelRequestUsersFilter {
  String? code;
  String? name;
  String? surname;
  String? deviceId;
  int? moduleId;
  int? roleId;
  String? username;

  ModelRequestUsersFilter({
    this.code,
    this.name,
    this.surname,
    this.deviceId,
    this.moduleId,
    this.roleId,
    this.username,
  });

  ModelRequestUsersFilter copyWith({
    String? code,
    String? name,
    String? surname,
    String? deviceId,
    int? moduleId,
    int? roleId,
    String? username,
  }) =>
      ModelRequestUsersFilter(
        code: code ?? this.code,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        deviceId: deviceId ?? this.deviceId,
        moduleId: moduleId ?? this.moduleId,
        roleId: roleId ?? this.roleId,
        username: username ?? this.username,
      );

  factory ModelRequestUsersFilter.fromRawJson(String str) => ModelRequestUsersFilter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelRequestUsersFilter.fromJson(Map<String, dynamic> json) => ModelRequestUsersFilter(
    code: json["code"],
    name: json["name"],
    surname: json["surname"],
    deviceId: json["deviceId"],
    moduleId: json["moduleId"],
    roleId: json["roleId"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "surname": surname,
    "deviceId": deviceId,
    "moduleId": moduleId,
    "roleId": roleId,
    "username": username,
  };
}