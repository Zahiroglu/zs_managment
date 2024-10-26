class ModelRegisterByUser {
  String? code;
  String? name;
  String? surname;
  String? birthdate;
  bool gender;
  String? phone;
  String? email;
  String? deviceId;

  @override
  String toString() {
    return 'ModelRegisterByUser{code: $code, name: $name, surname: $surname, birthdate: $birthdate, gender: $gender, phone: $phone, email: $email, deviceId: $deviceId, moduleId: $moduleId, roleId: $roleId, regionId: $regionId, deviceLogin: $deviceLogin, usernameLogin: $usernameLogin, companyId: $companyId, folloginService: $folloginService, defaultPermitions: $defaultPermitions}';
  }

  int moduleId;
  int roleId;
  int? regionId;
  bool deviceLogin;
  bool usernameLogin;
  int companyId;
  String? folloginService;
  List<int> defaultPermitions;

  ModelRegisterByUser({
    required this.code,
    required this.name,
    required this.surname,
    required this.birthdate,
    required this.gender,
    this.phone,
    this.email,
    required this.deviceId,
    required this.moduleId,
    required this.roleId,
    required this.regionId,
    required this.deviceLogin,
    required this.usernameLogin,
    required this.companyId,
    required this.folloginService,
    required this.defaultPermitions,
  });

  // Factory constructor to create a User object from a JSON map
  factory ModelRegisterByUser.fromJson(Map<String, dynamic> json) {
    return ModelRegisterByUser(
      code: json['Code'],
      name: json['Name'],
      surname: json['Surname'],
      birthdate: json['Birthdate'],
      gender: json['Gender'],
      phone: json['Phone'],
      email: json['Email'],
      deviceId: json['DeviceId'],
      moduleId: json['ModuleId'],
      roleId: json['RoleId'],
      regionId: json['RegionId'],
      deviceLogin: json['DeviceLogin'],
      usernameLogin: json['UsernameLogin'],
      companyId: json['CompanyId'],
      folloginService: json['FolloginService'],
      defaultPermitions: json['defaultPermitions']??[],
    );
  }

  // Method to convert the User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Name': name,
      'Surname': surname,
      'Birthdate': birthdate,
      'Gender': gender,
      'Phone': phone,
      'Email': email,
      'DeviceId': deviceId,
      'ModuleId': moduleId,
      'RoleId': roleId,
      'RegionId': regionId,
      'DeviceLogin': deviceLogin,
      'UsernameLogin': usernameLogin,
      'CompanyId': companyId,
      'FolloginService': folloginService,
      'perList': defaultPermitions,
    };
  }
}