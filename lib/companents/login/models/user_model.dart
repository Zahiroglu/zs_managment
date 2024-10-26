// To parse this JSON data, do
//
//     final modelUser = modelUserFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

import 'model_company.dart';
import 'model_configrations.dart';
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
  @HiveField(32)
  List<ModelConfigrations>? configrations;

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
    this.configrations,
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
    List<ModelConfigrations>? configrations,

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
        configrations: configrations ?? this.configrations,

      );

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["Id"],
    code: json["Code"],
    name: json["Name"],
    surname: json["Surname"],
    fatherName: json["FatherName"],
    birthdate: json["Birthdate"],
    gender: json["Gender"]?1:0,
    phone: json["Phone"],
    email: json["Email"],
    deviceId: json["DeviceId"],
    moduleId: json["ModuleId"],
    moduleName: json["ModuleName"],
    roleId: json["RoleId"],
    roleName: json["RoleName"],
    regionCode: json["RegionCode"],
    regionName: json["RegionName"],
    regionLatitude: double.tryParse(json['RegionLatitude'].toString()),
    regionLongitude: double.tryParse(json['RegionLongitude'].toString()),
    deviceLogin: json["DeviceLogin"],
    usernameLogin: json["UsernameLogin"],
    username: json["Username"],
    companyId: json["CompanyId"],
    companyName: json["CompanyName"],
    modelModules: json["ModelModules"] == null ? [] : List<ModelModule>.from(json["ModelModules"]!.map((x) => ModelModule.fromJson(x))),
    connections: json["Connections"] == null ? [] : List<ModelUserConnection>.from(json["Connections"]!.map((x) => ModelUserConnection.fromJson(x))),
    permissions: json["Permissions"] == null ? [] : List<ModelUserPermissions>.from(json["Permissions"]!.map((x) => ModelUserPermissions.fromJson(x))),
    draweItems: json["Cards"] == null ? [] : List<ModelUserPermissions>.from(json["Cards"]!.map((x) => ModelUserPermissions.fromJson(x))),
    expDate: json["ExpDate"],
    addDateStr: json["AddDateStr"],
    requestNumber: json["RequestNumber"],
    lastOnlineDate: json["LastOnlineDate"],
    active: json["Active"],
    configrations: json["Configrations"] == null ? [] : List<ModelConfigrations>.from(json["Configrations"]!.map((x) => ModelConfigrations.fromJson(x))),

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
    "configrations": configrations == null ? [] : List<dynamic>.from(configrations!.map((x) => x.toJson())),

  };

  @override
  String toString() {
    return 'UserModel{id: $id, code: $code, name: $name, surname: $surname, fatherName: $fatherName, birthdate: $birthdate, gender: $gender, phone: $phone, email: $email, deviceId: $deviceId, moduleId: $moduleId, moduleName: $moduleName, roleId: $roleId, roleName: $roleName, regionCode: $regionCode, regionName: $regionName, deviceLogin: $deviceLogin, usernameLogin: $usernameLogin, username: $username, companyId: $companyId, companyName: $companyName, modelModules: $modelModules, connections: $connections, permissions: $permissions, draweItems: $draweItems, expDate: $expDate, addDateStr: $addDateStr, requestNumber: $requestNumber, lastOnlineDate: $lastOnlineDate, active: $active, regionLatitude: $regionLatitude, regionLongitude: $regionLongitude}';
  }
}



