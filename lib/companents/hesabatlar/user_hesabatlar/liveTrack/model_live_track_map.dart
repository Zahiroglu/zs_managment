import 'dart:convert';
import '../../../live_track/model/model_live_track.dart';

class MyConnectedUsersCurrentLocationReport {
  int? inOutId;
  int? type;
  String? userCode;
  String? userPosition;
  String? latitude;
  String? longitude;
  String? locationDate;
  String? pastInputCustomerCode;
  String? pastInputCustomerName;
  String? inputCustomerDistance;
  String? speed;
  String? batteryLevel;
  LastInoutAction? inOutCustomer;

  MyConnectedUsersCurrentLocationReport({
    this.inOutId,
    this.type,
    this.userCode,
    this.userPosition,
    this.latitude,
    this.longitude,
    this.locationDate,
    this.pastInputCustomerCode,
    this.pastInputCustomerName,
    this.inputCustomerDistance,
    this.speed,
    this.batteryLevel,
    this.inOutCustomer,
  });

  factory MyConnectedUsersCurrentLocationReport.fromRawJson(String str) => MyConnectedUsersCurrentLocationReport.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyConnectedUsersCurrentLocationReport.fromJson(Map<String, dynamic> json) => MyConnectedUsersCurrentLocationReport(
    inOutId: json["inOutId"],
    type: json["type"],
    userCode: json["userCode"],
    userPosition: json["userPosition"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    locationDate: json["locationDate"],
    pastInputCustomerCode: json["pastInputCustomerCode"],
    pastInputCustomerName: json["pastInputCustomerName"],
    inputCustomerDistance: json["inputCustomerDistance"],
    speed: json["speed"],
    batteryLevel: json["batteryLevel"],
    inOutCustomer: json["inOutCustomer"]!=null?LastInoutAction.fromJson(json["inOutCustomer"]):LastInoutAction(),
  );

  Map<String, dynamic> toJson() => {
    "inOutId": inOutId,
    "type": type,
    "userCode": userCode,
    "userPosition": userPosition,
    "latitude": latitude,
    "longitude": longitude,
    "locationDate": locationDate,
    "pastInputCustomerCode": pastInputCustomerCode,
    "pastInputCustomerName": pastInputCustomerName,
    "inputCustomerDistance": inputCustomerDistance,
    "speed": speed,
    "batteryLevel": batteryLevel,
    "inOutCustomer": inOutCustomer,
  };
}



