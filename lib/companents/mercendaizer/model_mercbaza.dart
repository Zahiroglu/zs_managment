import 'dart:convert';

class ModelMercBaza {
  String? id;
  String? audit;
  String? supervaizer;
  String? rutadi;
  String? mercadi;
  String? carikod;
  String? cariad;
  String? netsatis;
  String? qaytarma;
  String? plan;
  String? gun1;
  String? gun2;
  String? gun3;
  String? gun4;
  String? gun5;
  String? gun6;
  String? gun7;
  String? expeditor;
  String? gpsUzunluq;
  String? gpsEynilik;
  int? ziyaretSayi;
  String? sndeQalmaVaxti;
  int? rutSirasi;

  ModelMercBaza({
    this.id,
    this.audit,
    this.supervaizer,
    this.rutadi,
    this.mercadi,
    this.carikod,
    this.cariad,
    this.netsatis,
    this.qaytarma,
    this.plan,
    this.gun1,
    this.gun2,
    this.gun3,
    this.gun4,
    this.gun5,
    this.gun6,
    this.gun7,
    this.expeditor,
    this.gpsUzunluq,
    this.gpsEynilik,
    this.ziyaretSayi,
    this.sndeQalmaVaxti,
    this.rutSirasi,
  });

  ModelMercBaza copyWith({
    String? id,
    String? audit,
    String? supervaizer,
    String? rutadi,
    String? mercadi,
    String? carikod,
    String? cariad,
    String? netsatis,
    String? qaytarma,
    String? plan,
    String? gun1,
    String? gun2,
    String? gun3,
    String? gun4,
    String? gun5,
    String? gun6,
    String? gun7,
    String? expeditor,
    String? gpsUzunluq,
    String? gpsEynilik,
  }) =>
      ModelMercBaza(
        id: id ?? this.id,
        audit: audit ?? this.audit,
        supervaizer: supervaizer ?? this.supervaizer,
        rutadi: rutadi ?? this.rutadi,
        mercadi: mercadi ?? this.mercadi,
        carikod: carikod ?? this.carikod,
        cariad: cariad ?? this.cariad,
        netsatis: netsatis ?? this.netsatis,
        qaytarma: qaytarma ?? this.qaytarma,
        plan: plan ?? this.plan,
        gun1: gun1 ?? this.gun1,
        gun2: gun2 ?? this.gun2,
        gun3: gun3 ?? this.gun3,
        gun4: gun4 ?? this.gun4,
        gun5: gun5 ?? this.gun5,
        gun6: gun6 ?? this.gun6,
        gun7: gun7 ?? this.gun7,
        expeditor: expeditor ?? this.expeditor,
        gpsUzunluq: gpsUzunluq ?? this.gpsUzunluq,
        gpsEynilik: gpsEynilik ?? this.gpsEynilik,
      );

  factory ModelMercBaza.fromRawJson(String str) => ModelMercBaza.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelMercBaza.fromJson(Map<String, dynamic> json) => ModelMercBaza(
    id: json["id"],
    audit: json["audit"],
    supervaizer: json["supervaizer"],
    rutadi: json["rutadi"],
    mercadi: json["mercadi"],
    carikod: json["carikod"],
    cariad: json["cariad"],
    netsatis: json["netsatis"],
    qaytarma: json["qaytarma"],
    plan: json["plan"],
    gun1: json["gun1"],
    gun2: json["gun2"],
    gun3: json["gun3"],
    gun4: json["gun4"],
    gun5: json["gun5"],
    gun6: json["gun6"],
    gun7: json["gun7"],
    expeditor: json["expeditor"],
    gpsUzunluq: json["gps_uzunluq"],
    gpsEynilik: json["gps_eynilik"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "audit": audit,
    "supervaizer": supervaizer,
    "rutadi": rutadi,
    "mercadi": mercadi,
    "carikod": carikod,
    "cariad": cariad,
    "netsatis": netsatis,
    "qaytarma": qaytarma,
    "plan": plan,
    "gun1": gun1,
    "gun2": gun2,
    "gun3": gun3,
    "gun4": gun4,
    "gun5": gun5,
    "gun6": gun6,
    "gun7": gun7,
    "expeditor": expeditor,
    "gps_uzunluq": gpsUzunluq,
    "gps_eynilik": gpsEynilik,
  };
}
