import 'dart:convert';
import 'package:hive/hive.dart';
part 'model_downloads.g.dart';


@HiveType(typeId: 23)
class ModelDownloads {
  @HiveField(0)
  String? code;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? lastDownDay;
  @HiveField(3)
  bool? musteDonwload;
  @HiveField(4)
  String? info;
  bool? donloading;

  ModelDownloads({
    this.code,
    this.name,
    this.lastDownDay,
    this.musteDonwload,
    this.info,
    this.donloading,
  });

  ModelDownloads copyWith({
    String? code,
    String? name,
    String? lastDownDay,
    bool? musteDonwload,
    String? info,
  }) =>
      ModelDownloads(
        code: code ?? this.code,
        name: name ?? this.name,
        lastDownDay: lastDownDay ?? this.lastDownDay,
        musteDonwload: musteDonwload ?? this.musteDonwload,
        info: info ?? this.info,
      );

  factory ModelDownloads.fromRawJson(String str) => ModelDownloads.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelDownloads.fromJson(Map<String, dynamic> json) => ModelDownloads(
    code: json["code"],
    name: json["name"],
    lastDownDay: json["lastDownDay"],
    musteDonwload: json["musteDonwload"],
    info: json["info"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "lastDownDay": lastDownDay,
    "musteDonwload": musteDonwload,
    "info": info,
  };

  @override
  String toString() {
    return 'ModelDownloads{code: $code, name: $name, lastDownDay: $lastDownDay, musteDonwload: $musteDonwload, info: $info}';
  }
}
