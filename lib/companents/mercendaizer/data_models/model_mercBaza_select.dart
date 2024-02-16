import 'dart:convert';

class ModelMercBazaResponce {
  String merchCode;
  String merchName;
  List<MercCustomer> mercCustomers;

  ModelMercBazaResponce({
    required this.merchCode,
    required this.merchName,
    required this.mercCustomers,
  });

  factory ModelMercBazaResponce.fromRawJson(String str) => ModelMercBazaResponce.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelMercBazaResponce.fromJson(Map<String, dynamic> json) => ModelMercBazaResponce(
    merchCode: json["merchCode"],
    merchName: json["merchName"],
    mercCustomers: List<MercCustomer>.from(json["mercCustomers"].map((x) => MercCustomer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "merchCode": merchCode,
    "merchName": merchName,
    "mercCustomers": List<dynamic>.from(mercCustomers.map((x) => x.toJson())),
  };
}

class MercCustomer {
  String merchCode;
  String customerCode;
  String forwarderCode;
  String auditCode;
  String superviserCode;
  String plan;
  String satis;
  String qaytarma;
  int day1;
  int day1Order;
  int day2;
  int day2Order;
  int day3;
  int day3Order;
  int day4;
  int day4Order;
  int day5;
  int day5Order;
  int day6;
  int day6Order;
  int day7;
  String gpsLongitude;
  String gpsLatitude;

  MercCustomer({
    required this.merchCode,
    required this.customerCode,
    required this.forwarderCode,
    required this.auditCode,
    required this.superviserCode,
    required this.plan,
    required this.satis,
    required this.qaytarma,
    required this.day1,
    required this.day1Order,
    required this.day2,
    required this.day2Order,
    required this.day3,
    required this.day3Order,
    required this.day4,
    required this.day4Order,
    required this.day5,
    required this.day5Order,
    required this.day6,
    required this.day6Order,
    required this.day7,
    required this.gpsLongitude,
    required this.gpsLatitude,
  });

  factory MercCustomer.fromRawJson(String str) => MercCustomer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MercCustomer.fromJson(Map<String, dynamic> json) => MercCustomer(
    merchCode: json["merchCode"],
    customerCode: json["customerCode"],
    forwarderCode: json["forwarderCode"],
    auditCode: json["auditCode"],
    superviserCode: json["superviserCode"],
    plan: json["plan"],
    satis: json["satis"],
    qaytarma: json["qaytarma"],
    day1: json["day1"],
    day1Order: json["day1Order"],
    day2: json["day2"],
    day2Order: json["day2Order"],
    day3: json["day3"],
    day3Order: json["day3Order"],
    day4: json["day4"],
    day4Order: json["day4Order"],
    day5: json["day5"],
    day5Order: json["day5Order"],
    day6: json["day6"],
    day6Order: json["day6Order"],
    day7: json["day7"],
    gpsLongitude: json["gpsLongitude"],
    gpsLatitude: json["gpsLatitude"],
  );

  Map<String, dynamic> toJson() => {
    "merchCode": merchCode,
    "customerCode": customerCode,
    "forwarderCode": forwarderCode,
    "auditCode": auditCode,
    "superviserCode": superviserCode,
    "plan": plan,
    "satis": satis,
    "qaytarma": qaytarma,
    "day1": day1,
    "day1Order": day1Order,
    "day2": day2,
    "day2Order": day2Order,
    "day3": day3,
    "day3Order": day3Order,
    "day4": day4,
    "day4Order": day4Order,
    "day5": day5,
    "day5Order": day5Order,
    "day6": day6,
    "day6Order": day6Order,
    "day7": day7,
    "gpsLongitude": gpsLongitude,
    "gpsLatitude": gpsLatitude,
  };
}
