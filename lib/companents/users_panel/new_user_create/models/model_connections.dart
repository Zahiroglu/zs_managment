import 'dart:convert';

class ModelConnections {
  int? roleId;
  String? roleName;
  int? connectionRoleId;
  String? connectionRoleName;

  ModelConnections({
    this.roleId,
    this.roleName,
    this.connectionRoleId,
    this.connectionRoleName,
  });

  ModelConnections copyWith({
    int? roleId,
    String? roleName,
    int? connectionRoleId,
    String? connectionRoleName,
  }) =>
      ModelConnections(
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
        connectionRoleId: connectionRoleId ?? this.connectionRoleId,
        connectionRoleName: connectionRoleName ?? this.connectionRoleName,
      );

  factory ModelConnections.fromRawJson(String str) => ModelConnections.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelConnections.fromJson(Map<String, dynamic> json) => ModelConnections(
    roleId: json["roleId"],
    roleName: json["roleName"],
    connectionRoleId: json["connectionRoleId"],
    connectionRoleName: json["connectionRoleName"],
  );

  Map<String, dynamic> toJson() => {
    "roleId": roleId,
    "roleName": roleName,
    "connectionRoleId": connectionRoleId,
    "connectionRoleName": connectionRoleName,
  };
}
