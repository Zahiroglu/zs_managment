import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';

part 'merc_data_model.g.dart';

@HiveType(typeId: 27)
class MercDataModel {
  @HiveField(1)
  double? totalPlans;
  @HiveField(2)
  double? totalSelling;
  @HiveField(3)
  double? totalRefund;
  @HiveField(4)
  String? code;
  @HiveField(5)
  String? name;
  @HiveField(6)
  List<MercCustomersDatail>? mercCustomersDatail;

  MercDataModel({
    this.totalPlans,
    this.totalSelling,
    this.totalRefund,
    this.code,
    this.name,
    this.mercCustomersDatail,
  });

  factory MercDataModel.fromRawJson(String str) => MercDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MercDataModel.fromJson(Map<String, dynamic> json) => MercDataModel(
    totalPlans: json["totalPlans"],
    totalSelling: json["totalSelling"],
    totalRefund: json["totalRefund"],
    code: json["code"],
    name: json["name"],
    mercCustomersDatail: List<MercCustomersDatail>.from(json["mercCustomersDatail"].map((x) => MercCustomersDatail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPlans": totalPlans,
    "totalSelling": totalSelling,
    "totalRefund": totalRefund,
    "code": code,
    "name": name,
    "mercCustomersDatail": List<dynamic>.from(mercCustomersDatail!.map((x) => x.toJson())),
  };
}

@HiveType(typeId: 28)
class MercCustomersDatail {
  @HiveField(1)
  String? code;
  @HiveField(2)
  String? name;
  @HiveField(3)
  double? plans;
  @HiveField(4)
  double? selling;
  @HiveField(5)
  double? refund;
  @HiveField(6)
  String? fullAddress;
  @HiveField(7)
  String? area;
  @HiveField(8)
  String? category;
  @HiveField(9)
  String? latitude;
  @HiveField(10)
  String? longitude;
  @HiveField(11)
  String? district;
  @HiveField(12)
  bool? action;
  @HiveField(13)
  List<Day>? days;
  @HiveField(14)
  String? forwarderCode;
  int? ziyaretSayi;
  String? sndeQalmaVaxti;

  MercCustomersDatail({
    this.code,
    this.name,
    this.plans,
     this.selling,
     this.refund,
     this.fullAddress,
     this.forwarderCode,
     this.area,
     this.category,
     this.latitude,
     this.longitude,
     this.district,
     this.action,
     this.days,
     this.ziyaretSayi,
     this.sndeQalmaVaxti,
  });

  factory MercCustomersDatail.fromRawJson(String str) => MercCustomersDatail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MercCustomersDatail.fromJson(Map<String, dynamic> json) => MercCustomersDatail(
    code: json["code"],
    name: json["name"],
    plans: json["plans"],
    selling: json["selling"],
    refund: json["refund"],
    fullAddress: json["fullAddress"],
    area: json["area"],
    category: json["category"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    district: json["district"],
    action: json["action"],
    forwarderCode: json["forwarderCode"],
    days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "plans": plans,
    "selling": selling,
    "refund": refund,
    "fullAddress": fullAddress,
    "area": area,
    "category": category,
    "latitude": latitude,
    "longitude": longitude,
    "district": district,
    "action": action,
    "forwarderCode": forwarderCode,
    "days": List<dynamic>.from(days!.map((x) => x.toJson())),
  };
}

