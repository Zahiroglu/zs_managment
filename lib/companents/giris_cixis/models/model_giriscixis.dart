import 'dart:convert';

import 'package:hive/hive.dart';
part 'model_giriscixis.g.dart';


@HiveType(typeId: 13)
class ModelGirisCixis {
  @HiveField(0)
  String? ckod;
  @HiveField(1)
  String? cariad;
  @HiveField(2)
  String? girisvaxt;
  @HiveField(3)
  String? cixisvaxt;
  @HiveField(4)
  String? girisgps;
  @HiveField(5)
  String? cixisgps;
  @HiveField(6)
  String? temsilcikodu;
  @HiveField(7)
  String? qeyd;
  @HiveField(8)
  String? girismesafe;
  @HiveField(9)
  String? cixismesafe;
  @HiveField(10)
  String? rutgunu;
  @HiveField(11)
  String? vezifeId;
  @HiveField(12)
  String? tarix;
  @HiveField(13)
  String? temsilciadi;
  @HiveField(14)
  String? gonderilme;
  @HiveField(15)
  String? marketgpsUzunluq;
  @HiveField(16)
  String? marketgpsEynilik;
  int? girisSayi;

  ModelGirisCixis({
    this.ckod,
    this.cariad,
    this.girisvaxt,
    this.cixisvaxt,
    this.girisgps,
    this.cixisgps,
    this.temsilcikodu,
    this.qeyd,
    this.girismesafe,
    this.cixismesafe,
    this.rutgunu,
    this.vezifeId,
    this.tarix,
    this.temsilciadi,
    this.gonderilme,
    this.marketgpsUzunluq,
    this.marketgpsEynilik,
    this.girisSayi,
  });

  ModelGirisCixis copyWith({
    String? ckod,
    String? cariad,
    String? girisvaxt,
    String? cixisvaxt,
    String? girisgps,
    String? cixisgps,
    String? temsilcikodu,
    String? qeyd,
    String? girismesafe,
    String? cixismesafe,
    String? rutgunu,
    String? vezifeId,
    String? tarix,
    String? temsilciadi,
    String? gonderilme,
    String? marketgps,
    String? marketgpsUzunluq,
    String? marketgpsEynilik,
    int? girisSayi,
  }) =>
      ModelGirisCixis(
        ckod: ckod ?? this.ckod,
        cariad: cariad ?? this.cariad,
        girisvaxt: girisvaxt ?? this.girisvaxt,
        cixisvaxt: cixisvaxt ?? this.cixisvaxt,
        girisgps: girisgps ?? this.girisgps,
        cixisgps: cixisgps ?? this.cixisgps,
        temsilcikodu: temsilcikodu ?? this.temsilcikodu,
        qeyd: qeyd ?? this.qeyd,
        girismesafe: girismesafe ?? this.girismesafe,
        cixismesafe: cixismesafe ?? this.cixismesafe,
        rutgunu: rutgunu ?? this.rutgunu,
        vezifeId: vezifeId ?? this.vezifeId,
        tarix: tarix ?? this.tarix,
        temsilciadi: temsilciadi ?? this.temsilciadi,
        gonderilme: gonderilme ?? this.gonderilme,
        marketgpsUzunluq: marketgpsUzunluq ?? this.marketgpsUzunluq,
        marketgpsEynilik: marketgpsEynilik ?? this.marketgpsEynilik,
        girisSayi: girisSayi ?? this.girisSayi,
      );

  factory ModelGirisCixis.fromRawJson(String str) => ModelGirisCixis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelGirisCixis.fromJson(Map<String, dynamic> json) => ModelGirisCixis(
    ckod: json["ckod"],
    cariad: json["cariad"],
    girisvaxt: json["girisvaxt"],
    cixisvaxt: json["cixisvaxt"],
    girisgps: json["girisgps"],
    cixisgps: json["cixisgps"],
    temsilcikodu: json["temsilcikodu"],
    qeyd: json["qeyd"],
    girismesafe: json["girismesafe"],
    cixismesafe: json["cixismesafe"],
    rutgunu: json["rutgunu"],
    vezifeId: json["vezife_id"],
    tarix: json["tarix"],
    temsilciadi: json["temsilciadi"],
    gonderilme: json["gonderilme"],
    marketgpsUzunluq: json["marketgpsUzunluq"],
    marketgpsEynilik: json["marketgpsEynilik"],
    girisSayi: json["girisSayi"],
  );

  Map<String, dynamic> toJson() => {
    "ckod": ckod,
    "cariad": cariad,
    "girisvaxt": girisvaxt,
    "cixisvaxt": cixisvaxt,
    "girisgps": girisgps,
    "cixisgps": cixisgps,
    "temsilcikodu": temsilcikodu,
    "qeyd": qeyd,
    "girismesafe": girismesafe,
    "cixismesafe": cixismesafe,
    "rutgunu": rutgunu,
    "vezife_id": vezifeId,
    "tarix": tarix,
    "temsilciadi": temsilciadi,
    "gonderilme": gonderilme,
    "marketgpsUzunluq": marketgpsUzunluq,
    "marketgpsEynilik": marketgpsEynilik,
    "girisSayi": girisSayi,
  };

  @override
  String toString() {
    return 'ModelGirisCixis{ckod: $ckod, cariad: $cariad, girisvaxt: $girisvaxt, cixisvaxt: $cixisvaxt, girisgps: $girisgps, cixisgps: $cixisgps, temsilcikodu: $temsilcikodu, qeyd: $qeyd, girismesafe: $girismesafe, cixismesafe: $cixismesafe, rutgunu: $rutgunu, vezifeId: $vezifeId, tarix: $tarix, temsilciadi: $temsilciadi, gonderilme: $gonderilme, marketgpsUzunluq: $marketgpsUzunluq, marketgpsEynilik: $marketgpsEynilik}';
  }
}
