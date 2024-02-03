import 'dart:convert';

class ModelRoles {
  int? id;
  String? roleName;

  ModelRoles({
    this.id,
    this.roleName,
  });

  ModelRoles copyWith({
    int? id,
    String? roleName,
  }) =>
      ModelRoles(
        id: id ?? this.id,
        roleName: roleName ?? this.roleName,
      );

  factory ModelRoles.fromRawJson(String str) => ModelRoles.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelRoles.fromJson(Map<String, dynamic> json) => ModelRoles(
    id: json["id"],
    roleName: json["roleName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "roleName": roleName,
  };
}
