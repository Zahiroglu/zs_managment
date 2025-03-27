import 'package:hive/hive.dart';

part 'model_sifaris_mallar.g.dart'; // Auto-generated fayl üçün

@HiveType(typeId: 40)// Modelin Hive üçün unikal ID-si
class ModelSifarisMallar extends HiveObject {

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? stockId;

  @HiveField(2)
  String? kodu;

  @HiveField(3)
  String? adi;

  @HiveField(4)
  double? qiymet;

  @HiveField(5)
  int? miqdar;

  @HiveField(6)
  int? qaliq;

  @HiveField(7)
  String? confirm;

  @HiveField(8)
  double? faiz;

  @HiveField(9)
  double? endirim;

  @HiveField(10)
  double? cem;

  @HiveField(11)
  int? faId;

  @HiveField(12)
  double? yekunMiqd;

  @HiveField(13)
  String? vahid;

  @HiveField(14)
  String? bolen;

  @HiveField(15)
  String? kompaniyaStatus;

  @HiveField(16)
  String? anbarNo;

  @HiveField(17)
  double? goodDiscount;

  @HiveField(18)
  double? aracem;

  @HiveField(19)
  double? faizIskonto1;

  @HiveField(20)
  double? cemIskonto1;

  @HiveField(21)
  double? faizIskonto2;

  @HiveField(22)
  double? cemIskonto2;

  @HiveField(23)
  double? faizIskonto3;

  @HiveField(24)
  double? cemIskonto3;

  @HiveField(25)
  double? faizIskonto4;

  @HiveField(26)
  double? cemIskonto4;

  @HiveField(27)
  String? note;

  @HiveField(28)
  double? rangeFilter;

  @HiveField(29)
  double? rangePercent;

  @HiveField(30)
  double? rangeSum;

  @HiveField(31)
  String? scanNum;

  @HiveField(32)
  double? stokKg;

  @HiveField(33)
  double? edv;

  @HiveField(34)
  double? vatValue;

  ModelSifarisMallar({
  this.id,
  this.stockId,
  this.kodu,
  this.adi,
  this.qiymet,
  this.miqdar,
  this.qaliq,
  this.confirm,
  this.faiz,
  this.endirim,
  this.cem,
  this.faId,
  this.yekunMiqd,
  this.vahid,
  this.bolen,
  this.kompaniyaStatus,
  this.anbarNo,
  this.goodDiscount,
  this.aracem,
  this.faizIskonto1,
  this.cemIskonto1,
  this.faizIskonto2,
  this.cemIskonto2,
  this.faizIskonto3,
  this.cemIskonto3,
  this.faizIskonto4,
  this.cemIskonto4,
  this.note,
  this.rangeFilter,
  this.rangePercent,
  this.rangeSum,
  this.scanNum,
  this.stokKg,
  this.edv,
  this.vatValue,
  });

  /// JSON-dan obyektə çevirir
  factory ModelSifarisMallar.fromJson(Map<String, dynamic> json) {
  return ModelSifarisMallar(
  id: json['id'] as int?,
  stockId: json['stock_id'] as String?,
  kodu: json['kodu'] as String?,
  adi: json['adi'] as String?,
  qiymet: (json['qiymet'] as num?)?.toDouble(),
  miqdar: json['miqdar'] as int?,
  qaliq: json['qaliq'] as int?,
  confirm: json['confirm'] as String?,
  faiz: (json['faiz'] as num?)?.toDouble(),
  endirim: (json['endirim'] as num?)?.toDouble(),
  cem: (json['cem'] as num?)?.toDouble(),
  faId: json['fa_id'] as int?,
  yekunMiqd: (json['yekun_miqd'] as num?)?.toDouble(),
  vahid: json['vahid'] as String?,
  bolen: json['bolen'] as String?,
  kompaniyaStatus: json['kompaniya_status'] as String?,
  anbarNo: json['anbarNo'] as String?,
  goodDiscount: (json['gooddiscount'] as num?)?.toDouble(),
  aracem: (json['aracem'] as num?)?.toDouble(),
  faizIskonto1: (json['Faiz_Iskonto1'] as num?)?.toDouble(),
  cemIskonto1: (json['Cem_Iskonto1'] as num?)?.toDouble(),
  faizIskonto2: (json['Faiz_Iskonto2'] as num?)?.toDouble(),
  cemIskonto2: (json['Cem_Iskonto2'] as num?)?.toDouble(),
  faizIskonto3: (json['Faiz_Iskonto3'] as num?)?.toDouble(),
  cemIskonto3: (json['Cem_Iskonto3'] as num?)?.toDouble(),
  faizIskonto4: (json['Faiz_Iskonto4'] as num?)?.toDouble(),
  cemIskonto4: (json['Cem_Iskonto4'] as num?)?.toDouble(),
  note: json['Note'] as String?,
  rangeFilter: (json['RangeFilter'] as num?)?.toDouble(),
  rangePercent: (json['RangePercent'] as num?)?.toDouble(),
  rangeSum: (json['RangeSum'] as num?)?.toDouble(),
  scanNum: json['ScanNum'] as String?,
  stokKg: (json['stok_kg'] as num?)?.toDouble(),
  edv: (json['edv'] as num?)?.toDouble(),
  vatValue: (json['vat_value'] as num?)?.toDouble(),
  );
  }

  /// Obyekti JSON-a çevirir
  Map<String, dynamic> toJson() {
  return {
  'id': id,
  'stock_id': stockId,
  'kodu': kodu,
  'adi': adi,
  'qiymet': qiymet,
  'miqdar': miqdar,
  'qaliq': qaliq,
  'confirm': confirm,
  'faiz': faiz,
  'endirim': endirim,
  'cem': cem,
  'fa_id': faId,
  'yekun_miqd': yekunMiqd,
  'vahid': vahid,
  'bolen': bolen,
  'kompaniya_status': kompaniyaStatus,
  'anbarNo': anbarNo,
  'gooddiscount': goodDiscount,
  'aracem': aracem,
  'Faiz_Iskonto1': faizIskonto1,
  'Cem_Iskonto1': cemIskonto1,
  'Faiz_Iskonto2': faizIskonto2,
  'Cem_Iskonto2': cemIskonto2,
  'Faiz_Iskonto3': faizIskonto3,
  'Cem_Iskonto3': cemIskonto3,
  'Faiz_Iskonto4': faizIskonto4,
  'Cem_Iskonto4': cemIskonto4,
  'Note': note,
  'RangeFilter': rangeFilter,
  'RangePercent': rangePercent,
  'RangeSum': rangeSum,
  'ScanNum': scanNum,
  'stok_kg': stokKg,
  'edv': edv,
  'vat_value': vatValue,
  };
  }
  }
