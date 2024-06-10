import 'dart:convert';

import 'package:hive/hive.dart';
part 'model_anbarrapor.g.dart';

@HiveType(typeId: 22)
class ModelAnbarRapor {
  @HiveField(0)
  String? stokkod;
  @HiveField(1)
  String? stokadi;
  @HiveField(2)
  String? anaqrup;
  @HiveField(3)
  String? qaliq;
  @HiveField(4)
  String? vahidbir;
  @HiveField(5)
  String? satisqiymeti;


  ModelAnbarRapor({
    this.stokkod,
    this.stokadi,
    this.anaqrup,
    this.qaliq,
    this.vahidbir,
    this.satisqiymeti,
  });

  ModelAnbarRapor copyWith({
    String? stokkod,
    String? stokadi,
    String? anaqrup,
    String? qaliq,
    String? vahidbir,
    String? satisqiymeti,
  }) =>
      ModelAnbarRapor(
        stokkod: stokkod ?? this.stokkod,
        stokadi: stokadi ?? this.stokadi,
        anaqrup: anaqrup ?? this.anaqrup,
        qaliq: qaliq ?? this.qaliq,
        vahidbir: vahidbir ?? this.vahidbir,
        satisqiymeti: satisqiymeti ?? this.satisqiymeti,
      );

  factory ModelAnbarRapor.fromRawJson(String str) => ModelAnbarRapor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelAnbarRapor.fromJson(Map<String, dynamic> json) => ModelAnbarRapor(
    stokkod: json["warehouseCode"],
    stokadi: json["warehouseName"],
    anaqrup: json["mainGoup"],
    qaliq: json["remainder"].toString(),
    vahidbir: json["quantityUnit"],
    satisqiymeti: json["price"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "warehouseCode": stokkod,
    "warehouseName": stokadi,
    "mainGoup": anaqrup,
    "remainder": qaliq,
    "quantityUnit": vahidbir,
    "price": satisqiymeti,
  };

  @override
  String toString() {
    return 'ModelAnbarRapor{stokkod: $stokkod, stokadi: $stokadi, anaqrup: $anaqrup, qaliq: $qaliq, vahidbir: $vahidbir, satisqiymeti: $satisqiymeti}';
  }
}
