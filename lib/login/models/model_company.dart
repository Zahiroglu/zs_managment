// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

class CompanyModel {
  CompanyModel({
    this.id,
    this.name,
    this.modelModule,
  });

  int? id;
  String? name;
  List<ModelModule>? modelModule;

  CompanyModel copyWith({
    int? id,
    String? name,
    List<ModelModule>? modelModule,
  }) =>
      CompanyModel(
        id: id ?? this.id,
        name: name ?? this.name,
        modelModule: modelModule ?? this.modelModule,
      );

  factory CompanyModel.fromRawJson(String str) => CompanyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
    id: json["id"],
    name: json["name"],
    modelModule: json["ModelModule"] == null ? [] : List<ModelModule>.from(json["ModelModule"]!.map((x) => ModelModule.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ModelModule": modelModule == null ? [] : List<dynamic>.from(modelModule!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'CompanyModel{id: $id, name: $name, modelModule: $modelModule}';
  }
}

class ModelModule {
  ModelModule({
    this.id,
    this.name,
  });

  int? id;
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
