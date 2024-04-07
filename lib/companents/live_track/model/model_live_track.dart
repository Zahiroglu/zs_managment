import 'dart:convert';

class ModelLiveTrack {
  String? userCode;
  String? userPosition;
  String? userFullName;
  LastInoutAction? lastInoutAction;
  CurrentLocation? currentLocation;

  ModelLiveTrack({
    this.userCode,
    this.userPosition,
    this.userFullName,
    this.lastInoutAction,
    this.currentLocation,
  });

  factory ModelLiveTrack.fromRawJson(String str) => ModelLiveTrack.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelLiveTrack.fromJson(Map<String, dynamic> json) => ModelLiveTrack(
    userCode: json["userCode"],
    userPosition: json["userPosition"],
    userFullName: json["userFullName"],
    lastInoutAction: json['lastInoutAction'] != null ? LastInoutAction.fromJson(json['lastInoutAction']) : null,
    currentLocation: json['currentLocation'] != null ? CurrentLocation.fromJson(json['currentLocation']) : null,

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
  String? userFullName;
  String? latitude;
  String? longitude;
  String? locationDate;
  String? speed;
  bool? isOnline;

  CurrentLocation({
    this.userCode,
    this.userPosition,
    this.userFullName,
    this.latitude,
    this.longitude,
    this.locationDate,
    this.speed,
    this.isOnline,
  });

  factory CurrentLocation.fromRawJson(String str) => CurrentLocation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentLocation.fromJson(Map<String, dynamic> json) => CurrentLocation(
    userCode: json["userCode"]??"",
    userPosition: json["userPosition"]??"",
    userFullName: json["userFullName"]??"",
    latitude: json["latitude"]??"",
    longitude: json["longitude"]??"",
    locationDate: json["locationDate"]??"",
    speed: json["speed"]??"",
    isOnline: json["isOnline"]??false,
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
  };
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
    this.outDistance
  });

  factory LastInoutAction.fromRawJson(String str) => LastInoutAction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LastInoutAction.fromJson(Map<String, dynamic> json) => LastInoutAction(
    customerCode: json["customerCode"]??"",
    customerName: json["customerName"]??"",
    customerLatitude: json["customerLatitude"]??"",
    customerLongitude: json["customerLongitude"]??"",
    inDate: json["inDate"]??"",
    inLatitude: json["inLatitude"]??"",
    inLongitude: json["inLongitude"]??"",
    inNote: json["inNote"]??"",
    outDate: json["outDate"]??"",
    outLatitude: json["outLatitude"]??"",
    outLongitude: json["outLongitude"]??"",
    outNote: json["outNote"]??"",
    workTimeInCustomer: json["workTimeInCustomer"]??"",
    inDt: DateTime.parse(json["inDt"]),
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
    "outDate": outDate,
    "outLatitude": outLatitude,
    "outLongitude": outLongitude,
    "outNote": outNote,
    "workTimeInCustomer": workTimeInCustomer,
    "inDt": inDt?.toIso8601String(),
  };
}
