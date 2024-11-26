import 'dart:convert';

import 'package:hive/hive.dart';
part 'model_customers_visit.g.dart';


@HiveType(typeId: 13)
class ModelCustuomerVisit {
  @HiveField(0)
  String? userCode;
  @HiveField(1)
  String? userPosition;
  @HiveField(2)
  String? customerCode;
  @HiveField(3)
  String? userFullName;
  @HiveField(4)
  String? customerName;
  @HiveField(5)
  String? customerLatitude;
  @HiveField(6)
  String? customerLongitude;
  @HiveField(7)
  DateTime? inDate;
  @HiveField(8)
  String? inLatitude;
  @HiveField(9)
  String? inLongitude;
  @HiveField(10)
  String? inDistance;
  @HiveField(11)
  String? inNote;
  @HiveField(12)
  DateTime? outDate;
  @HiveField(13)
  String? outLatitude;
  @HiveField(14)
  String? outLongitude;
  @HiveField(15)
  String? outDistance;
  @HiveField(16)
  String? outNote;
  @HiveField(17)
  String? workTimeInCustomer;
  @HiveField(18)
  bool? isRutDay;
  @HiveField(19)
  DateTime? inDt;
  @HiveField(20)
  String? gonderilme;
  @HiveField(21)
  String? operationType;
  int? enterCount;
  @HiveField(22)
  String? girisEdilenRutCodu;
  @HiveField(23)
  String? userPositionName;

  ModelCustuomerVisit({
    this.userCode,
    this.girisEdilenRutCodu,
    this.userPosition,
    this.customerCode,
    this.userFullName,
    this.customerName,
    this.customerLatitude,
    this.customerLongitude,
    this.inDate,
    this.inLatitude,
    this.inLongitude,
    this.inDistance,
    this.inNote,
    this.outDate,
    this.outLatitude,
    this.outLongitude,
    this.outDistance,
    this.outNote,
    this.workTimeInCustomer,
    this.isRutDay,
    this.inDt,
    this.gonderilme,
    this.enterCount,
    this.operationType,
    this.userPositionName,
  });

  factory ModelCustuomerVisit.fromRawJson(String str) => ModelCustuomerVisit.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCustuomerVisit.fromJson(Map<String, dynamic> json) => ModelCustuomerVisit(
    userCode: json["UserCode"],
    userPosition: json["UserPosition"].toString(),
    userPositionName: json["UserPositionName"].toString(),
    customerCode: json["CustomerCode"],
    userFullName: json["UserFullName"],
    customerName: json["CustomerName"],
    customerLatitude: json["CustomerLatitude"],
    customerLongitude: json["CustomerLongitude"],
    inDate: DateTime.parse(json["InDate"]),
    inLatitude: json["InLatitude"],
    inLongitude: json["InLongitude"],
    inDistance: json["InDistance"],
    inNote: json["InNote"],
    outDate: json["OutDate"]!=null?DateTime.parse(json["OutDate"]):DateTime.now(),
    outLatitude: json["OutLatitude"],
    outLongitude: json["OutLongitude"],
    outDistance: json["OutDistance"],
    outNote: json["OutNote"],
    workTimeInCustomer: json["WorkTimeInCustomer"],
    isRutDay: json["IsRutDay"],
    inDt: DateTime.parse(json["InDt"]??DateTime.now().toString()),
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userPosition": userPosition,
    "userPositionName": userPositionName,
    "customerCode": customerCode,
    "userFullName": userFullName,
    "customerName": customerName,
    "customerLatitude": customerLatitude,
    "customerLongitude": customerLongitude,
    "inDate": inDate?.toIso8601String(),
    "inLatitude": inLatitude,
    "inLongitude": inLongitude,
    "inDistance": inDistance,
    "inNote": inNote,
    "outDate": outDate?.toIso8601String(),
    "outLatitude": outLatitude,
    "outLongitude": outLongitude,
    "outDistance": outDistance,
    "outNote": outNote,
    "workTimeInCustomer": workTimeInCustomer,
    "isRutDay": isRutDay,
    "inDt": inDt?.toIso8601String(),
  };


}
