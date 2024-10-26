import '../models/model_regions.dart';

class LicenseModel {
  int lisanceId;
  String lisPhoneId;
  String lisUserCode;
  int lisCompanyId;
  String lisCompName;
  String lisCompBaseUrl;
  int lisModuleId;
  String lisModuleName;
  int lisRoleId;
  String lisRoleName;
  bool lisAccessZS;
  DateTime lisCreateDate;
  String lisMessaje;
  List<ModelRegions> listRegionlar;
  List<int> listPerIds;

  LicenseModel({
    required this.lisanceId,
    required this.lisPhoneId,
    required this.lisUserCode,
    required this.lisCompanyId,
    required this.lisCompName,
    required this.lisCompBaseUrl,
    required this.lisModuleId,
    required this.lisModuleName,
    required this.lisRoleId,
    required this.lisRoleName,
    required this.lisAccessZS,
    required this.lisCreateDate,
    required this.lisMessaje,
    required this.listRegionlar,
    required this.listPerIds,
  });

  // Factory method to create the model from a JSON map
  factory LicenseModel.fromJson(Map<String, dynamic> json) => LicenseModel(
    lisanceId: json['lisanceId']!=null?json['lisanceId']:0,
    lisPhoneId: json['lis_phoneId'],
    lisUserCode: json['lis_userCode'],
    lisCompanyId: json['lis_companyId'],
    lisCompName: json['lis_compName'],
    lisCompBaseUrl: json['lis_compBaseUrl'],
    lisModuleId: json['lis_moduleId'],
    lisModuleName: json['lis_moduleName'],
    lisRoleId: json['lis_roleId'],
    lisRoleName: json['lis_roleName'],
    lisAccessZS: json['lis_accessZS'],
    lisMessaje: json['lis_messaje'],
    lisCreateDate: DateTime.parse(json['lis_createDate']),
    listPerIds: List<int>.from(json['listPer'] ?? []), // Corrected parsing of listPerIds
    listRegionlar:  json["listRegions"] == null ? [] : List<ModelRegions>.from(json["listRegions"]!.map((x) => ModelRegions.fromJson(x))),
  );

  // Method to convert the model to a JSON map
  Map<String, dynamic> toJson() => {
    'lisanceId': lisanceId,
    'lis_phoneId': lisPhoneId,
    'lis_userCode': lisUserCode,
    'lis_companyId': lisCompanyId,
    'lis_compName': lisCompName,
    'lis_compBaseUrl': lisCompBaseUrl,
    'lis_moduleId': lisModuleId,
    'lis_moduleName': lisModuleName,
    'lis_roleId': lisRoleId,
    'lis_roleName': lisRoleName,
    'lis_accessZS': lisAccessZS,
    'lis_messaje': lisMessaje,
    'listPer': listPerIds,
    'lis_createDate': lisCreateDate.toIso8601String(),
  };
}