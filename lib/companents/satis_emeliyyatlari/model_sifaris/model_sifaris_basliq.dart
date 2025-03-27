import 'package:hive/hive.dart';

part 'model_sifaris_basliq.g.dart'; // Auto-generated fayl üçün

@HiveType(typeId: 41) // Modelin Hive üçün unikal ID-si
class ModelSifarisBasliq extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? gps;

  @HiveField(2)
  String? expdiscount;

  @HiveField(3)
  String? projectAdi;

  @HiveField(4)
  String? projectCode;

  @HiveField(5)
  String? sendClick;

  @HiveField(6)
  String? sendType;

  @HiveField(7)
  String? musteriCodu;

  @HiveField(8)
  String? musteriAdi;

  @HiveField(9)
  String? odemeTipi;

  @HiveField(10)
  String? anbarCodu;

  @HiveField(11)
  String? anbarAdi;

  @HiveField(12)
  String? catdirilmaTarixi;

  @HiveField(13)
  String? layiheCodu;

  @HiveField(14)
  String? layiheAdi;

  @HiveField(15)
  String? mesMerCodu;

  @HiveField(16)
  String? mesMerAdi;

  @HiveField(17)
  String? etrafli;

  @HiveField(18)
  String? aracem;

  @HiveField(19)
  String? endirim;

  @HiveField(20)
  String? edv;

  @HiveField(21)
  String? cem;

  @HiveField(22)
  String? faktKod;

  @HiveField(23)
  String? fDates;

  @HiveField(24)
  String? fStatus;

  @HiveField(25)
  String? faktCreateDate;

  @HiveField(26)
  String? faktPortfel;

  ModelSifarisBasliq({
    this.id,
    this.gps,
    this.expdiscount,
    this.projectAdi,
    this.projectCode,
    this.sendClick,
    this.sendType,
    this.musteriCodu,
    this.musteriAdi,
    this.odemeTipi,
    this.anbarCodu,
    this.anbarAdi,
    this.catdirilmaTarixi,
    this.layiheCodu,
    this.layiheAdi,
    this.mesMerCodu,
    this.mesMerAdi,
    this.etrafli,
    this.aracem,
    this.endirim,
    this.edv,
    this.cem,
    this.faktKod,
    this.fDates,
    this.fStatus,
    this.faktCreateDate,
    this.faktPortfel,
  });

  factory ModelSifarisBasliq.fromJson(Map<String, dynamic> json) {
    return ModelSifarisBasliq(
      id: json['id'] as int?,
      gps: json['gps'] as String?,
      expdiscount: json['expdiscount'] as String?,
      projectAdi: json['project_adi'] as String?,
      projectCode: json['project_code'] as String?,
      sendClick: json['send_click'] as String?,
      sendType: json['send_type'] as String?,
      musteriCodu: json['sifarish_musteri_codu'] as String?,
      musteriAdi: json['sifarish_musteri_adi'] as String?,
      odemeTipi: json['sifarish_odeme_tipi'] as String?,
      anbarCodu: json['sifarish_anbar_codu'] as String?,
      anbarAdi: json['sifarish_anbar_adi'] as String?,
      catdirilmaTarixi: json['sifarish_catdirilma_tarixi'] as String?,
      layiheCodu: json['sifarish_layihe_codu'] as String?,
      layiheAdi: json['sifarish_layihe_adi'] as String?,
      mesMerCodu: json['sifarish_mes_mer_codu'] as String?,
      mesMerAdi: json['sifarish_mes_mer_adi'] as String?,
      etrafli: json['sifarish_etrafli'] as String?,
      aracem: json['sifarish_aracem'] as String?,
      endirim: json['sifarish_endirim'] as String?,
      edv: json['sifarish_edv'] as String?,
      cem: json['sifarish_cem'] as String?,
      faktKod: json['sifarish_fakt_kod'] as String?,
      fDates: json['sifarish_f_dates'] as String?,
      fStatus: json['sifarish_f_status'] as String?,
      faktCreateDate: json['sifarish_fakt_create_date'] as String?,
      faktPortfel: json['sifarish_fakt_portfel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gps': gps,
      'expdiscount': expdiscount,
      'project_adi': projectAdi,
      'project_code': projectCode,
      'send_click': sendClick,
      'send_type': sendType,
      'sifarish_musteri_codu': musteriCodu,
      'sifarish_musteri_adi': musteriAdi,
      'sifarish_odeme_tipi': odemeTipi,
      'sifarish_anbar_codu': anbarCodu,
      'sifarish_anbar_adi': anbarAdi,
      'sifarish_catdirilma_tarixi': catdirilmaTarixi,
      'sifarish_layihe_codu': layiheCodu,
      'sifarish_layihe_adi': layiheAdi,
      'sifarish_mes_mer_codu': mesMerCodu,
      'sifarish_mes_mer_adi': mesMerAdi,
      'sifarish_etrafli': etrafli,
      'sifarish_aracem': aracem,
      'sifarish_endirim': endirim,
      'sifarish_edv': edv,
      'sifarish_cem': cem,
      'sifarish_fakt_kod': faktKod,
      'sifarish_f_dates': fDates,
      'sifarish_f_status': fStatus,
      'sifarish_fakt_create_date': faktCreateDate,
      'sifarish_fakt_portfel': faktPortfel,
    };
  }

  @override
  String toString() {
    return 'ModelSifarisBasliq(id: $id, gps: $gps, expdiscount: $expdiscount, projectAdi: $projectAdi, projectCode: $projectCode, sendClick: $sendClick, sendType: $sendType, musteriCodu: $musteriCodu, musteriAdi: $musteriAdi, odemeTipi: $odemeTipi, anbarCodu: $anbarCodu, anbarAdi: $anbarAdi, catdirilmaTarixi: $catdirilmaTarixi, layiheCodu: $layiheCodu, layiheAdi: $layiheAdi, mesMerCodu: $mesMerCodu, mesMerAdi: $mesMerAdi, etrafli: $etrafli, aracem: $aracem, endirim: $endirim, edv: $edv, cem: $cem, fDates: $fDates, fStatus: $fStatus, faktKod: $faktKod, faktCreateDate: $faktCreateDate, faktPortfel: $faktPortfel)';
  }
}
