import 'dart:convert';
import 'package:hive/hive.dart';
part 'model_carihereket.g.dart';


@HiveType(typeId: 24)
class ModelCariHereket {
  @HiveField(0)
  String? cariKod;
  @HiveField(1)
  String? stockKod;
  @HiveField(2)
  String? temKod;
  @HiveField(3)
  double? qiymet;
  @HiveField(4)
  int? miqdar;
  @HiveField(5)
  double? netSatis;
  @HiveField(6)
  double? endirimMebleg;
  @HiveField(7)
  bool? gonderildi;
  @HiveField(8)
  String? tarix;
  @HiveField(9)
  String? anaQrup;

  ModelCariHereket({
    this.cariKod,
    this.stockKod,
    this.temKod,
    this.qiymet,
    this.miqdar,
    this.netSatis,
    this.endirimMebleg,
    this.gonderildi,
    this.tarix,
    this.anaQrup,
  });

  ModelCariHereket copyWith({
    String? cariKod,
    String? stockKod,
    String? temKod,
    double? qiymet,
    int? miqdar,
    double? netSatis,
    double? endirimMebleg,
    bool? gonderildi,
    String? tarix,
    String? anaQrup,
  }) =>
      ModelCariHereket(
        cariKod: cariKod ?? this.cariKod,
        stockKod: stockKod ?? this.stockKod,
        temKod: temKod ?? this.temKod,
        qiymet: qiymet ?? this.qiymet,
        miqdar: miqdar ?? this.miqdar,
        netSatis: netSatis ?? this.netSatis,
        endirimMebleg: endirimMebleg ?? this.endirimMebleg,
        gonderildi: gonderildi ?? this.gonderildi,
        tarix: tarix ?? this.tarix,
        anaQrup: anaQrup ?? this.anaQrup,
      );

  factory ModelCariHereket.fromRawJson(String str) => ModelCariHereket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCariHereket.fromJson(Map<String, dynamic> json) => ModelCariHereket(
    cariKod: json["cariKod"],
    stockKod: json["stockKod"],
    temKod: json["temKod"],
    qiymet: json["qiymet"]?.toDouble(),
    miqdar: json["miqdar"],
    netSatis: json["netSatis"]?.toDouble(),
    endirimMebleg: json["endirimMebleg"]?.toDouble(),
    gonderildi: json["gonderildi"],
    tarix: json["tarix"],
    anaQrup: json["anaQrup"],
  );

  Map<String, dynamic> toJson() => {
    "cariKod": cariKod,
    "stockKod": stockKod,
    "temKod": temKod,
    "qiymet": qiymet,
    "miqdar": miqdar,
    "netSatis": netSatis,
    "endirimMebleg": endirimMebleg,
    "gonderildi": gonderildi,
    "tarix": tarix,
    "anaQrup": anaQrup,
  };

  @override
  String toString() {
    return 'ModelCariHereket{cariKod: $cariKod, stockKod: $stockKod, qiymet: $qiymet, miqdar: $miqdar, netSatis: $netSatis, tarix: $tarix, anaQrup: $anaQrup}';
  }
}
