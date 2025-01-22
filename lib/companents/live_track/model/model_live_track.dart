import 'dart:convert';

import 'package:zs_managment/companents/login/models/model_configrations.dart';

class ModelLiveTrack {
  String? userCode;
  String? userPosition;
  String? userPositionName;
  String? userFullName;
  String? phoneNumber;
  List<ModelConfigrations>? listUserConfigs;
  LastInoutAction? lastInoutAction;
  CurrentLocation? currentLocation;

  @override
  String toString() {
    return 'ModelLiveTrack{userCode: $userCode, userPosition: $userPosition, userPositionName: $userPositionName, userFullName: $userFullName, phoneNumber: $phoneNumber, lastInoutAction: $lastInoutAction, currentLocation: $currentLocation}';
  }

  ModelLiveTrack({
    this.userCode,
    this.userPosition,
    this.userPositionName,
    this.userFullName,
    this.phoneNumber,
    this.lastInoutAction,
    this.currentLocation,
    this.listUserConfigs,
  });

  factory ModelLiveTrack.fromRawJson(String str) => ModelLiveTrack.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelLiveTrack.fromJson(Map<String, dynamic> json) => ModelLiveTrack(
    userCode: json["UserCode"],
    userPosition: json["UserPosition"],
    userPositionName: json["UserPositionName"],
    userFullName: json["UserFullName"],
    phoneNumber: json["PhoneNumber"],
    listUserConfigs: (json['ListUserConfigs'] as List<dynamic>?)
        ?.map((item) => ModelConfigrations.fromJson(item as Map<String, dynamic>))
        .toList(),
    lastInoutAction: json['LastInoutAction'] != null ? LastInoutAction.fromJson(json['LastInoutAction']) : null,
    currentLocation: json['CurrentLocation'] != null ? CurrentLocation.fromJson(json['CurrentLocation']) : null,

  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userPosition": userPosition,
    "userFullName": userFullName,
    "lastInoutAction": lastInoutAction != null ? lastInoutAction!.toJson() : null,
    "currentLocation": currentLocation != null ? currentLocation!.toJson() : null,
  };


}


class CurrentLocation {
  String? userCode;
  String? userPosition;
  String? userPositionName;
  String? userFullName;
  String? latitude;
  String? longitude;
  String? locationDate;
  String? speed;
  bool? isOnline;
  String? pastInputCustomerCode;
  String? pastInputCustomerName;
  String? inputCustomerDistance;
  String? batteryLevel;
  bool? isMoving;
  double? locAccuracy;
  String? screenState;

  CurrentLocation({
    this.userCode,
    this.userPosition,
    this.userPositionName,
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
    this.isMoving,
    this.locAccuracy,
    this.screenState,
  });

  factory CurrentLocation.fromRawJson(String str) => CurrentLocation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentLocation.fromJson(Map<String, dynamic> json) => CurrentLocation(
    userCode: json["UserCode"],
    userPosition: json["UserPosition"],
    userPositionName: json["UserPositionName"],
    userFullName: json["UserFullName"],
    latitude: json["Latitude"],
    longitude: json["Longitude"],
    locationDate: json["LocationDate"],
    speed: json["Speed"],
    isOnline: json["IsOnline"],
    pastInputCustomerCode: json["PastInputCustomerCode"],
    pastInputCustomerName: json["PastInputCustomerName"],
    inputCustomerDistance: json["InputCustomerDistance"],
    batteryLevel: json["BatteryLevel"].toString(),
    isMoving: json["IsMoving"],
    locAccuracy: json["LocAccuracy"],
    screenState: json["ScreenState"]!=""? json["ScreenState"]:"b",
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
    "ScreenState": screenState,
  };

  @override
  String toString() {
    return 'CurrentLocation{userCode: $userCode, userPosition: $userPosition, userPositionName: $userPositionName, userFullName: $userFullName, latitude: $latitude, longitude: $longitude, locationDate: $locationDate, speed: $speed, isOnline: $isOnline, pastInputCustomerCode: $pastInputCustomerCode, pastInputCustomerName: $pastInputCustomerName, inputCustomerDistance: $inputCustomerDistance, batteryLevel: $batteryLevel}';
  }
}

class LastInoutAction {
  String? customerCode;
  String? customerName;
  String? customerLatitude;
  String? customerLongitude;
  String? inDate;
  String? inLatitude;
  String? inLongitude;
  String? inNote;
  String? outDate;
  String? outLatitude;
  String? outLongitude;
  String? outNote;
  String? workTimeInCustomer;
  DateTime? inDt;
  String? inDistance;
  String? outDistance;
  bool? routDay;
  bool? hasSatis;
  bool? hasKassa;
  bool? hasIade;

  LastInoutAction({
    this.customerCode,
    this.customerName,
    this.customerLatitude,
    this.customerLongitude,
    this.inDate,
    this.inLatitude,
    this.inLongitude,
    this.inNote,
    this.outDate,
    this.outLatitude,
    this.outLongitude,
    this.outNote,
    this.workTimeInCustomer,
    this.inDt,
    this.inDistance,
    this.outDistance,
    this.routDay,
    this.hasSatis,
    this.hasKassa,
    this.hasIade
  });

  factory LastInoutAction.fromRawJson(String str) => LastInoutAction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LastInoutAction.fromJson(Map<String, dynamic> json) => LastInoutAction(
    customerCode: json["CustomerCode"]??"",
    customerName: json["CustomerName"]??"",
    customerLatitude: json["CustomerLongitude"]??"",
    customerLongitude: json["CustomerLatitude"]??"",
    inDate: json["InDate"]??"",
    inLatitude: json["InLatitude"]??"",
    inLongitude: json["InLongitude"]??"",
    inNote: json["InNote"]??"",
    inDistance: json["InDistance"]??"",
    outDate: json["OutDate"]??"",
    outLatitude: json["OutLatitude"]??"",
    outLongitude: json["OutLongitude"]??"",
    outNote: json["OutNote"]??"",
    outDistance: json["OutDistance"]??"",
    workTimeInCustomer: json["WorkTimeInCustomer"]??"",
    hasSatis: json["HasSatis"]??false,
    hasKassa: json["HasKassa"]??false,
    hasIade: json["HasIade"]??false,
   // routDay: bool.parse(json["RoutDay"].toString())??true,
  );

  Map<String, dynamic> toJson() => {
    "customerCode": customerCode,
    "customerName": customerName,
    "customerLatitude": customerLatitude,
    "customerLongitude": customerLongitude,
    "inDate": inDate,
    "inLatitude": inLatitude,
    "inLongitude": inLongitude,
    "inNote": inNote,
    "inDistance": inDistance,
    "outDate": outDate,
    "outLatitude": outLatitude,
    "outLongitude": outLongitude,
    "outNote": outNote,
    "outDistance": outDistance,
    "workTimeInCustomer": workTimeInCustomer,
    "routDay": routDay,
    "inDt": inDt?.toIso8601String(),
  };

  @override
  String toString() {
    return 'LastInoutAction{customerCode: $customerCode, customerName: $customerName, customerLatitude: $customerLatitude, customerLongitude: $customerLongitude, inDate: $inDate, inLatitude: $inLatitude, inLongitude: $inLongitude, inNote: $inNote, outDate: $outDate, outLatitude: $outLatitude, outLongitude: $outLongitude, outNote: $outNote, workTimeInCustomer: $workTimeInCustomer, inDt: $inDt, inDistance: $inDistance, outDistance: $outDistance, routDay: $routDay}';
  }
}
