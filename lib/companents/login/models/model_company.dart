// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'model_company.g.dart';

@HiveType(typeId: 4)
class CompanyModel {
  CompanyModel({
    this.id,
    this.name,
    this.modules,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  List<ModelModule>? modules;

  CompanyModel copyWith({
    int? id,
    String? name,
    List<ModelModule>? modules,
  }) =>
      CompanyModel(
        id: id ?? this.id,
        name: name ?? this.name,
        modules: modules ?? this.modules,
      );

  factory CompanyModel.fromRawJson(String str) => CompanyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
    id: json["id"],
    name: json["name"],
    modules: json["modules"] == null ? [] : List<ModelModule>.from(json["modules"]!.map((x) => ModelModule.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "modules": modules == null ? [] : List<dynamic>.from(modules!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'CompanyModel{id: $id, name: $name, modules: $modules}';
  }
}
@HiveType(typeId: 8)
class ModelModule {
  ModelModule({
    this.id,
    this.name,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;

  ModelModule copyWith({
    int? id,
    String? name,
  }) =>
      ModelModule(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory ModelModule.fromRawJson(String str) => ModelModule.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelModule.fromJson(Map<String, dynamic> json) => ModelModule(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  String toString() {
    return 'ModelModule{id: $id, name: $name}';
  }
}
