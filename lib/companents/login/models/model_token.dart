// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
part 'model_token.g.dart';


@HiveType(typeId: 3)
class TokenModel {
  TokenModel({
    this.accessToken,
    this.refreshToken,
  });
  @HiveField(0)
  String? accessToken;
  @HiveField(1)
  String? refreshToken;

  TokenModel copyWith({
    String? accessToken,
    String? refreshToken,
  }) =>
      TokenModel(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  factory TokenModel.fromRawJson(String str) => TokenModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };

  @override
  String toString() {
    return 'TokenModel{accessToken: $accessToken, refreshToken: $refreshToken}';
  }
}
