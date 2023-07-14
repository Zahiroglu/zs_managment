// To parse this JSON data, do
//
//     final modelUserPermissions = modelUserPermissionsFromJson(jsonString);

import 'dart:convert';

class ModelUserPermissions {
  int? id;
  String? code;
  String? name;
  int? val;
  String? valName;
  bool? screen;
  int? icon;
  int? selectIcon;

  ModelUserPermissions({
    this.id,
    this.code,
    this.name,
    this.val,
    this.valName,
    this.screen,
    this.icon,
    this.selectIcon,
  });

  ModelUserPermissions copyWith({
    int? id,
    String? code,
    String? name,
    int? val,
    String? valName,
    bool? screen,
    int? icon,
    int? selectIcon,
  }) =>
      ModelUserPermissions(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        val: val ?? this.val,
        valName: valName ?? this.valName,
        screen: screen ?? this.screen,
        icon: icon ?? this.icon,
        selectIcon: selectIcon ?? this.selectIcon,
      );

  factory ModelUserPermissions.fromRawJson(String str) => ModelUserPermissions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUserPermissions.fromJson(Map<String, dynamic> json) => ModelUserPermissions(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    val: json["val"],
    valName: json["valName"],
    screen: json["screen"],
    icon: json["icon"],
    selectIcon: json["selectIcon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "val": val,
    "valName": valName,
    "screen": screen,
    "icon": icon,
    "selectIcon": selectIcon,
  };
}
