import 'dart:convert';
import 'package:hive/hive.dart';
part 'model_back_error.g.dart';

@HiveType(typeId: 31)
class ModelBackErrors {
  @HiveField(0)
  String? userCode;
  @HiveField(1)
  int? userPosition;
  @HiveField(2)
  String? userFullName;
  @HiveField(3)
  String? errCode;
  @HiveField(4)
  String? errName;
  @HiveField(5)
  String? errDate;
  @HiveField(6)
  String? deviceId;
  @HiveField(7)
  String? locationLatitude;
  @HiveField(8)
  String? locationLongitude;
  @HiveField(9)
  String? sendingStatus;
  @HiveField(10)
  String? description;
  @HiveField(11)
  int? userId;

  ModelBackErrors({
    this.userCode,
    this.userPosition,
    this.userFullName,
    this.errCode,
    this.errName,
    this.errDate,
    this.deviceId,
    this.locationLatitude,
    this.locationLongitude,
    this.sendingStatus,
    this.description,
    this.userId,
  });

  factory ModelBackErrors.fromRawJson(String str) => ModelBackErrors.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelBackErrors.fromJson(Map<String, dynamic> json) => ModelBackErrors(
    userCode: json["UserCode"],
    //userPosition: int.parse(json["UserPosition"]),
    userPosition: 0,
    userFullName: json["UserFullname"],
    errCode: json["ErrCode"],
    errName: json["ErrName"],
    errDate: json["ErrDate"],
    deviceId: json["DeviceId"],
    locationLatitude: json["LocationLatitude"].toString(),
    locationLongitude: json["LocationLongitude"].toString(),
    description: json["Description"],
    userId: json["UserId"],
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userPosition": userPosition,
    "userFullName": userFullName,
    "errCode": errCode,
    "errName": errName,
    "errDate": errDate,
    "deviceId": deviceId,
    "locationLatitude": locationLatitude,
    "locationLongitude": locationLongitude,
    "description": description,
    "userId": userId,
  };
}
