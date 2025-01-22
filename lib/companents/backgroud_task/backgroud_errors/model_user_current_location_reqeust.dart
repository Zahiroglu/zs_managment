import 'dart:convert';

import 'package:hive/hive.dart';
part 'model_user_current_location_reqeust.g.dart';

@HiveType(typeId: 32)
class ModelUsercCurrentLocationReqeust {
  @HiveField(0)
  String? userCode;
  @HiveField(1)
  String? userPosition;
  @HiveField(2)
  String? userFullName;
  @HiveField(3)
  double? latitude;
  @HiveField(4)
  double? longitude;
  @HiveField(5)
  String? locationDate;
  @HiveField(6)
  double? speed;
  @HiveField(7)
  bool? isOnline;
  @HiveField(8)
  String? pastInputCustomerCode;
  @HiveField(9)
  String? pastInputCustomerName;
  @HiveField(10)
  int? inputCustomerDistance;
  @HiveField(11)
  double? batteryLevel;
  @HiveField(12)
  String? sendingStatus;
  @HiveField(13)
  double? locationHeading;
  @HiveField(14)
  double? locAccuracy;
  @HiveField(15)
  bool? isMoving;
  @HiveField(15)
  String? screenState;

  ModelUsercCurrentLocationReqeust({
    this.userCode,
    this.userPosition,
    this.userFullName,
    this.latitude,
    this.longitude,
    this.locationDate,
    this.speed,
    this.isOnline,
    this.pastInputCustomerCode,
    this.pastInputCustomerName,
    this.inputCustomerDistance,
    this.batteryLevel,
    this.sendingStatus,
    this.locationHeading,
    this.locAccuracy,
    this.isMoving,
    this.screenState,
  });

  factory ModelUsercCurrentLocationReqeust.fromRawJson(String str) => ModelUsercCurrentLocationReqeust.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUsercCurrentLocationReqeust.fromJson(Map<String, dynamic> json) => ModelUsercCurrentLocationReqeust(
    userCode: json["userCode"],
    userPosition: json["userPosition"],
    userFullName: json["userFullName"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    locationDate: json["locationDate"],
    speed: json["speed"].toDouble(),
    isOnline: json["isOnline"],
    pastInputCustomerCode: json["pastInputCustomerCode"],
    pastInputCustomerName: json["pastInputCustomerName"],
    inputCustomerDistance: json["inputCustomerDistance"],
    batteryLevel: json["batteryLevel"].toDouble(),
    locationHeading: json["heading"].toDouble(),
    screenState: json["screenState"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userPosition": userPosition,
    "userFullName": userFullName,
    "latitude": latitude,
    "longitude": longitude,
    "locationDate": locationDate,
    "speed": speed,
    "isOnline": isOnline,
    "pastInputCustomerCode": pastInputCustomerCode,
    "pastInputCustomerName": pastInputCustomerName,
    "inputCustomerDistance": inputCustomerDistance,
    "batteryLevel": batteryLevel,
    "heading": locationHeading,
    "locAccuracy": locAccuracy!=null?locAccuracy!.round():0,
    "isMoving": isMoving,
    "sceenState": screenState,
  };
}
