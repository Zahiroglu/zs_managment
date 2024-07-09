import 'dart:convert';

import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';

import '../../giris_cixis/models/model_customers_visit.dart';

class ModelRutPerform {
  int? snSayi;
  int? rutSayi;
  int? duzgunZiya;
  int? rutkenarZiya;
  String? umumiIsvaxti;
  String? snlerdeQalma;
  int? ziyaretEdilmeyen;
  List<ModelCariler>? listGunlukRut;
  List<ModelCariler>? listZiyaretEdilmeyen;
  List<ModelCustuomerVisit>? listGirisCixislar;
  List<ModelCustuomerVisit>? listGonderilmeyenZiyaretler;

  ModelRutPerform({
    this.snSayi,
    this.rutSayi,
    this.duzgunZiya,
    this.rutkenarZiya,
    this.umumiIsvaxti,
    this.snlerdeQalma,
    this.ziyaretEdilmeyen,
    this.listGirisCixislar,
    this.listGunlukRut,
    this.listZiyaretEdilmeyen,
    this.listGonderilmeyenZiyaretler,
  });

  ModelRutPerform copyWith({
    int? snSayi,
    int? rutSayi,
    int? duzgunZiya,
    int? rutkenarZiya,
    String? umumiIsvaxti,
    String? snlerdeQalma,
    int? ziyaretEdilmeyen,
  }) =>
      ModelRutPerform(
        snSayi: snSayi ?? this.snSayi,
        rutSayi: rutSayi ?? this.rutSayi,
        duzgunZiya: duzgunZiya ?? this.duzgunZiya,
        rutkenarZiya: rutkenarZiya ?? this.rutkenarZiya,
        umumiIsvaxti: umumiIsvaxti ?? this.umumiIsvaxti,
        snlerdeQalma: snlerdeQalma ?? this.snlerdeQalma,
        ziyaretEdilmeyen: ziyaretEdilmeyen ?? this.ziyaretEdilmeyen,
      );

  factory ModelRutPerform.fromRawJson(String str) => ModelRutPerform.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelRutPerform.fromJson(Map<String, dynamic> json) => ModelRutPerform(
    snSayi: json["snSayi"],
    rutSayi: json["rutSayi"],
    duzgunZiya: json["duzgunZiya"],
    rutkenarZiya: json["rutkenarZiya"],
    umumiIsvaxti: json["umumiIsvaxti"],
    snlerdeQalma: json["snlerdeQalma"],
    ziyaretEdilmeyen: json["ziyaretEdilmeyen"],
  );

  Map<String, dynamic> toJson() => {
    "snSayi": snSayi,
    "rutSayi": rutSayi,
    "duzgunZiya": duzgunZiya,
    "rutkenarZiya": rutkenarZiya,
    "umumiIsvaxti": umumiIsvaxti,
    "snlerdeQalma": snlerdeQalma,
    "ziyaretEdilmeyen": ziyaretEdilmeyen,
  };

  @override
  String toString() {
    return "sn sayi :"+snSayi.toString()+" ,rutSayi :"+rutSayi.toString()+" duzgunZiya : "+duzgunZiya.toString()+" rutkenarZiya : "+rutkenarZiya.toString()
    +" listGunlukRut : "+listGunlukRut!.length.toString()+" listGirisCixislar : "+listGirisCixislar!.length.toString();
  }
}
