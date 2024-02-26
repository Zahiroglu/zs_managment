import 'dart:convert';

class ModelFaktura {
  String fTarix;
  String fSeri;
  String fSira;
  String fQaytarma;
  String fFakturayip;
  String fStockod;
  String fStocismi;
  String fCariad;
  String fCarikod;
  String fTemsilci;
  String fTemsilciadi;
  String fMiktar;
  String fNetmebleg;
  String fBrutmebleg;
  String fEndirim;
  String fQiymet;
  String fVahid;

  ModelFaktura({
    required this.fTarix,
    required this.fSeri,
    required this.fSira,
    required this.fQaytarma,
    required this.fFakturayip,
    required this.fStockod,
    required this.fStocismi,
    required this.fCariad,
    required this.fCarikod,
    required this.fTemsilci,
    required this.fTemsilciadi,
    required this.fMiktar,
    required this.fNetmebleg,
    required this.fBrutmebleg,
    required this.fEndirim,
    required this.fQiymet,
    required this.fVahid,
  });

  factory ModelFaktura.fromRawJson(String str) => ModelFaktura.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelFaktura.fromJson(Map<String, dynamic> json) => ModelFaktura(
    fTarix: json["f_tarix"],
    fSeri: json["f_seri"],
    fSira: json["f_sira"],
    fQaytarma: json["f_qaytarma"],
    fFakturayip: json["f_fakturayip"],
    fStockod: json["f_stockod"],
    fStocismi: json["f_stocismi"],
    fCariad: json["f_cariad"],
    fCarikod: json["f_carikod"],
    fTemsilci: json["f_temsilci"],
    fTemsilciadi: json["f_temsilciadi"],
    fMiktar: json["f_miktar"],
    fNetmebleg: json["f_netmebleg"],
    fBrutmebleg: json["f_brutmebleg"],
    fEndirim: json["f_endirim"],
    fQiymet: json["f_qiymet"],
    fVahid: json["f_vahid"],
  );

  Map<String, dynamic> toJson() => {
    "f_tarix": fTarix,
    "f_seri": fSeri,
    "f_sira": fSira,
    "f_qaytarma": fQaytarma,
    "f_fakturayip": fFakturayip,
    "f_stockod": fStockod,
    "f_stocismi": fStocismi,
    "f_cariad": fCariad,
    "f_carikod": fCarikod,
    "f_temsilci": fTemsilci,
    "f_temsilciadi": fTemsilciadi,
    "f_miktar": fMiktar,
    "f_netmebleg": fNetmebleg,
    "f_brutmebleg": fBrutmebleg,
    "f_endirim": fEndirim,
    "f_qiymet": fQiymet,
    "f_vahid": fVahid,
  };
}
