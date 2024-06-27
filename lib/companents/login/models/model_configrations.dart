import 'package:hive/hive.dart';
import 'dart:convert';

part 'model_configrations.g.dart';

@HiveType(typeId: 33)
class ModelConfigrations {
  @HiveField(1)
  int companyId;
  @HiveField(2)
  String confCode;
  @HiveField(3)
  String confVal;
  @HiveField(4)
  int roleId;
  @HiveField(5)
  String abbreaviation1;
  @HiveField(6)
  String abbreaviation2;

  ModelConfigrations({
    required this.companyId,
    required this.confCode,
    required this.confVal,
    required this.roleId,
    required this.abbreaviation1,
    required this.abbreaviation2,
  });

  factory ModelConfigrations.fromRawJson(String str) => ModelConfigrations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelConfigrations.fromJson(Map<String, dynamic> json) => ModelConfigrations(
    companyId: json["companyId"],
    confCode: json["confCode"],
    confVal: json["confVal"],
    roleId: json["roleId"],
    abbreaviation1: json["abbreaviation1"].toString(),
    abbreaviation2: json["abbreaviation2"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "confCode": confCode,
    "confVal": confVal,
    "roleId": roleId,
    "abbreaviation1": abbreaviation1,
    "abbreaviation2": abbreaviation2,
  };
}
