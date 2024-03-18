import 'dart:convert';

import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';

class ModelUpdateMercCustomers {
  String merchCode;
  String customerCode;
  List<Plan> plans;
  List<Day> days;
  ChangeMerch changeMerch;

  ModelUpdateMercCustomers({
    required this.merchCode,
    required this.customerCode,
    required this.plans,
    required this.days,
    required this.changeMerch,
  });

  factory ModelUpdateMercCustomers.fromRawJson(String str) => ModelUpdateMercCustomers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUpdateMercCustomers.fromJson(Map<String, dynamic> json) => ModelUpdateMercCustomers(
    merchCode: json["merchCode"],
    customerCode: json["customerCode"],
    plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
    days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
    changeMerch: ChangeMerch.fromJson(json["changeMerch"]),
  );

  Map<String, dynamic> toJson() => {
    "merchCode": merchCode,
    "customerCode": customerCode,
    "plans": List<dynamic>.from(plans.map((x) => x.toJson())),
    "days": List<dynamic>.from(days.map((x) => x.toJson())),
    "changeMerch": changeMerch.toJson(),
  };

  @override
  String toString() {
    return 'ModelUpdateMercCustomers{merchCode: $merchCode, customerCode: $customerCode, plans: $plans, days: $days, changeMerch: $changeMerch}';
  }
}

class ChangeMerch {
  String newMerchCode;
  List<String> forwarderCodes;

  ChangeMerch({
    required this.newMerchCode,
    required this.forwarderCodes,
  });

  factory ChangeMerch.fromRawJson(String str) => ChangeMerch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChangeMerch.fromJson(Map<String, dynamic> json) => ChangeMerch(
    newMerchCode: json["newMerchCode"],
    forwarderCodes: List<String>.from(json["forwarderCodes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "newMerchCode": newMerchCode,
    "forwarderCodes": List<dynamic>.from(forwarderCodes.map((x) => x)),
  };
}


class Plan {
  String forwarderCode;
  double plan;

  Plan({
    required this.forwarderCode,
    required this.plan,
  });

  factory Plan.fromRawJson(String str) => Plan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    forwarderCode: json["forwarderCode"],
    plan: json["plan"],
  );

  Map<String, dynamic> toJson() => {
    "forwarderCode": forwarderCode,
    "plan": plan,
  };
}
