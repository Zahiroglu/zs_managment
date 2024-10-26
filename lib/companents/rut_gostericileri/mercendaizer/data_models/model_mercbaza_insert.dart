import 'dart:convert';

import '../../../base_downloads/models/model_cariler.dart';

class ModelMercBazaInsert {
  String merchCode;
  String customerCode;
  String forwarderCode;
  String auditCode;
  String superviserCode;
  double plan;
  List<Day> days;

  ModelMercBazaInsert({
    required this.merchCode,
    required this.customerCode,
    required this.forwarderCode,
    required this.auditCode,
    required this.superviserCode,
    required this.plan,
    required this.days,
  });

  factory ModelMercBazaInsert.fromRawJson(String str) => ModelMercBazaInsert.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelMercBazaInsert.fromJson(Map<String, dynamic> json) => ModelMercBazaInsert(
    merchCode: json["merchCode"],
    customerCode: json["customerCode"],
    forwarderCode: json["forwarderCode"],
    auditCode: json["auditCode"],
    superviserCode: json["superviserCode"],
    plan: json["plan"],
    days: List<Day>.from(json["Days"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "MerchCode": merchCode,
    "CustomerCode": customerCode,
    "ForwarderCode": forwarderCode,
    "AuditCode": auditCode,
    "SuperviserCode": superviserCode,
    "Plan": plan,
    "Days": days,
  };
}

class DayOrderNumber {
  int day;
  int orderNumber;

  DayOrderNumber({
    required this.day,
    required this.orderNumber,
  });

  factory DayOrderNumber.fromRawJson(String str) => DayOrderNumber.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DayOrderNumber.fromJson(Map<String, dynamic> json) => DayOrderNumber(
    day: json["day"],
    orderNumber: json["orderNumber"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "orderNumber": orderNumber,
  };
}