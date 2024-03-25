import 'dart:convert';

class ModelMainInOut {
  String userCode;
  String userPosition;
  String userFullName;
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
    userCode: json["userCode"],
    userPosition: json["userPosition"],
    userFullName: json["userFullName"],
    modelInOutDays: List<ModelInOutDay>.from(json["inOutDays"].map((x) => ModelInOutDay.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "userPosition": userPosition,
    "userFullName": userFullName,
    "inOutDays": List<dynamic>.from(modelInOutDays.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ModelMainInOut{userCode: $userCode, userPosition: $userPosition, userFullName: $userFullName, modelInOutDays: $modelInOutDays}';
  }
}

class ModelInOutDay {
  String day;
  int visitedCount;
  String firstEnterDate;
  String lastExitDate;
  String workTimeInCustomer;
  String workTimeInArea;
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
    day: json["day"],
    visitedCount: json["visitedCount"],
    firstEnterDate: json["firstEnterDate"],
    lastExitDate: json["lastExitDate"],
    workTimeInCustomer: json["workTimeInCustomer"],
    workTimeInArea: json["workTimeInArea"],
    modelInOut: List<ModelInOut>.from(json["inOutCustomersByTime"].map((x) => ModelInOut.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "visitedCount": visitedCount,
    "firstEnterDate": firstEnterDate,
    "lastExitDate": lastExitDate,
    "workTimeInCustomer": workTimeInCustomer,
    "workTimeInArea": workTimeInArea,
    "inOutCustomersByTime": List<dynamic>.from(modelInOut.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ModelInOutDay{day: $day, visitedCount: $visitedCount, firstEnterDate: $firstEnterDate, lastExitDate: $lastExitDate, workTimeInCustomer: $workTimeInCustomer, workTimeInArea: $workTimeInArea, modelInOut: $modelInOut}';
  }
}

class ModelInOut {
  dynamic customerCode;
  dynamic customerName;
  dynamic inDate;
  dynamic inLatitude;
  dynamic inLongitude;
  dynamic inNote;
  dynamic outDate;
  dynamic outLatitude;
  dynamic outLongitude;
  dynamic outNote;
  dynamic workTimeInCustomer;

  ModelInOut({
    required this.customerCode,
    required this.customerName,
    required this.inDate,
    required this.inLatitude,
    required this.inLongitude,
    required this.inNote,
    required this.outDate,
    required this.outLatitude,
    required this.outLongitude,
    required this.outNote,
    required this.workTimeInCustomer,
  });

  factory ModelInOut.fromRawJson(String str) => ModelInOut.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelInOut.fromJson(Map<String, dynamic> json) => ModelInOut(
    customerCode: json["customerCode"],
    customerName: json["customerName"],
    inDate: json["inDate"],
    inLatitude: json["inLatitude"],
    inLongitude: json["inLongitude"],
    inNote: json["inNote"],
    outDate: json["outDate"],
    outLatitude: json["outLatitude"],
    outLongitude: json["outLongitude"],
    outNote: json["outNote"],
    workTimeInCustomer: json["workTimeInCustomer"],
  );

  Map<String, dynamic> toJson() => {
    "customerCode": customerCode,
    "customerName": customerName,
    "inDate": inDate,
    "inLatitude": inLatitude,
    "inLongitude": inLongitude,
    "inNote": inNote,
    "outDate": outDate,
    "outLatitude": outLatitude,
    "outLongitude": outLongitude,
    "outNote": outNote,
    "workTimeInCustomer": workTimeInCustomer,
  };

  @override
  String toString() {
    return 'ModelInOut{customerCode: $customerCode, customerName: $customerName, inDate: $inDate, inLatitude: $inLatitude, inLongitude: $inLongitude, inNote: $inNote, outDate: $outDate, outLatitude: $outLatitude, outLongitude: $outLongitude, outNote: $outNote, workTimeInCustomer: $workTimeInCustomer}';
  }
}
