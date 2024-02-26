import 'dart:convert';

class ModelCariHereket {
  String hTarixi;
  String hMusterikodu;
  String hMusteriadi;
  String hTemsilcikodu;
  String hTemsilciadi;
  String hSenedtipi;
  String hBorcmeblegi;
  String hAlacaqmeblegi;
  String hBorcbalans;
  String hSeri;
  String hSira;
  String hLimit;
  String hRecno;

  ModelCariHereket({
    required this.hTarixi,
    required this.hMusterikodu,
    required this.hMusteriadi,
    required this.hTemsilcikodu,
    required this.hTemsilciadi,
    required this.hSenedtipi,
    required this.hBorcmeblegi,
    required this.hAlacaqmeblegi,
    required this.hBorcbalans,
    required this.hSeri,
    required this.hSira,
    required this.hLimit,
    required this.hRecno,
  });

  factory ModelCariHereket.fromRawJson(String str) => ModelCariHereket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCariHereket.fromJson(Map<String, dynamic> json) => ModelCariHereket(
    hTarixi: json["h_tarixi"],
    hMusterikodu: json["h_musterikodu"],
    hMusteriadi: json["h_musteriadi"],
    hTemsilcikodu: json["h_temsilcikodu"],
    hTemsilciadi: json["h_temsilciadi"],
    hSenedtipi: json["h_senedtipi"],
    hBorcmeblegi: json["h_borcmeblegi"],
    hAlacaqmeblegi: json["h_alacaqmeblegi"],
    hBorcbalans: json["h_borcbalans"],
    hSeri: json["h_seri"],
    hSira: json["h_sira"],
    hLimit: json["h_limit"],
    hRecno: json["h_recno"],
  );

  Map<String, dynamic> toJson() => {
    "h_tarixi": hTarixi,
    "h_musterikodu": hMusterikodu,
    "h_musteriadi": hMusteriadi,
    "h_temsilcikodu": hTemsilcikodu,
    "h_temsilciadi": hTemsilciadi,
    "h_senedtipi": hSenedtipi,
    "h_borcmeblegi": hBorcmeblegi,
    "h_alacaqmeblegi": hAlacaqmeblegi,
    "h_borcbalans": hBorcbalans,
    "h_seri": hSeri,
    "h_sira": hSira,
    "h_limit": hLimit,
    "h_recno": hRecno,
  };
}
