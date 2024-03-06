import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
part 'merc_data_model.g.dart';

@HiveType(typeId: 27)
class MercDataModel {
  @HiveField(1)
  UserMerc? user;
  @HiveField(2)
  List<MercCustomersDatail>? mercCustomersDatail;

  MercDataModel({
    this.user,
    this.mercCustomersDatail,
  });

  factory MercDataModel.fromRawJson(String str) => MercDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MercDataModel.fromJson(Map<String, dynamic> json) => MercDataModel(
    user: UserMerc.fromJson(json["user"]),
    mercCustomersDatail: List<MercCustomersDatail>.from(json["customers"].map((x) => MercCustomersDatail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "mercCustomersDatail": List<dynamic>.from(mercCustomersDatail!.map((x) => x.toJson())),
  };
}

@HiveType(typeId: 28)
class MercCustomersDatail {
  @HiveField(1)
  String code;
  @HiveField(2)
  String name;
  @HiveField(3)
  String fullAddress;
  @HiveField(4)
  String ownerPerson;
  @HiveField(5)
  String phone;
  @HiveField(6)
  String postalCode;
  @HiveField(7)
  String area;
  @HiveField(8)
  String category;
  @HiveField(9)
  String regionalDirectorCode;
  @HiveField(10)
  String salesDirectorCode;
  @HiveField(11)
  String latitude;
  @HiveField(12)
  String longitude;
  @HiveField(13)
  String district;
  @HiveField(14)
  String tin;
  @HiveField(15)
  String mainCustomer;
  @HiveField(16)
  double debt;
  @HiveField(17)
  bool action;
  @HiveField(18)
  List<Day> days;
  @HiveField(19)
  List<SellingData> sellingDatas;
  @HiveField(20)
  double totalPlan;
  @HiveField(21)
  double totalSelling;
  @HiveField(22)
  double totalRefund;
  int? ziyaretSayi;
  String? sndeQalmaVaxti;

  MercCustomersDatail({
    required this.code,
    required this.name,
    required this.fullAddress,
    required this.ownerPerson,
    required this.phone,
    required this.postalCode,
    required this.area,
    required this.category,
    required this.regionalDirectorCode,
    required this.salesDirectorCode,
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.tin,
    required this.mainCustomer,
    required this.debt,
    required this.action,
    required this.days,
    required this.sellingDatas,
    required this.totalPlan,
    required this.totalSelling,
    required this.totalRefund,
    this.ziyaretSayi,
    this.sndeQalmaVaxti,
  });

  factory MercCustomersDatail.fromRawJson(String str) => MercCustomersDatail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MercCustomersDatail.fromJson(Map<String, dynamic> json) => MercCustomersDatail(
    code: json["code"],
    name: json["name"],
    fullAddress: json["fullAddress"],
    ownerPerson: json["ownerPerson"],
    phone: json["phone"],
    postalCode: json["postalCode"],
    area: json["area"],
    category: json["category"],
    regionalDirectorCode: json["regionalDirectorCode"],
    salesDirectorCode: json["salesDirectorCode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    district: json["district"],
    tin: json["tin"],
    mainCustomer: json["mainCustomer"],
    debt: json["debt"],
    action: json["action"],
    days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
    sellingDatas: List<SellingData>.from(json["sellingDatas"].map((x) => SellingData.fromJson(x))),
    totalPlan: json["totalPlan"],
    totalSelling: json["totalSelling"],
    totalRefund: json["totalRefund"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "fullAddress": fullAddress,
    "ownerPerson": ownerPerson,
    "phone": phone,
    "postalCode": postalCode,
    "area": area,
    "category": category,
    "regionalDirectorCode": regionalDirectorCode,
    "salesDirectorCode": salesDirectorCode,
    "latitude": latitude,
    "longitude": longitude,
    "district": district,
    "tin": tin,
    "mainCustomer": mainCustomer,
    "debt": debt,
    "action": action,
    "days": List<dynamic>.from(days.map((x) => x.toJson())),
    "sellingDatas": List<dynamic>.from(sellingDatas.map((x) => x.toJson())),
    "totalPlan": totalPlan,
    "totalSelling": totalSelling,
    "totalRefund": totalRefund,
  };
}


@HiveType(typeId: 29)
class SellingData {
  @HiveField(1)
  String forwarderCode;
  @HiveField(2)
  double plans;
  @HiveField(3)
  double selling;
  @HiveField(4)
  double remainder;
  @HiveField(5)
  double refund;

  SellingData({
    required this.forwarderCode,
    required this.plans,
    required this.selling,
    required this.remainder,
    required this.refund,
  });

  factory SellingData.fromRawJson(String str) => SellingData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SellingData.fromJson(Map<String, dynamic> json) => SellingData(
    forwarderCode: json["forwarderCode"],
    plans: json["plans"],
    selling: json["selling"],
    remainder: json["remainder"],
    refund: json["refund"],
  );

  Map<String, dynamic> toJson() => {
    "forwarderCode": forwarderCode,
    "plans": plans,
    "selling": selling,
    "remainder": remainder,
    "refund": refund,
  };
}

@HiveType(typeId: 5)
class UserMerc {
  @HiveField(1)
  String code;
  @HiveField(2)
  String name;
  @HiveField(3)
  double totalPlan;
  @HiveField(4)
  double totalSelling;
  @HiveField(5)
  double totalRefund;

  UserMerc({
    required this.code,
    required this.name,
    required this.totalPlan,
    required this.totalSelling,
    required this.totalRefund,
  });

  factory UserMerc.fromRawJson(String str) => UserMerc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserMerc.fromJson(Map<String, dynamic> json) => UserMerc(
    code: json["code"],
    name: json["name"],
    totalPlan: json["totalPlan"],
    totalSelling: json["totalSelling"],
    totalRefund: json["totalRefund"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "totalPlan": totalPlan,
    "totalSelling": totalSelling,
    "totalRefund": totalRefund,
  };
}
