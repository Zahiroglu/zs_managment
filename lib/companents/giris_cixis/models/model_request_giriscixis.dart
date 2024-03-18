import 'dart:convert';

class ModelRequestGirisCixis {
  String userCode;
  String userPosition;
  String customerCode;
  String operationType;
  String operationLatitude;
  String operationLongitude;
  String note;

  ModelRequestGirisCixis({
    required this.userCode,
    required this.userPosition,
    required this.customerCode,
    required this.operationType,
    required this.operationLatitude,
    required this.operationLongitude,
    required this.note,
  });

  factory ModelRequestGirisCixis.fromRawJson(String str) => ModelRequestGirisCixis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelRequestGirisCixis.fromJson(Map<String, dynamic> json) => ModelRequestGirisCixis(
    userCode: json["userCode"],
    userPosition: json["userPosition"],
    customerCode: json["customerCode"],
    operationType: json["operationType"],
    operationLatitude: json["operationLatitude"],
    operationLongitude: json["operationLongitude"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userPosition": userPosition,
    "customerCode": customerCode,
    "operationType": operationType,
    "operationLatitude": operationLatitude,
    "operationLongitude": operationLongitude,
    "note": note,
  };
}
