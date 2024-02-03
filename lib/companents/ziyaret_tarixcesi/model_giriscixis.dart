import 'dart:convert';

class ModelGirisCixis {
  String cariKod;
  String cariAd;
  String vezifeId;
  String temKod;
  String temAd;
  String girisTarix;
  String girisMesafe;
  String girisGps;
  String cixisTarix;
  String cixisMesafe;
  String cixisGps;
  String ziyaretQeyd;
  String rutUygunluq;
  String marketUzunluq;
  String marketEynilik;

  ModelGirisCixis({
    required this.cariKod,
    required this.cariAd,
    required this.vezifeId,
    required this.temKod,
    required this.temAd,
    required this.girisTarix,
    required this.girisMesafe,
    required this.girisGps,
    required this.cixisTarix,
    required this.cixisMesafe,
    required this.cixisGps,
    required this.ziyaretQeyd,
    required this.rutUygunluq,
    required this.marketUzunluq,
    required this.marketEynilik,
  });

  factory ModelGirisCixis.fromRawJson(String str) => ModelGirisCixis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelGirisCixis.fromJson(Map<String, dynamic> json) => ModelGirisCixis(
    cariKod: json["cariKod"],
    cariAd: json["cariAd"],
    vezifeId: json["vezifeId"],
    temKod: json["temKod"],
    temAd: json["temAd"],
    girisTarix: json["girisTarix"],
    girisMesafe: json["girisMesafe"],
    girisGps: json["girisGps"],
    cixisTarix: json["cixisTarix"],
    cixisMesafe: json["cixisMesafe"],
    cixisGps: json["cixisGps"],
    ziyaretQeyd: json["ziyaretQeyd"],
    rutUygunluq: json["rutUygunluq"],
    marketUzunluq: json["marketUzunluq"],
    marketEynilik: json["marketEynilik"],
  );

  Map<String, dynamic> toJson() => {
    "cariKod": cariKod,
    "cariAd": cariAd,
    "vezifeId": vezifeId,
    "temKod": temKod,
    "temAd": temAd,
    "girisTarix": girisTarix,
    "girisMesafe": girisMesafe,
    "girisGps": girisGps,
    "cixisTarix": cixisTarix,
    "cixisMesafe": cixisMesafe,
    "cixisGps": cixisGps,
    "ziyaretQeyd": ziyaretQeyd,
    "rutUygunluq": rutUygunluq,
    "marketUzunluq": marketUzunluq,
    "marketEynilik": marketEynilik,
  };

  @override
  String toString() {
    return 'ModelGirisCixis{cariKod: $cariKod, cariAd: $cariAd, girisTarix: $girisTarix, cixisTarix: $cixisTarix}';
  }
}
