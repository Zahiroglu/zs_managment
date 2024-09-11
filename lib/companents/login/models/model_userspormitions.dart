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
  @HiveField(9)
  bool? byUser;
  @HiveField(10)
  String? dvc;
  @HiveField(11)
  String? url;

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
    this.byUser,
    this.dvc,
    this.url,
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
    bool? byUser,
    String? dvc,
    String? url,
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
        byUser: byUser ?? this.byUser,
        dvc: dvc ?? this.dvc,
        url: url ?? this.url,
      );

  factory ModelUserPermissions.fromRawJson(String str) => ModelUserPermissions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUserPermissions.fromJson(Map<String, dynamic> json) => ModelUserPermissions(
    id: json["PerId"],
    code: json["Code"],
    name: json["Name"],
    val: json["Val"],
    valName: json["Explanation"],
    screen: json["Screen"],
    icon: json["Icon"],
    selectIcon: json["SelectIcon"],
    category: json["Category"],
    byUser: json["ByUser"],
    dvc: json["Dvc"],
    url: json["Url"],
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
    "byUser": byUser,
    "dvc": dvc,
    "url": url,
  };

  @override
  String toString() {
    return 'ModelUserPermissions{code: $code, name: $name, val: $val, valName: $valName, screen: $screen, category: $category, byUser: $byUser, dvc: $dvc, url: $url}';
  }
}
