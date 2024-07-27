import 'dart:convert';

import 'model_live_track.dart';

class MyConnectedUsersCurrentLocation {
  List<ModelLiveTrack>? userLocation;
  int? notInWorkUserCount;
  int? errorCount;
  List<ModelLiveTrack>? notInWorkUsers;

  MyConnectedUsersCurrentLocation({
    this.userLocation,
    this.notInWorkUserCount,
    this.errorCount,
    this.notInWorkUsers,

  });

  factory MyConnectedUsersCurrentLocation.fromRawJson(String str) => MyConnectedUsersCurrentLocation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyConnectedUsersCurrentLocation.fromJson(Map<String, dynamic> json) => MyConnectedUsersCurrentLocation(
    userLocation:json["userLocation"]!=null? List<ModelLiveTrack>.from(json["userLocation"].map((x) => ModelLiveTrack.fromJson(x))):[],
    notInWorkUsers:json["notInWorkUsers"]!=null? List<ModelLiveTrack>.from(json["notInWorkUsers"].map((x) => ModelLiveTrack.fromJson(x))):[],
    notInWorkUserCount: json["notInWorkUserCount"],
    errorCount: json["errorCount"],
  );

  Map<String, dynamic> toJson() => {
    "userLocation": List<dynamic>.from(userLocation!.map((x) => x.toJson())),
    "notInWorkUsers": List<dynamic>.from(notInWorkUsers!.map((x) => x.toJson())),
    "notInWorkUserCount": notInWorkUserCount,
    "errorCount": errorCount,
  };
}

