// To parse this JSON data, do
//
//     final modelUser = modelUserFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

import 'model_company.dart';
import 'model_userconnnection.dart';
import 'model_userspormitions.dart';
part 'user_model.g.dart';


@HiveType(typeId: 5)
class UserModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? code;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? surname;
  @HiveField(4)
  String? fatherName;
  @HiveField(5)
  String? birthdate;
  @HiveField(6)
  int? gender;
  @HiveField(7)
  String? phone;
  @HiveField(8)
  String? email;
  @HiveField(9)
  String? deviceId;
  @HiveField(10)
  int? moduleId;
  @HiveField(11)
  String? moduleName;
  @HiveField(12)
  int? roleId;
  @HiveField(13)
  String? roleName;
  @HiveField(14)
  String? regionCode;
  @HiveField(15)
  String? regionName;
  @HiveField(16)
  bool? deviceLogin;
  @HiveField(17)
  bool? usernameLogin;
  @HiveField(18)
  String? username;
  @HiveField(19)
  int? companyId;
  @HiveField(20)
  String? companyName;
  @HiveField(21)
  List<ModelModule>? modelModules;
  @HiveField(22)
  List<ModelUserConnection>? connections;
  @HiveField(23)
  List<ModelUserPermissions>? permissions;
  @HiveField(24)
  List<ModelUserPermissions>? draweItems;
  @HiveField(25)
  int? expDate;
  @HiveField(26)
  String? addDateStr;
  @HiveField(27)
  String? requestNumber;
  @HiveField(28)
  String? lastOnlineDate;
  @HiveField(29)
  bool? active;
  @HiveField(30)
  double? regionLatitude;
  @HiveField(31)
  double? regionLongitude;

  UserModel({
    this.id,
    this.code,
    this.name,
    this.surname,
    this.fatherName,
    this.birthdate,
    this.gender,
    this.phone,
    this.email,
    this.deviceId,
    this.moduleId,
    this.moduleName,
    this.roleId,
    this.roleName,
    this.regionCode,
    this.regionName,
    this.deviceLogin,
    this.usernameLogin,
    this.username,
    this.companyId,
    this.companyName,
    this.modelModules,
    this.connections,
    this.permissions,
    this.draweItems,
    this.expDate,
    this.addDateStr,
    this.requestNumber,
    this.lastOnlineDate,
    this.active,
    this.regionLongitude,
    this.regionLatitude,
  });

  UserModel copyWith({
    int? id,
    String? code,
    String? name,
    String? surname,
    String? fatherName,
    String? birthdate,
    int? gender,
    String? phone,
    String? email,
    String? deviceId,
    int? moduleId,
    String? moduleName,
    int? roleId,
    String? roleName,
    String? regionCode,
    String? regionName,
    bool? deviceLogin,
    bool? usernameLogin,
    String? username,
    int? companyId,
    String? companyName,
    List<ModelModule>? modelModules,
    List<ModelUserConnection>? connections,
    List<ModelUserPermissions>? permissions,
    List<ModelUserPermissions>? draweItems,
    int? expDate,
    String? addDateStr,
    String? requestNumber,
    String? lastOnlineDate,
    bool? active,
    double? regionLongitude,
    double? regionLatitude,
  }) =>
      UserModel(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        fatherName: fatherName ?? this.fatherName,
        birthdate: birthdate ?? this.birthdate,
        gender: gender ?? this.gender,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        deviceId: deviceId ?? this.deviceId,
        moduleId: moduleId ?? this.moduleId,
        moduleName: moduleName ?? this.moduleName,
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
        regionCode: regionCode ?? this.regionCode,
        regionName: regionCode ?? this.regionName,
        deviceLogin: deviceLogin ?? this.deviceLogin,
        usernameLogin: usernameLogin ?? this.usernameLogin,
        username: username ?? this.username,
        companyId: companyId ?? this.companyId,
        companyName: companyName ?? this.companyName,
        modelModules: modelModules ?? this.modelModules,
        connections: connections ?? this.connections,
        permissions: permissions ?? this.permissions,
        draweItems: draweItems ?? this.draweItems,
        expDate: expDate ?? this.expDate,
        addDateStr: addDateStr ?? this.addDateStr,
        requestNumber: requestNumber ?? this.requestNumber,
        lastOnlineDate: lastOnlineDate ?? this.lastOnlineDate,
        active: active ?? this.active,
        regionLatitude: regionLatitude ?? this.regionLatitude,
        regionLongitude: regionLongitude ?? this.regionLongitude,
      );

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    surname: json["surname"],
    fatherName: json["fatherName"],
    birthdate: json["birthdate"],
    gender: json["gender"],
    phone: json["phone"],
    email: json["email"],
    deviceId: json["deviceId"],
    moduleId: json["moduleId"],
    moduleName: json["moduleName"],
    roleId: json["roleId"],
    roleName: json["roleName"],
    regionCode: json["regionCode"],
    regionName: json["regionName"],
    deviceLogin: json["deviceLogin"],
    usernameLogin: json["usernameLogin"],
    username: json["username"],
    companyId: json["companyId"],
    companyName: json["companyName"],
    modelModules: json["modelModules"] == null ? [] : List<ModelModule>.from(json["modelModules"]!.map((x) => ModelModule.fromJson(x))),
    connections: json["connections"] == null ? [] : List<ModelUserConnection>.from(json["connections"]!.map((x) => ModelUserConnection.fromJson(x))),
    permissions: json["permissions"] == null ? [] : List<ModelUserPermissions>.from(json["permissions"]!.map((x) => ModelUserPermissions.fromJson(x))),
    draweItems: json["cards"] == null ? [] : List<ModelUserPermissions>.from(json["cards"]!.map((x) => ModelUserPermissions.fromJson(x))),
    expDate: json["expDate"],
    addDateStr: json["addDateStr"],
    requestNumber: json["requestNumber"],
    lastOnlineDate: json["lastOnlineDate"],
    active: json["active"],
    regionLongitude: double.tryParse(json["regionLongitude"]??"0"),
    regionLatitude: double.tryParse(json["regionLatitude"]??"0"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "surname": surname,
    "fatherName": fatherName,
    "birthdate": birthdate,
    "gender": gender,
    "phone": phone,
    "email": email,
    "deviceId": deviceId,
    "moduleId": moduleId,
    "moduleName": moduleName,
    "roleId": roleId,
    "roleName": roleName,
    "regionCode": regionCode,
    "regionName": regionName,
    "deviceLogin": deviceLogin,
    "usernameLogin": usernameLogin,
    "username": username,
    "companyId": companyId,
    "companyName": companyName,
    "modelModules": modelModules == null ? [] : List<dynamic>.from(modelModules!.map((x) => x.toJson())),
    "connections": connections == null ? [] : List<dynamic>.from(connections!.map((x) => x.toJson())),
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toJson())),
    "draweItems": draweItems == null ? [] : List<dynamic>.from(draweItems!.map((x) => x.toJson())),
    "expDate": expDate,
    "addDateStr": addDateStr,
    "requestNumber": requestNumber,
    "lastOnlineDate": lastOnlineDate,
    "active": active,
    "regionLatitude": regionLatitude,
    "regionLongitude": regionLongitude,
  };

  @override
  String toString() {
    return 'UserModel{id: $id, code: $code, name: $name, surname: $surname, fatherName: $fatherName, birthdate: $birthdate, gender: $gender, phone: $phone, email: $email, deviceId: $deviceId, moduleId: $moduleId, moduleName: $moduleName, roleId: $roleId, roleName: $roleName, regionCode: $regionCode, regionName: $regionName, deviceLogin: $deviceLogin, usernameLogin: $usernameLogin, username: $username, companyId: $companyId, companyName: $companyName, modelModules: $modelModules, connections: $connections, permissions: $permissions, expDate: $expDate, addDateStr: $addDateStr, requestNumber: $requestNumber, lastOnlineDate: $lastOnlineDate}';
  }
}



