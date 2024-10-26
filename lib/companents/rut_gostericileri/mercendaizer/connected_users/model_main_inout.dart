import 'dart:convert';

import 'package:hive/hive.dart';
part 'model_main_inout.g.dart';


@HiveType(typeId: 34)
class ModelMainInOut {
  @HiveField(1)
  String userCode;
  @HiveField(2)
  String userPosition;
  @HiveField(3)
  String userFullName;
  @HiveField(4)
  List<ModelInOutDay> modelInOutDays;

  ModelMainInOut({
    required this.userCode,
    required this.userPosition,
    required this.userFullName,
    required this.modelInOutDays,
  });

  factory ModelMainInOut.fromRawJson(String str) => ModelMainInOut.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelMainInOut.fromJson(Map<String, dynamic> json) => ModelMainInOut(
    userCode: json["UserCode"],
    userPosition: json["UserPosition"].toString(),
    userFullName: json["UserFullName"],
    modelInOutDays: List<ModelInOutDay>.from(json["ModelInOutDays"].map((x) => ModelInOutDay.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "UserCode": userCode,
    "UserPosition": userPosition,
    "UserFullName": userFullName,
    "ModelInOutDays": List<dynamic>.from(modelInOutDays.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ModelMainInOut{userCode: $userCode, userPosition: $userPosition, userFullName: $userFullName, modelInOutDays: $modelInOutDays}';
  }
}
@HiveType(typeId: 35)
class ModelInOutDay {
  @HiveField(1)
  String day;
  @HiveField(2)
  int visitedCount;
  @HiveField(3)
  String firstEnterDate;
  @HiveField(4)
  String lastExitDate;
  @HiveField(5)
  String workTimeInCustomer;
  @HiveField(6)
  String workTimeInArea;
  @HiveField(7)
  List<ModelInOut> modelInOut;

  ModelInOutDay({
    required this.day,
    required this.visitedCount,
    required this.firstEnterDate,
    required this.lastExitDate,
    required this.workTimeInCustomer,
    required this.workTimeInArea,
    required this.modelInOut,
  });

  factory ModelInOutDay.fromRawJson(String str) => ModelInOutDay.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelInOutDay.fromJson(Map<String, dynamic> json) => ModelInOutDay(
    day: json["Day"],
    visitedCount: json["VisitedCount"],
    firstEnterDate: json["FirstEnterDate"],
    lastExitDate: json["LastExitDate"].toString(),
    workTimeInCustomer: json["WorkTimeInCustomer"],
    workTimeInArea: json["WorkTimeInArea"],
    modelInOut: List<ModelInOut>.from(json["ModelInOutList"].map((x) => ModelInOut.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Day": day,
    "VisitedCount": visitedCount,
    "FirstEnterDate": firstEnterDate,
    "LastExitDate": lastExitDate,
    "WorkTimeInCustomer": workTimeInCustomer,
    "WorkTimeInArea": workTimeInArea,
    "ModelInOutList": List<dynamic>.from(modelInOut.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ModelInOutDay{day: $day, visitedCount: $visitedCount, firstEnterDate: $firstEnterDate, lastExitDate: $lastExitDate, workTimeInCustomer: $workTimeInCustomer, workTimeInArea: $workTimeInArea, modelInOut: $modelInOut}';
  }
}
@HiveType(typeId: 36)
class ModelInOut {
  @HiveField(1)
  dynamic userCode;
  @HiveField(2)
  dynamic userPosition;
  @HiveField(3)
  dynamic customerCode;
  @HiveField(4)
  dynamic userFullName;
  @HiveField(5)
  dynamic customerName;
  @HiveField(6)
  dynamic customerLatitude;
  @HiveField(7)
  dynamic customerLongitude;
  @HiveField(8)
  dynamic inDate;
  @HiveField(9)
  dynamic inLatitude;
  @HiveField(10)
  dynamic inLongitude;
  @HiveField(11)
  dynamic inDistance;
  @HiveField(12)
  dynamic inNote;
  @HiveField(13)
  dynamic outDate;
  @HiveField(14)
  dynamic outLatitude;
  @HiveField(15)
  dynamic outLongitude;
  @HiveField(16)
  dynamic outDistance;
  @HiveField(17)
  dynamic outNote;
  @HiveField(18)
  dynamic workTimeInCustomer;
  @HiveField(19)
  dynamic isRutDay;
  @HiveField(20)
  dynamic inDt;

  ModelInOut({
    this.userCode,
    this.userPosition,
    this.customerCode,
    this.userFullName,
    this.customerName,
    this.customerLatitude,
    this.customerLongitude,
    this.inDate,
    this.inLatitude,
    this.inLongitude,
    this.inDistance,
    this.inNote,
    this.outDate,
    this.outLatitude,
    this.outLongitude,
    this.outDistance,
    this.outNote,
    this.workTimeInCustomer,
    this.isRutDay,
    this.inDt,
  });

  factory ModelInOut.fromRawJson(String str) => ModelInOut.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelInOut.fromJson(Map<String, dynamic> json) => ModelInOut(
    userCode: json["UserCode"],
    userPosition: json["UserPosition"].toString(),
    customerCode: json["CustomerCode"],
    userFullName: json["UserFullName"],
    customerName: json["CustomerName"],
    customerLatitude: json["CustomerLatitude"],
    customerLongitude: json["CustomerLongitude"],
    inDate: json["InDate"],
    inLatitude: json["InLatitude"],
    inLongitude: json["InLongitude"],
    inDistance: json["InDistance"],
    inNote: json["InNote"],
    outDate: json["OutDate"],
    outLatitude: json["OutLatitude"],
    outLongitude: json["OutLongitude"],
    outDistance: json["OutDistance"],
    outNote: json["OutNote"],
    workTimeInCustomer: json["WorkTimeInCustomer"],
    isRutDay: json["IsRutDay"],
    inDt: json["InDt"],
  );

  Map<String, dynamic> toJson() => {
    "UserCode": userCode,
    "UserPosition": userPosition,
    "CustomerCode": customerCode,
    "UserFullName": userFullName,
    "CustomerName": customerName,
    "CustomerLatitude": customerLatitude,
    "CustomerLongitude": customerLongitude,
    "InDate": inDate,
    "InLatitude": inLatitude,
    "InLongitude": inLongitude,
    "InDistance": inDistance,
    "InNote": inNote,
    "OutDate": outDate,
    "OutLatitude": outLatitude,
    "OutLongitude": outLongitude,
    "OutDistance": outDistance,
    "OutNote": outNote,
    "WorkTimeInCustomer": workTimeInCustomer,
    "IsRutDay": isRutDay,
    "InDt": inDt,
  };
}