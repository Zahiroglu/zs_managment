class ModelIcazeRequest {
  int? icazeId;
  int userId;
  String? userFireId;
   String userCode;
  int userRoleId;
   String userRoleName;
   String userNameAndSurname;
   int icazeTypeId;
   String? icazeTypeName;
   DateTime icazeStartDate;
   DateTime icazeEndDate;
   String icazeQeyd;
   int? tesdiqleyenId;
   String? tesdiqleyenCode;
   int? tesdiqleyenRoleId;
   String? tesdiqleyenRoleName;
   String? tesdiqleyenNameAndSurname;
   String? tesdiqStatusu;
   DateTime? tesdiqlenmeTarixi;
   int? totalDuration;
   bool? paidLeave;


  ModelIcazeRequest({
    this.icazeId,
    required this.userId,
    required this.userCode,
    required this.userRoleId,
    required this.userRoleName,
    required this.userNameAndSurname,
    required this.icazeTypeId,
    this.icazeTypeName,
    required this.icazeStartDate,
    required this.icazeEndDate,
    required this.icazeQeyd,
    this.tesdiqleyenId,
    this.tesdiqleyenCode,
    this.tesdiqleyenRoleId,
    this.tesdiqleyenRoleName,
    this.tesdiqleyenNameAndSurname,
    this.tesdiqStatusu,
    this.tesdiqlenmeTarixi,
    this.totalDuration,
    this.userFireId,
    this.paidLeave,
  });

  // JSON-dan modelə çevirmək
  factory ModelIcazeRequest.fromJson(Map<String, dynamic> json) {
    return ModelIcazeRequest(
      icazeId: json['IcazeId'] ?? 0,
      userId: json['UserId'] ?? 0,
      userCode: json['UserCode'] ?? "",
      userRoleId: json['UserRoleId'] ?? 0,
      userRoleName: json['UserRoleName'] ?? "",
      userNameAndSurname: json['UserNameAndSurname'] ?? "",
      icazeTypeId: json['IcazeTypeId'] ?? 0,
      icazeTypeName: json['IcazeTypeName'] ?? "null",
      icazeStartDate: json['IcazeStartDate'] != null
          ? DateTime.tryParse(json['IcazeStartDate']) ?? DateTime.now()
          : DateTime.now(),
      icazeEndDate: json['IcazeEndDate'] != null
          ? DateTime.tryParse(json['IcazeEndDate']) ?? DateTime.now()
          : DateTime.now(),
      icazeQeyd: json['IcazeQeyd'] ?? "",
      tesdiqleyenId: json['TesdiqleyenId'] ?? 0,
      tesdiqleyenCode: json['TesdiqleyenCode'] ?? "",
      tesdiqleyenRoleId: json['TesdiqleyenRoleId'] ?? 0,
      tesdiqleyenRoleName: json['TesdiqleyenRoleName'] ?? "",
      tesdiqleyenNameAndSurname: json['TesdiqleyenNameAndSurname'] ?? "",
      tesdiqStatusu: json['TesdiqStatusu'] ?? "",
      tesdiqlenmeTarixi: json['TesdiqlenmeTarixi'] != null
          ? DateTime.tryParse(json['TesdiqlenmeTarixi'])
          : null,
      totalDuration: json['TotalDuration'] ?? 0,
      userFireId: json['UserFireId'] ?? "",
      paidLeave: json['PaidLeave'] ?? "",
    );

  }

  // Modeldən JSON-a çevirmək
  Map<String, dynamic> toJson() {
    return {
      'icazeId': icazeId,
      'userId': userId,
      'userCode': userCode,
      'userFireId': userFireId,
      'userRoleId': userRoleId,
      'userRoleName': userRoleName,
      'userNameAndSurname': userNameAndSurname,
      'icazeTypeId': icazeTypeId,
      'icazeTypeName': icazeTypeName,
      'icazeStartDate': icazeStartDate.toIso8601String(),
      'icazeEndDate': icazeEndDate.toIso8601String(),
      'icazeQeyd': icazeQeyd,
      'tesdiqleyenId': tesdiqleyenId,
      'tesdiqleyenCode': tesdiqleyenCode,
      'tesdiqleyenRoleId': tesdiqleyenRoleId,
      'tesdiqleyenRoleName': tesdiqleyenRoleName,
      'tesdiqleyenNameAndSurname': tesdiqleyenNameAndSurname,
      'tesdiqStatusu': tesdiqStatusu,
      'tesdiqlenmeTarixi': tesdiqlenmeTarixi?.toIso8601String(),
      'totalDuration': 0,
      'PaidLeave': true,
    };
  }

  @override
  String toString() {
    return 'ModelIcazeRequest{icazeId: $icazeId, userId: $userId, userFireId: $userFireId, userCode: $userCode, userRoleId: $userRoleId, userRoleName: $userRoleName, userNameAndSurname: $userNameAndSurname, icazeTypeId: $icazeTypeId, icazeStartDate: $icazeStartDate, icazeEndDate: $icazeEndDate, icazeQeyd: $icazeQeyd, tesdiqleyenId: $tesdiqleyenId, tesdiqleyenCode: $tesdiqleyenCode, tesdiqleyenRoleId: $tesdiqleyenRoleId, tesdiqleyenRoleName: $tesdiqleyenRoleName, tesdiqleyenNameAndSurname: $tesdiqleyenNameAndSurname, tesdiqStatusu: $tesdiqStatusu, tesdiqlenmeTarixi: $tesdiqlenmeTarixi, totalDuration: $totalDuration}';
  }
}
