import 'dart:convert';

class ModelRequestGirisCixis {
  String? userCode;
  String? userName;
  String? userPosition;
  String? userPositionName;
  String? customerCode;
  String? operationType;
  String? operationLatitude;
  String? operationLongitude;
  String? operationDate;
  String? inDt;
  String? note;
  bool? isRutDay;

  ModelRequestGirisCixis({
    this.userCode,
    this.userName,
    this.userPosition,
    this.userPositionName,
    this.customerCode,
    this.operationType,
    this.operationLatitude,
    this.operationLongitude,
    this.operationDate,
    this.inDt,
    this.note,
    this.isRutDay,
  });

  factory ModelRequestGirisCixis.fromRawJson(String str) => ModelRequestGirisCixis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelRequestGirisCixis.fromJson(Map<String, dynamic> json) => ModelRequestGirisCixis(
    userCode: json["userCode"],
    userName: json["userName"],
    userPosition: json["userPosition"],
    userPositionName: json["userPositionName"],
    customerCode: json["customerCode"],
    operationType: json["operationType"],
    operationLatitude: json["operationLatitude"],
    operationLongitude: json["operationLongitude"],
    operationDate: json["operationDate"],
    inDt: json["inDt"],
    note: json["note"],
    isRutDay: json["isRutDay"],
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userName": userName,
    "userPosition": userPosition,
    "userPositionName": userPositionName,
    "customerCode": customerCode,
    "operationType": operationType,
    "operationLatitude": operationLatitude,
    "operationLongitude": operationLongitude,
    "operationDate": operationDate,
    "inDt": inDt,
    "note": note,
    "isRutDay": isRutDay,
  };

  @override
  String toString() {
    return 'ModelRequestGirisCixis{userCode: $userCode, userPosition: $userPosition, customerCode: $customerCode, operationType: $operationType, operationLatitude: $operationLatitude, operationLongitude: $operationLongitude, note: $note}';
  }
}
