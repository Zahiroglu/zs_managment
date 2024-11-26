class ModelLisanceRequest {
  final String lisPhoneId;
  final int lisCompanyId;
  final int lisModuleId;
  final int lisRoleId;
  final String? lisUserCode;

  ModelLisanceRequest({
    required this.lisPhoneId,
    required this.lisCompanyId,
    required this.lisModuleId,
    required this.lisRoleId,
    this.lisUserCode,
  });

  // Factory constructor for creating a new instance from a map
  factory ModelLisanceRequest.fromJson(Map<String, dynamic> json) {
    return ModelLisanceRequest(
      lisPhoneId: json['lis_phoneId'] as String,
      lisCompanyId: json['lis_companyId'] as int,
      lisModuleId: json['lis_moduleId'] as int,
      lisRoleId: json['lis_roleId'] as int,
      lisUserCode: json['lis_userCode'] as String?,
    );
  }

  // Method for converting an instance to a map
  Map<String, dynamic> toJson() {
    return {
      'lis_phoneId': lisPhoneId,
      'lis_companyId': lisCompanyId,
      'lis_moduleId': lisModuleId,
      'lis_roleId': lisRoleId,
      'lis_userCode': lisUserCode,
    };
  }
}
