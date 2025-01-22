import 'dart:convert';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';

import '../../../live_track/model/model_live_track.dart';
import '../../../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';

class ModelUserDaylyTrackReport {
  List<MyConnectedUsersCurrentLocationReport>? listTrackin;
  List<LastInoutAction>? listInOuts;
  List<MercCustomersDatail>? unvisitedCustomersInRut;

  ModelUserDaylyTrackReport({
    this.listTrackin,
    this.listInOuts,
    this.unvisitedCustomersInRut,
  });

  factory ModelUserDaylyTrackReport.fromJson(Map<String, dynamic> json) {
    return ModelUserDaylyTrackReport(
      listTrackin: json["listTrackin"] is List
          ? (json["listTrackin"] as List)
          .map((item) => MyConnectedUsersCurrentLocationReport.fromJson(item))
          .toList()
          : null,
      listInOuts: json["listInOuts"] is List
          ? (json["listInOuts"] as List)
          .map((item) => LastInoutAction.fromJson(item))
          .toList()
          : null,
      unvisitedCustomersInRut: json["UnvisitedCustomersInRut"] is List
          ? (json["UnvisitedCustomersInRut"] as List)
          .map((item) => MercCustomersDatail.fromJson(item))
          .toList()
          : null,
    );
  }

  @override
  String toString() {
    return 'ModelUserDaylyTrackReport{listTrackin: $listTrackin, unvisitedCustomersInRut: $unvisitedCustomersInRut}';
  }
}
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
  String? locationHeading;
  double? locAccuracy;
  bool? isMoving;
  String? screenState;

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
    this.locationHeading,
    this.locAccuracy,
    this.isMoving,
    this.screenState,
  });

  factory MyConnectedUsersCurrentLocationReport.fromRawJson(String str) => MyConnectedUsersCurrentLocationReport.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyConnectedUsersCurrentLocationReport.fromJson(Map<String, dynamic> json) => MyConnectedUsersCurrentLocationReport(
    userCode: json["UserCode"],
    userPosition: json["UserPosition"],
    latitude: json["Latitude"],
    longitude: json["Longitude"],
    locationDate: json["LocationDate"],
    pastInputCustomerCode: json["PastInputCustomerCode"],
    pastInputCustomerName: json["PastInputCustomerName"],
    inputCustomerDistance: json["InputCustomerDistance"],
    speed: json["Speed"],
    batteryLevel: json["BatteryLevel"],
    locationHeading: json["LocationHeading"],
    locAccuracy: json["LocAccuracy"],
    isMoving: json["IsMoving"],
    screenState: json["ScreenState"],
    inOutCustomer: json["InOutCustomer"]!=null?LastInoutAction.fromJson(json["InOutCustomer"]):LastInoutAction(),
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
    "screenState": screenState,
  };

  @override
  String toString() {
    return 'MyConnectedUsersCurrentLocationReport{inOutId: $inOutId, type: $type, userCode: $userCode, userPosition: $userPosition, latitude: $latitude, longitude: $longitude, locationDate: $locationDate, pastInputCustomerCode: $pastInputCustomerCode, pastInputCustomerName: $pastInputCustomerName, inputCustomerDistance: $inputCustomerDistance, speed: $speed, batteryLevel: $batteryLevel, inOutCustomer: $inOutCustomer}';
  }
}



