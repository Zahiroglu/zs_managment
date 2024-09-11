// To parse this JSON data, do
//
//     final modelUserConnection = modelUserConnectionFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
part 'model_userconnnection.g.dart';

@HiveType(typeId: 6)
class ModelUserConnection {
  @HiveField(0)
  int? roleId;
  @HiveField(1)
  String? roleName;
  @HiveField(2)
  String? code;
  @HiveField(3)
  String? fullName;
  @HiveField(4)
  int? userId;

  ModelUserConnection({
    this.roleId,
    this.roleName,
    this.code,
    this.fullName,
    this.userId,
  });

  ModelUserConnection copyWith({
    int? roleId,
    String? roleName,
    String? code,
    String? fullName,
    int? userId,
  }) =>
      ModelUserConnection(
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
        code: code ?? this.code,
        fullName: fullName ?? this.fullName,
        userId: userId ?? this.userId,
      );

  factory ModelUserConnection.fromRawJson(String str) => ModelUserConnection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUserConnection.fromJson(Map<String, dynamic> json) => ModelUserConnection(
    roleId: json["RoleId"],
    roleName: json["RoleName"],
    code: json["Code"],
    fullName: json["FullName"],
    userId: json["UserId"],
  );

  Map<String, dynamic> toJson() => {
    "roleId": roleId,
    "roleName": roleName,
    "code": code,
    "fullName": fullName,
    "UserId": userId,
  };

  @override
  String toString() {
    return 'ModelUserConnection{roleId: $roleId, roleName: $roleName, code: $code, fullName: $fullName}';
  }
}
