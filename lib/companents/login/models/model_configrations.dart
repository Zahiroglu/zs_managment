import 'package:hive/hive.dart';
import 'dart:convert';

part 'model_configrations.g.dart';

@HiveType(typeId: 33)
class ModelConfigrations {
  @HiveField(1)
  int configId;
  @HiveField(2)
  String confCode;
  @HiveField(3)
  String confVal;
  @HiveField(4)
  String data1;
  @HiveField(5)
  String data2;

  ModelConfigrations({
    required this.configId,
    required this.confCode,
    required this.confVal,
    required this.data1,
    required this.data2,
  });

  factory ModelConfigrations.fromRawJson(String str) => ModelConfigrations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelConfigrations.fromJson(Map<String, dynamic> json) => ModelConfigrations(
    configId: json["ConfigId"],
    confCode: json["ConfigCode"],
    confVal: json["ConfigVal"],
    data1: json["DataValue1"].toString(),
    data2: json["DataValue2"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "ConfigId": configId,
    "ConfigCode": confCode,
    "ConfigVal": confVal,
    "DataValue1": data1,
    "DataValue2": data2,
  };
}
