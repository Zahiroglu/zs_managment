import 'dart:convert';

class ModelMercBazaInsert {
  String merchCode;
  String customerCode;
  String forwarderCode;
  String auditCode;
  String superviserCode;
  String plan;
  List<DayOrderNumber> days;
  int day1;
  int day2;
  int day3;
  int day4;
  int day5;
  int day6;
  int day7;
  int orderNumber;

  ModelMercBazaInsert({
    required this.merchCode,
    required this.customerCode,
    required this.forwarderCode,
    required this.auditCode,
    required this.superviserCode,
    required this.plan,
    required this.days,
    required this.day1,
    required this.day2,
    required this.day3,
    required this.day4,
    required this.day5,
    required this.day6,
    required this.day7,
    required this.orderNumber,
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
    days: List<DayOrderNumber>.from(json["days"].map((x) => DayOrderNumber.fromJson(x))),
    day1: json["day1"],
    day2: json["day2"],
    day3: json["day3"],
    day4: json["day4"],
    day5: json["day5"],
    day6: json["day6"],
    day7: json["day7"],
    orderNumber: json["orderNumber"],
  );

  Map<String, dynamic> toJson() => {
    "merchCode": merchCode,
    "customerCode": customerCode,
    "forwarderCode": forwarderCode,
    "auditCode": auditCode,
    "superviserCode": superviserCode,
    "plan": plan,
    "days": List<dynamic>.from(days.map((x) => x.toJson())),
    "day1": day1,
    "day2": day2,
    "day3": day3,
    "day4": day4,
    "day5": day5,
    "day6": day6,
    "day7": day7,
    "orderNumber": orderNumber,
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