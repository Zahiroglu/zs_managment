import 'dart:convert';
import 'package:zs_managment/companents/login/models/model_company.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:hive/hive.dart';

import 'model_configrations.dart';
part 'logged_usermodel.g.dart';

@HiveType(typeId: 2)
class LoggedUserModel {
  LoggedUserModel({
    this.tokenModel,
    this.userModel,
    this.companyModel,
    this.companyConfigModel,
    this.isLogged,
    this.baseUrl,
  });
  @HiveField(0)
  TokenModel? tokenModel;
  @HiveField(1)
  UserModel? userModel;
  @HiveField(2)
  CompanyModel? companyModel;
  @HiveField(5)
  List<ModelConfigrations>? companyConfigModel;
  @HiveField(3)
  bool? isLogged;
  @HiveField(4)
  String? baseUrl;


  LoggedUserModel copyWith({
    TokenModel? tokenModel,
    UserModel? userModel,
    CompanyModel? companyModel,
    List<ModelConfigrations>? companyConfigModel,
    String? baseUrl,
  }) =>
      LoggedUserModel(
        tokenModel: tokenModel ?? this.tokenModel,
        userModel: userModel ?? this.userModel,
        companyModel: companyModel ?? this.companyModel,
        companyConfigModel: companyConfigModel ?? this.companyConfigModel,
        baseUrl: baseUrl ?? this.baseUrl,
      );


  String toRawJson() => json.encode(toJson());



  Map<String, dynamic> toJson() => {
    "TokenModel": tokenModel?.toJson(),
    "UserModel": userModel?.toJson(),
    "CompanyModel": companyModel?.toJson(),
    "ModelConfigrations": companyConfigModel,
    "isLogged": isLogged,
    "baseUrl": baseUrl,
  };

  @override
  String toString() {
    return 'LoggedUserModel{tokenModel: $tokenModel, userModel: $userModel, companyModel: $companyModel, isLogged: $isLogged, baseUrl: $baseUrl}';
  }
}