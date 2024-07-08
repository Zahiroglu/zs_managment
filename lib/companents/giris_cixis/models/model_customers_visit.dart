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


  ModelCustuomerVisit({
    this.userCode,
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
  });

  factory ModelCustuomerVisit.fromRawJson(String str) => ModelCustuomerVisit.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCustuomerVisit.fromJson(Map<String, dynamic> json) => ModelCustuomerVisit(
    userCode: json["userCode"],
    userPosition: json["userPosition"].toString(),
    customerCode: json["customerCode"],
    userFullName: json["userFullName"],
    customerName: json["customerName"],
    customerLatitude: json["customerLatitude"],
    customerLongitude: json["customerLongitude"],
    inDate: DateTime.parse(json["inDate"]),
    inLatitude: json["inLatitude"],
    inLongitude: json["inLongitude"],
    inDistance: json["inDistance"],
    inNote: json["inNote"],
    outDate: json["outDate"]!=null?DateTime.parse(json["outDate"]):DateTime.now(),
    outLatitude: json["outLatitude"],
    outLongitude: json["outLongitude"],
    outDistance: json["outDistance"],
    outNote: json["outNote"],
    workTimeInCustomer: json["workTimeInCustomer"],
    isRutDay: json["isRutDay"],
    inDt: DateTime.parse(json["inDt"]),
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userPosition": userPosition,
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

  @override
  String toString() {
    return 'ModelCustuomerVisit{userCode: $userCode, userPosition: $userPosition, customerCode: $customerCode, userFullName: $userFullName, customerName: $customerName, customerLatitude: $customerLatitude, customerLongitude: $customerLongitude, inDate: $inDate, inLatitude: $inLatitude, inLongitude: $inLongitude, inDistance: $inDistance, inNote: $inNote, outDate: $outDate, outLatitude: $outLatitude, outLongitude: $outLongitude, outDistance: $outDistance, outNote: $outNote, workTimeInCustomer: $workTimeInCustomer, isRutDay: $isRutDay, inDt: $inDt, gonderilme: $gonderilme, operationType: $operationType, enterCount: $enterCount}';
  }
}
