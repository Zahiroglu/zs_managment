import 'dart:convert';

class ModelRequestGirisCixis {
  String? userCode;
  String? userPosition;
  String? customerCode;
  String? operationType;
  String? operationLatitude;
  String? operationLongitude;
  String? operationDate;
  String? note;

  ModelRequestGirisCixis({
    this.userCode,
    this.userPosition,
    this.customerCode,
    this.operationType,
    this.operationLatitude,
    this.operationLongitude,
    this.operationDate,
    this.note,
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
    operationDate: json["operationDate"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userPosition": userPosition,
    "customerCode": customerCode,
    "operationType": operationType,
    "operationLatitude": operationLatitude,
    "operationLongitude": operationLongitude,
    "operationDate": operationDate,
    "note": note,
  };

  @override
  String toString() {
    return 'ModelRequestGirisCixis{userCode: $userCode, userPosition: $userPosition, customerCode: $customerCode, operationType: $operationType, operationLatitude: $operationLatitude, operationLongitude: $operationLongitude, note: $note}';
  }
}
