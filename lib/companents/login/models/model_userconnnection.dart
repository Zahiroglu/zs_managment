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

  ModelUserConnection({
    this.roleId,
    this.roleName,
    this.code,
    this.fullName,
  });

  ModelUserConnection copyWith({
    int? roleId,
    String? roleName,
    String? code,
    String? fullName,
  }) =>
      ModelUserConnection(
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
        code: code ?? this.code,
        fullName: fullName ?? this.fullName,
      );

  factory ModelUserConnection.fromRawJson(String str) => ModelUserConnection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUserConnection.fromJson(Map<String, dynamic> json) => ModelUserConnection(
    roleId: json["roleId"],
    roleName: json["roleName"],
    code: json["code"],
    fullName: json["fullName"],
  );

  Map<String, dynamic> toJson() => {
    "roleId": roleId,
    "roleName": roleName,
    "code": code,
    "fullName": fullName,
  };
}
