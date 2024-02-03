import 'dart:convert';
import 'package:hive/hive.dart';
part 'model_carikassa.g.dart';

@HiveType(typeId: 25)
class ModelCariKassa {
  @HiveField(0)
  String? cariKod;
  @HiveField(1)
  double? kassaMebleg;
  @HiveField(2)
  bool? gonderildi;
  @HiveField(3)
  String? tarix;

  ModelCariKassa({
    this.cariKod,
    this.kassaMebleg,
    this.gonderildi,
    this.tarix,
  });

  ModelCariKassa copyWith({
    String? cariKod,
    double? kassaMebleg,
    bool? gonderildi,
    String? tarix,
  }) =>
      ModelCariKassa(
        cariKod: cariKod ?? this.cariKod,
        kassaMebleg: kassaMebleg ?? this.kassaMebleg,
        tarix: tarix ?? this.tarix,
      );

  factory ModelCariKassa.fromRawJson(String str) => ModelCariKassa.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCariKassa.fromJson(Map<String, dynamic> json) => ModelCariKassa(
    cariKod: json["cariKod"],
    kassaMebleg: json["kassaMebleg"]?.toDouble(),
    gonderildi: json["gonderildi"],
    tarix: json["tarix"],
  );

  Map<String, dynamic> toJson() => {
    "cariKod": cariKod,
    "kassaMebleg": kassaMebleg,
    "gonderildi": gonderildi,
    "tarix": tarix,
  };
}
