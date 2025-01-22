import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import '../login/models/model_configrations.dart';

class SimpleUserModel {
  String? code;
  String? name;
  String? surname;
  String? phone;
  String? email;
  int? moduleId;
  String? moduleName;
  int? roleId;
  String? roleName;
  List<ModelUserPermissions>? permissions;
  List<ModelConfigrations>? configrations;

  SimpleUserModel({
    this.code,
    this.name,
    this.surname,
    this.phone,
    this.email,
    this.moduleId,
    this.moduleName,
    this.roleId,
    this.roleName,
    this.permissions,
    this.configrations,
  });

  // Factory method for JSON deserialization
  factory SimpleUserModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserModel(
      code: json['code'],
      name: json['name'],
      surname: json['surname'],
      phone: json['phone'],
      email: json['email'],
      moduleId: json['moduleId'],
      moduleName: json['moduleName'],
      roleId: json['roleId'],
      roleName: json['roleName'],
      configrations: json["configrations"] == null ? [] : List<ModelConfigrations>.from(json["configrations"]!.map((x) => ModelConfigrations.fromJson(x))),
      permissions: json["permissions"] == null ? [] : List<ModelUserPermissions>.from(json["permissions"]!.map((x) => ModelUserPermissions.fromJson(x))),
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'surname': surname,
      'phone': phone,
      'email': email,
      'moduleId': moduleId,
      'moduleName': moduleName,
      'roleId': roleId,
      'roleName': roleName,
      'permissions': permissions?.map((e) => e.toJson()).toList(),
      'configrations': configrations?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'SimpleUserModel{code: $code, name: $name, surname: $surname, phone: $phone, email: $email, moduleId: $moduleId, moduleName: $moduleName, roleId: $roleId, roleName: $roleName, permissions: $permissions, configrations: $configrations}';
  }
}

