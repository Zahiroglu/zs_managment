import 'dart:convert';

class ModelCariCesid {
  String tarix;
  String stockKod;
  String stockAd;
  String anaQrup;
  String cariKod;
  String cariAd;
  String expKod;
  String expAd;
  String miqdar;
  String qiymet;
  String mebleg;
  String endirim1;
  String endirim2;
  String netMebleg;

  ModelCariCesid({
    required this.tarix,
    required this.stockKod,
    required this.stockAd,
    required this.anaQrup,
    required this.cariKod,
    required this.cariAd,
    required this.expKod,
    required this.expAd,
    required this.miqdar,
    required this.qiymet,
    required this.mebleg,
    required this.endirim1,
    required this.endirim2,
    required this.netMebleg,
  });

  factory ModelCariCesid.fromRawJson(String str) => ModelCariCesid.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCariCesid.fromJson(Map<String, dynamic> json) => ModelCariCesid(
    tarix: json["warehouseDate"]??"empty",
    stockKod: json["wahrehouseCode"]??"empty",
    stockAd: json["warehouseName"]??"empty",
    anaQrup: json["mainGoup"]??"empty",
    cariKod: json["customerCode"]??"empty",
    cariAd: json["customerName"]??"empty",
    expKod: json["forwarderCode"]??"empty",
    expAd: json["forwarderName"]??"empty",
    miqdar: json["quantity"].toString(),
    qiymet: json["price"].toString(),
    mebleg: json["amount"].toString(),
    endirim1: json["discount1"].toString(),
    endirim2: json["discount2"].toString(),
    netMebleg: json["amountNetto"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "tarix": tarix,
    "stock_kod": stockKod,
    "stock_ad": stockAd,
    "ana_qrup": anaQrup,
    "cari_kod": cariKod,
    "cari_ad": cariAd,
    "exp_kod": expKod,
    "exp_ad": expAd,
    "miqdar": miqdar,
    "qiymet": qiymet,
    "mebleg": mebleg,
    "endirim1": endirim1,
    "endirim2": endirim2,
    "net_mebleg": netMebleg,
  };
}
