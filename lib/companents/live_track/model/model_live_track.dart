import 'dart:convert';

class ModelLiveTrack {
  String? userCode;
  String? userName;
  int? roleId;
  String? roleName;
  ModelCariTrack? modelCariTrack;
  ActionTrack? actionTrackIn;
  ActionTrack? actionTrackOut;
  UserCurrentPosition? userCurrentPosition;

  ModelLiveTrack({
    this.userCode,
    this.userName,
    this.roleId,
    this.roleName,
    this.modelCariTrack,
    this.actionTrackIn,
    this.actionTrackOut,
    this.userCurrentPosition,
  });

  factory ModelLiveTrack.fromRawJson(String str) => ModelLiveTrack.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelLiveTrack.fromJson(Map<String, dynamic> json) => ModelLiveTrack(
    userCode: json["userCode"],
    userName: json["userName"],
    roleId: json["roleId"],
    roleName: json["roleName"],
    modelCariTrack: ModelCariTrack.fromJson(json["modelCariTrack"]),
    actionTrackIn: ActionTrack.fromJson(json["actionTrackIn"]),
    actionTrackOut: ActionTrack.fromJson(json["actionTrackOut"]),
    userCurrentPosition: UserCurrentPosition.fromJson(json["userCurrentPosition"]),
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userName": userName,
    "roleId": roleId,
    "roleName": roleName,
    "modelCariTrack": modelCariTrack?.toJson(),
    "actionTrackIn": actionTrackIn?.toJson(),
    "actionTrackOut": actionTrackOut?.toJson(),
    "userCurrentPosition": userCurrentPosition?.toJson(),
  };

  @override
  String toString() {
    return 'ModelLiveTrack{userCode: $userCode, userName: $userName, modelCariTrack: $modelCariTrack, actionTrackIn: $actionTrackIn, actionTrackOut: $actionTrackOut, userCurrentPosition: $userCurrentPosition}';
  }
}

class ActionTrack {
  String? date;
  String? time;
  String? lat;
  String? long;
  String? distance;

  ActionTrack({
    this.date,
    this.time,
    this.lat,
    this.long,
    this.distance,
  });

  factory ActionTrack.fromRawJson(String str) => ActionTrack.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActionTrack.fromJson(Map<String, dynamic> json) => ActionTrack(
    date: json["date"],
    time: json["time"],
    lat: json["lat"],
    long: json["long"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "time": time,
    "lat": lat,
    "long": long,
    "distance": distance,
  };
}

class ModelCariTrack {
  String? rutGunu;
  String? marketCode;
  String? marketName;
  String? marketLat;
  String? marketLng;
  bool? cixisEdilib;
  String? marketdeQalmaVaxti;

  ModelCariTrack({
    this.rutGunu,
    this.marketCode,
    this.marketName,
    this.marketLat,
    this.marketLng,
    this.cixisEdilib,
    this.marketdeQalmaVaxti,
  });

  factory ModelCariTrack.fromRawJson(String str) => ModelCariTrack.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelCariTrack.fromJson(Map<String, dynamic> json) => ModelCariTrack(
    rutGunu: json["rutGunu"],
    marketCode: json["marketCode"],
    marketName: json["marketName"],
    marketLat: json["marketLat"],
    marketLng: json["marketLng"],
    cixisEdilib: json["cixisEdilib"],
    marketdeQalmaVaxti: json["marketdeQalmaVaxti"],
  );

  Map<String, dynamic> toJson() => {
    "rutGunu": rutGunu,
    "marketCode": marketCode,
    "marketName": marketName,
    "marketLat": marketLat,
    "marketLng": marketLng,
    "cixisEdilib": cixisEdilib,
    "marketdeQalmaVaxti": marketdeQalmaVaxti,
  };

  @override
  String toString() {
    return 'ModelCariTrack{rutGunu: $rutGunu, marketCode: $marketCode, marketName: $marketName, marketLat: $marketLat, marketLng: $marketLng, cixisEdilib: $cixisEdilib, marketdeQalmaVaxti: $marketdeQalmaVaxti}';
  }
}
class UserCurrentPosition {
  String lastDate;
  String lastTime;
  String speed;
  String lat;
  String lng;
  bool isOnline;

  UserCurrentPosition({
    required this.lastDate,
    required this.lastTime,
    required this.speed,
    required this.lat,
    required this.lng,
    required this.isOnline,
  });

  factory UserCurrentPosition.fromRawJson(String str) => UserCurrentPosition.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserCurrentPosition.fromJson(Map<String, dynamic> json) => UserCurrentPosition(
    lastDate: json["lastDate"],
    lastTime: json["lastTime"],
    speed: json["speed"],
    lat: json["lat"],
    lng: json["lng"],
    isOnline: json["isOnline"],
  );

  Map<String, dynamic> toJson() => {
    "lastDate": lastDate,
    "lastTime": lastTime,
    "speed": speed,
    "lat": lat,
    "lng": lng,
    "isOnline": isOnline,
  };
}
