// To parse this JSON data, do
//
//     final modelUserPermissions = modelUserPermissionsFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
part 'model_userspormitions.g.dart';


@HiveType(typeId: 7)
class ModelUserPermissions {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? code;
  @HiveField(2)
  String? name;
  @HiveField(3)
  int? val;
  @HiveField(4)
  String? valName;
  @HiveField(5)
  bool? screen;
  @HiveField(6)
  int? icon;
  @HiveField(7)
  int? selectIcon;
  @HiveField(8)
  int? category;

  ModelUserPermissions({
    this.id,
    this.code,
    this.name,
    this.val,
    this.valName,
    this.screen,
    this.icon,
    this.selectIcon,
    this.category,
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
    int? category,
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
        category: category ?? this.category,
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
    category: json["category"],
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
    "category": category,
  };

  @override
  String toString() {
    return 'ModelUserPermissions{id: $id, code: $code, name: $name, val: $val, valName: $valName, screen: $screen, icon: $icon, selectIcon: $selectIcon, category: $category}';
  }
}
