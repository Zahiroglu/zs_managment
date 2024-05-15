import 'dart:convert';

import 'model_live_track.dart';

class MyConnectedUsersCurrentLocation {
  List<ModelLiveTrack>? userLocation;
  int? notInWorkUserCount;
  int? errorCount;

  MyConnectedUsersCurrentLocation({
    this.userLocation,
    this.notInWorkUserCount,
    this.errorCount,
  });

  factory MyConnectedUsersCurrentLocation.fromRawJson(String str) => MyConnectedUsersCurrentLocation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyConnectedUsersCurrentLocation.fromJson(Map<String, dynamic> json) => MyConnectedUsersCurrentLocation(
    userLocation: List<ModelLiveTrack>.from(json["userLocation"].map((x) => ModelLiveTrack.fromJson(x))),
    notInWorkUserCount: json["notInWorkUserCount"],
    errorCount: json["errorCount"],
  );

  Map<String, dynamic> toJson() => {
    "userLocation": List<dynamic>.from(userLocation!.map((x) => x.toJson())),
    "notInWorkUserCount": notInWorkUserCount,
    "errorCount": errorCount,
  };
}

