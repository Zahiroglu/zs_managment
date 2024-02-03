import 'dart:convert';

import 'package:hive/hive.dart';
part 'model_regions.g.dart';

@HiveType(typeId: 9)
class ModelRegions{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? code;
  @HiveField(2)
  String? name;
  @HiveField(3)
  int? level;
  @HiveField(4)
  int? parentId;
  @HiveField(5)
  String? locationLatitude;
  @HiveField(6)
  String? locationLongitude;
  @HiveField(7)
  String? address;

  ModelRegions({
    this.id,
    this.code,
    this.name,
    this.level,
    this.parentId,
    this.locationLatitude,
    this.locationLongitude,
    this.address,
  });

  ModelRegions copyWith({
    int? id,
    String? code,
    String? name,
    int? level,
    int? parentId,
    String? locationLatitude,
    String? locationLongitude,
    String? address,
  }) =>
      ModelRegions(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        level: level ?? this.level,
        parentId: parentId ?? this.parentId,
        locationLatitude: locationLatitude ?? this.locationLatitude,
        locationLongitude: locationLongitude ?? this.locationLongitude,
        address: address ?? this.address,
      );

  factory ModelRegions.fromRawJson(String str) => ModelRegions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelRegions.fromJson(Map<String, dynamic> json) => ModelRegions(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    level: json["level"],
    parentId: json["parentId"],
    locationLatitude: json["locationLatitude"],
    locationLongitude: json["locationLongitude"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "level": level,
    "parentId": parentId,
    "locationLatitude": locationLatitude,
    "locationLongitude": locationLongitude,
    "address": address,
  };

  @override
  String toString() {
    return 'ModelRegions{id: $id, code: $code, name: $name, level: $level, parentId: $parentId, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, address: $address}';
  }
}
