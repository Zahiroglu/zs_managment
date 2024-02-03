import 'dart:convert';

import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';

class ModelGunlukGirisCixis {
  String tarix;
  int girisSayi;
  String umumiIsVaxti;
  String iseBaslamaSaati;
  String isiQutarmaSaati;
  String sndeIsvaxti;
  List<ModelGirisCixis> listgiriscixis;

  ModelGunlukGirisCixis({
    required this.tarix,
    required this.girisSayi,
    required this.umumiIsVaxti,
    required this.iseBaslamaSaati,
    required this.isiQutarmaSaati,
    required this.sndeIsvaxti,
    required this.listgiriscixis,
  });

  factory ModelGunlukGirisCixis.fromRawJson(String str) => ModelGunlukGirisCixis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelGunlukGirisCixis.fromJson(Map<String, dynamic> json) => ModelGunlukGirisCixis(
    tarix: json["tarix"],
    girisSayi: json["girisSayi"],
    umumiIsVaxti: json["umumiIsVaxti"],
    iseBaslamaSaati: json["iseBaslamaSaati"],
    isiQutarmaSaati: json["isiQutarmaSaati"],
    sndeIsvaxti: json["sndeIsvaxti"],
    listgiriscixis: json["listgiriscixis"],
  );

  Map<String, dynamic> toJson() => {
    "tarix": tarix,
    "girisSayi": girisSayi,
    "umumiIsVaxti": umumiIsVaxti,
    "iseBaslamaSaati": iseBaslamaSaati,
    "isiQutarmaSaati": isiQutarmaSaati,
    "sndeIsvaxti": sndeIsvaxti,
  };

  @override
  String toString() {
    return 'ModelGunlukGirisCixis{tarix: $tarix, girisSayi: $girisSayi, umumiIsVaxti: $umumiIsVaxti, iseBaslamaSaati: $iseBaslamaSaati, isiQutarmaSaati: $isiQutarmaSaati, sndeIsvaxti: $sndeIsvaxti}';
  }
}
