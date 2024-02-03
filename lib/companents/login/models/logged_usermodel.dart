import 'dart:convert';
import 'package:zs_managment/companents/login/models/model_company.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:hive/hive.dart';
part 'logged_usermodel.g.dart';

@HiveType(typeId: 2)
class LoggedUserModel {
  LoggedUserModel({
    this.tokenModel,
    this.userModel,
    this.companyModel,
    this.isLogged,
    this.baseUrl,
  });
  @HiveField(0)
  TokenModel? tokenModel;
  @HiveField(1)
  UserModel? userModel;
  @HiveField(2)
  CompanyModel? companyModel;
  @HiveField(3)
  bool? isLogged;
  @HiveField(4)
  String? baseUrl;


  LoggedUserModel copyWith({
    TokenModel? tokenModel,
    UserModel? userModel,
    CompanyModel? companyModel,
    String? baseUrl,
  }) =>
      LoggedUserModel(
        tokenModel: tokenModel ?? this.tokenModel,
        userModel: userModel ?? this.userModel,
        companyModel: companyModel ?? this.companyModel,
        baseUrl: baseUrl ?? this.baseUrl,
      );

  factory LoggedUserModel.fromRawJson(String str) => LoggedUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoggedUserModel.fromJson(Map<String, dynamic> json) => LoggedUserModel(
    tokenModel: json["TokenModel"] == null ? null : TokenModel.fromJson(json["TokenModel"]),
    userModel: json["UserModel"] == null ? null : UserModel.fromJson(json["UserModel"]),
    companyModel: json["CompanyModel"] == null ? null : CompanyModel.fromJson(json["CompanyModel"]),
      baseUrl: json["baseUrl"] == null ? "" : json['baseUrl'],
    isLogged: json["isLogged"]==null?false:json['isLogged']);

  Map<String, dynamic> toJson() => {
    "TokenModel": tokenModel?.toJson(),
    "UserModel": userModel?.toJson(),
    "CompanyModel": companyModel?.toJson(),
    "isLogged": isLogged,
    "baseUrl": baseUrl,
  };

  @override
  String toString() {
    return 'LoggedUserModel{tokenModel: $tokenModel, userModel: $userModel, companyModel: $companyModel, isLogged: $isLogged, baseUrl: $baseUrl}';
  }
}