import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/login/models/model_company.dart';
import 'package:zs_managment/login/models/model_token.dart';
import 'package:zs_managment/login/models/model_userconnnection.dart';
import 'package:zs_managment/login/models/model_userspormitions.dart';
import 'package:zs_managment/login/models/user_model.dart';

class LoggedUserModel {
  LoggedUserModel({
    this.tokenModel,
    this.userModel,
    this.companyModel,
    this.isLogged,
  });

  TokenModel? tokenModel;
  UserModel? userModel;
  CompanyModel? companyModel;
  bool? isLogged;

  LoggedUserModel copyWith({
    TokenModel? tokenModel,
    UserModel? userModel,
    CompanyModel? companyModel,
  }) =>
      LoggedUserModel(
        tokenModel: tokenModel ?? this.tokenModel,
        userModel: userModel ?? this.userModel,
        companyModel: companyModel ?? this.companyModel,
      );

  factory LoggedUserModel.fromRawJson(String str) => LoggedUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoggedUserModel.fromJson(Map<String, dynamic> json) => LoggedUserModel(
    tokenModel: json["TokenModel"] == null ? null : TokenModel.fromJson(json["TokenModel"]),
    userModel: json["UserModel"] == null ? null : UserModel.fromJson(json["UserModel"]),
    companyModel: json["CompanyModel"] == null ? null : CompanyModel.fromJson(json["CompanyModel"]),
    isLogged: json["isLogged"]==null?false:json['isLogged']);

  Map<String, dynamic> toJson() => {
    "TokenModel": tokenModel?.toJson(),
    "UserModel": userModel?.toJson(),
    "CompanyModel": companyModel?.toJson(),
    "isLogged": isLogged,
  };

  @override
  String toString() {
    return 'LoggedUserModel{tokenModel: $tokenModel, userModel: $userModel, companyModel: $companyModel}';
  }


  LoggedUserModel getLoggedUserModel(){
    return LoggedUserModel(
      userModel: UserModel(
        id: 1,
        addDateStr: "2022.05.10",
        birthdate: "07.17.1990",
        code: '200',
        companyId: 1,
        companyName: "Bolluq ltd mmc",
        connections: [ModelUserConnection(code: "100",fullName: "Samir Selimov",roleId: 1,roleName: "Admin")],
        roleName: "Admin",
        roleId: 1,
        deviceId: "aa1145aqq51257",
        deviceLogin: true,
        email: "samir.zahiroglu@gmail.com",
        expDate: 5,
        fatherName: "Zahir",
        gender: "Kisi",
        lastOnlineDate: "26.06.2023",
        modelModules: [ModelModule(id: 1,name: "ADMIN PANEL"),ModelModule(id: 2,name: "Dashbourd")],
        name: "Samir",
        moduleId: 1,
        moduleName: "ADMIN",
        permissions: [
          ModelUserPermissions(name: "Dashbourd",id: 1,code: "dash",icon:Icons.dashboard.codePoint,screen: true,selectIcon: Icons.dashboard_customize_outlined.codePoint,val: 1,valName: "full"),
          ModelUserPermissions(name: "Users",id: 2,code: "users",icon:Icons.supervised_user_circle.codePoint,screen: true,selectIcon: Icons.supervised_user_circle_outlined.codePoint,val: 1,valName: "full"),
        ],
        phone: "0552601566",
        regionCode: "Baku",
        regionName: "Baki merkez",
        requestNumber: '10',
        surname: "Selimov",
        username: "Zahiroglu",
        usernameLogin: true

      ),
      // userModel: UserModel(
      //   departamentName: "Satis Sobesi",
      //   phone: "0552601566",
      //   roleName: "Satis Temsilcisi",
      //   birthdate: "17.07.1990",
      //   username: "Zahiroglu",
      //   id: 0,
      //   cinsi: "Kisi",
      //   code: "118",
      //   deviceId: "A1555A55620",
      //   deviceLogin: true,
      //   email: "Samir.zahiroglu@gmail.com"
      // ),
      tokenModel: TokenModel(
        accessToken: "ADBBAJNKAJBHJEMEKWMMWNMWMMWKDN231662AWDAWDJHABWDJKNW",
        refreshToken: "ACNAWKLDMLAWD451566+2"
      ),
      companyModel: CompanyModel(
        id: 1,
        name: "Bolluq ltd mmc",
        modelModule: [
          ModelModule(id: 0,name: "Satis modulu"),
          ModelModule(id: 2,name: "Reklam modulu"),
          ModelModule(id: 2,name: "Logistik modulu"),
        ],
      ),
      isLogged: true


    );
  }

  List<LoggedUserModel> getLoggedUsers(){
    return [
      LoggedUserModel(
          userModel: UserModel(
              id: 1,
              addDateStr: "2022.05.10",
              birthdate: "07.17.1990",
              code: '200',
              companyId: 1,
              companyName: "Bolluq ltd mmc",
              connections: [ModelUserConnection(code: "100",fullName: "Samir Selimov",roleId: 1,roleName: "Admin")],
              roleName: "Admin",
              roleId: 1,
              deviceId: "aa1145aqq51257",
              deviceLogin: true,
              email: "samir.zahiroglu@gmail.com",
              expDate: 5,
              fatherName: "Zahir",
              gender: "Kisi",
              lastOnlineDate: "26.06.2023",
              modelModules: [ModelModule(id: 1,name: "ADMIN PANEL"),ModelModule(id: 2,name: "Dashbourd")],
              name: "Samir",
              moduleId: 1,
              moduleName: "CRM MODULE",
              permissions: [
                ModelUserPermissions(name: "Dashbourd",id: 1,code: "dash",icon:Icons.dashboard.codePoint,screen: true,selectIcon: Icons.dashboard_customize_outlined.codePoint,val: 1,valName: "full"),
                ModelUserPermissions(name: "Users",id: 2,code: "users",icon:Icons.supervised_user_circle.codePoint,screen: true,selectIcon: Icons.supervised_user_circle_outlined.codePoint,val: 1,valName: "full"),
              ],
              phone: "0552601566",
              regionCode: "Baku",
              regionName: "BAKI",
              requestNumber: '10',
              surname: "Selimov",
              username: "Zahiroglu",
              usernameLogin: true

          ),
          tokenModel: TokenModel(
              accessToken: "ADBBAJNKAJBHJEMEKWMMWNMWMMWKDN231662AWDAWDJHABWDJKNW",
              refreshToken: "ACNAWKLDMLAWD451566+2"
          ),
          companyModel: CompanyModel(
            id: 1,
            name: "Bolluq ltd mmc",
            modelModule: [
              ModelModule(id: 0,name: "Satis modulu"),
              ModelModule(id: 2,name: "Reklam modulu"),
              ModelModule(id: 2,name: "Logistik modulu"),
            ],
          ),
          isLogged: true


      ),
      LoggedUserModel(
          userModel: UserModel(
              id: 2,
              addDateStr: "2022.02.10",
              birthdate: "02.17.1985",
              code: '0001',
              companyId: 1,
              companyName: "Bolluq ltd mmc",
              connections: [ModelUserConnection(code: "100",fullName: "Samir Selimov",roleId: 1,roleName: "Admin")],
              roleName: "Satis Mudiri",
              roleId: 2,
              deviceId: "aa1145aqq51257",
              deviceLogin: true,
              email: "asif.tanriverdiyev@gmail.com",
              expDate: 5,
              fatherName: "",
              gender: "Kisi",
              lastOnlineDate: "26.06.2023",
              modelModules: [ModelModule(id: 1,name: "ADMIN PANEL"),ModelModule(id: 2,name: "Dashbourd")],
              name: "ASIF",
              moduleId: 2,
              moduleName: "SATIS MUDIRI",
              permissions: [
                ModelUserPermissions(name: "Dashbourd",id: 1,code: "dash",icon:Icons.dashboard.codePoint,screen: true,selectIcon: Icons.dashboard_customize_outlined.codePoint,val: 1,valName: "full"),
                ModelUserPermissions(name: "Users",id: 2,code: "users",icon:Icons.supervised_user_circle.codePoint,screen: true,selectIcon: Icons.supervised_user_circle_outlined.codePoint,val: 1,valName: "full"),
              ],
              phone: "0552601566",
              regionCode: "Baku",
              regionName: "BAKI",
              requestNumber: '10',
              surname: "TANRIVERDIYEV",
              username: "ASIF TANRIVERDIYEV",
              usernameLogin: true

          ),
          tokenModel: TokenModel(
              accessToken: "ADBBAJNKAJBHJEMEKWMMWNMWMMWKDN231662AWDAWDJHABWDJKNW",
              refreshToken: "ACNAWKLDMLAWD451566+2"
          ),
          companyModel: CompanyModel(
            id: 1,
            name: "Bolluq ltd mmc",
            modelModule: [
              ModelModule(id: 0,name: "Satis modulu"),
              ModelModule(id: 2,name: "Reklam modulu"),
              ModelModule(id: 2,name: "Logistik modulu"),
            ],
          ),
          isLogged: true


      ),
      LoggedUserModel(
          userModel: UserModel(
              id: 3,
              addDateStr: "2022.05.10",
              birthdate: "07.17.1990",
              code: '0023',
              companyId: 1,
              companyName: "Bolluq ltd mmc",
              connections: [ModelUserConnection(code: "100",fullName: "Samir Selimov",roleId: 1,roleName: "Admin"),
                ModelUserConnection(code: "0001",fullName: "ASIF TANRIVERDIYEV",roleId: 2,roleName: "SATIS MUDIRI")],
              roleName: "BOLGE MUDIRI",
              roleId: 3,
              deviceId: "aa1145aqq51257",
              deviceLogin: true,
              email: "KAMIL.MEMMEDOV@gmail.com",
              expDate: 5,
              fatherName: "",
              gender: "Kisi",
              lastOnlineDate: "20.01.2023",
              modelModules: [ModelModule(id: 1,name: "ADMIN PANEL"),ModelModule(id: 2,name: "Dashbourd")],
              name: "KAMIL",
              moduleId: 2,
              moduleName: "SATIS SOBESI",
              permissions: [
                ModelUserPermissions(name: "Dashbourd",id: 1,code: "dash",icon:Icons.dashboard.codePoint,screen: true,selectIcon: Icons.dashboard_customize_outlined.codePoint,val: 1,valName: "full"),
                ModelUserPermissions(name: "Users",id: 2,code: "users",icon:Icons.supervised_user_circle.codePoint,screen: true,selectIcon: Icons.supervised_user_circle_outlined.codePoint,val: 1,valName: "full"),
              ],
              phone: "0552601566",
              regionCode: "Baku",
              regionName: "BAKI",
              requestNumber: '10',
              surname: "MEMMEDOV",
              username: "KAMIL MEMMEDOV",
              usernameLogin: true

          ),
          tokenModel: TokenModel(
              accessToken: "ADBBAJNKAJBHJEMEKWMMWNMWMMWKDN231662AWDAWDJHABWDJKNW",
              refreshToken: "ACNAWKLDMLAWD451566+2"
          ),
          companyModel: CompanyModel(
            id: 1,
            name: "Bolluq ltd mmc",
            modelModule: [
              ModelModule(id: 0,name: "Satis modulu"),
              ModelModule(id: 2,name: "Reklam modulu"),
              ModelModule(id: 2,name: "Logistik modulu"),
            ],
          ),
          isLogged: true


      ),
      LoggedUserModel(
          userModel: UserModel(
              id: 5,
              addDateStr: "2022.05.10",
              birthdate: "07.17.1990",
              code: '0012',
              companyId: 1,
              companyName: "Bolluq ltd mmc",
              connections: [ModelUserConnection(code: "100",fullName: "Samir Selimov",roleId: 1,roleName: "Admin"),
                ModelUserConnection(code: "0001",fullName: "ASIF TANRIVERDIYEV",roleId: 2,roleName: "SATIS MUDIRI"),
                ModelUserConnection(code: "0023",fullName: "KAMIL MEMMEDOV",roleId: 3,roleName: "BOLGE MUDIRI"),
              ],
              roleName: "SATIS TEMSILCISI",
              roleId: 5,
              deviceId: "aa1145aqq51257",
              deviceLogin: true,
              email: "ADIL.HESENOV@gmail.com",
              expDate: 5,
              fatherName: "",
              gender: "Kisi",
              lastOnlineDate: "20.01.2023",
              modelModules: [ModelModule(id: 1,name: "ADMIN PANEL"),ModelModule(id: 2,name: "Dashbourd")],
              name: "ADIL",
              moduleId: 2,
              moduleName: "SATIS SOBESI",
              permissions: [
                ModelUserPermissions(name: "Dashbourd",id: 1,code: "dash",icon:Icons.dashboard.codePoint,screen: true,selectIcon: Icons.dashboard_customize_outlined.codePoint,val: 1,valName: "full"),
                ModelUserPermissions(name: "Users",id: 2,code: "users",icon:Icons.supervised_user_circle.codePoint,screen: true,selectIcon: Icons.supervised_user_circle_outlined.codePoint,val: 1,valName: "full"),
              ],
              phone: "0552601566",
              regionCode: "Baku",
              regionName: "BAKI",
              requestNumber: '10',
              surname: "ADIL",
              username: "ADIL HESENOV",
              usernameLogin: true

          ),
          tokenModel: TokenModel(
              accessToken: "ADBBAJNKAJBHJEMEKWMMWNMWMMWKDN231662AWDAWDJHABWDJKNW",
              refreshToken: "ACNAWKLDMLAWD451566+2"
          ),
          companyModel: CompanyModel(
            id: 1,
            name: "Bolluq ltd mmc",
            modelModule: [
              ModelModule(id: 0,name: "Satis modulu"),
              ModelModule(id: 2,name: "Reklam modulu"),
              ModelModule(id: 2,name: "Logistik modulu"),
            ],
          ),
          isLogged: true


      ),
      LoggedUserModel(
          userModel: UserModel(
              id: 6,
              addDateStr: "2022.05.10",
              birthdate: "07.17.1990",
              code: '110',
              companyId: 1,
              companyName: "Bolluq ltd mmc",
              connections: [ModelUserConnection(code: "100",fullName: "Samir Selimov",roleId: 1,roleName: "Admin")],
              roleName: "SUPERVAIZER",
              roleId: 6,
              deviceId: "aa1145aqq51257",
              deviceLogin: true,
              email: "LEYLA.DADASOVA@gmail.com",
              expDate: 5,
              fatherName: "",
              gender: "Qadin",
              lastOnlineDate: "26.06.2023",
              modelModules: [ModelModule(id: 1,name: "ADMIN PANEL"),ModelModule(id: 2,name: "Dashbourd")],
              name: "LEYLA",
              moduleId: 2,
              moduleName: "REKLAM SOBESI",
              permissions: [
                ModelUserPermissions(name: "Dashbourd",id: 1,code: "dash",icon:Icons.dashboard.codePoint,screen: true,selectIcon: Icons.dashboard_customize_outlined.codePoint,val: 1,valName: "full"),
                ModelUserPermissions(name: "Users",id: 2,code: "users",icon:Icons.supervised_user_circle.codePoint,screen: true,selectIcon: Icons.supervised_user_circle_outlined.codePoint,val: 1,valName: "full"),
              ],
              phone: "0552601566",
              regionCode: "Baku",
              regionName: "BAKI",
              requestNumber: '10',
              surname: "DADASOVA",
              username: "LEYLA DADASOVA",
              usernameLogin: true

          ),
          tokenModel: TokenModel(
              accessToken: "ADBBAJNKAJBHJEMEKWMMWNMWMMWKDN231662AWDAWDJHABWDJKNW",
              refreshToken: "ACNAWKLDMLAWD451566+2"
          ),
          companyModel: CompanyModel(
            id: 1,
            name: "Bolluq ltd mmc",
            modelModule: [
              ModelModule(id: 0,name: "Satis modulu"),
              ModelModule(id: 2,name: "Reklam modulu"),
              ModelModule(id: 2,name: "Logistik modulu"),
            ],
          ),
          isLogged: true


      ),
      LoggedUserModel(
          userModel: UserModel(
              id: 6,
              addDateStr: "2022.05.10",
              birthdate: "07.17.1990",
              code: 'M12',
              companyId: 1,
              companyName: "Bolluq ltd mmc",
              connections: [ModelUserConnection(code: "100",fullName: "Samir Selimov",roleId: 1,roleName: "Admin")],
              roleName: "MERCENDAIZER",
              roleId: 6,
              deviceId: "aa1145aqq51257",
              deviceLogin: true,
              email: "AYTEKIN.MEMMEDOVA@gmail.com",
              expDate: 5,
              fatherName: "",
              gender: "QADIN",
              lastOnlineDate: "26.06.2023",
              modelModules: [ModelModule(id: 1,name: "ADMIN PANEL"),ModelModule(id: 2,name: "Dashbourd")],
              name: "AYTEKIN",
              moduleId: 3,
              moduleName: "REKLAM SOBESI",
              permissions: [
                ModelUserPermissions(name: "Dashbourd",id: 1,code: "dash",icon:Icons.dashboard.codePoint,screen: true,selectIcon: Icons.dashboard_customize_outlined.codePoint,val: 1,valName: "full"),
                ModelUserPermissions(name: "Users",id: 2,code: "users",icon:Icons.supervised_user_circle.codePoint,screen: true,selectIcon: Icons.supervised_user_circle_outlined.codePoint,val: 1,valName: "full"),
              ],
              phone: "0552601566",
              regionCode: "Baku",
              regionName: "BAKI",
              requestNumber: '10',
              surname: "MEMMEDOVA",
              username: "AYTEKIN MEMMEDOVA",
              usernameLogin: true

          ),
          tokenModel: TokenModel(
              accessToken: "ADBBAJNKAJBHJEMEKWMMWNMWMMWKDN231662AWDAWDJHABWDJKNW",
              refreshToken: "ACNAWKLDMLAWD451566+2"
          ),
          companyModel: CompanyModel(
            id: 1,
            name: "Bolluq ltd mmc",
            modelModule: [
              ModelModule(id: 0,name: "Satis modulu"),
              ModelModule(id: 2,name: "Reklam modulu"),
              ModelModule(id: 2,name: "Logistik modulu"),
            ],
          ),
          isLogged: true


      ),
      LoggedUserModel(
          userModel: UserModel(
              id: 6,
              addDateStr: "2022.05.10",
              birthdate: "07.17.1990",
              code: 'M12',
              companyId: 1,
              companyName: "Bolluq ltd mmc",
              connections: [ModelUserConnection(code: "100",fullName: "Samir Selimov",roleId: 1,roleName: "Admin")],
              roleName: "MERCENDAIZER",
              roleId: 6,
              deviceId: "aa1145aqq51257",
              deviceLogin: true,
              email: "AYTEKIN.MEMMEDOVA@gmail.com",
              expDate: 5,
              fatherName: "",
              gender: "QADIN",
              lastOnlineDate: "26.06.2023",
              modelModules: [ModelModule(id: 1,name: "ADMIN PANEL"),ModelModule(id: 2,name: "Dashbourd")],
              name: "AYTEKIN",
              moduleId: 3,
              moduleName: "REKLAM SOBESI",
              permissions: [
                ModelUserPermissions(name: "Dashbourd",id: 1,code: "dash",icon:Icons.dashboard.codePoint,screen: true,selectIcon: Icons.dashboard_customize_outlined.codePoint,val: 1,valName: "full"),
                ModelUserPermissions(name: "Users",id: 2,code: "users",icon:Icons.supervised_user_circle.codePoint,screen: true,selectIcon: Icons.supervised_user_circle_outlined.codePoint,val: 1,valName: "full"),
              ],
              phone: "0552601566",
              regionCode: "Baku",
              regionName: "BAKI",
              requestNumber: '10',
              surname: "MEMMEDOVA",
              username: "AYTEKIN MEMMEDOVA",
              usernameLogin: true

          ),
          tokenModel: TokenModel(
              accessToken: "ADBBAJNKAJBHJEMEKWMMWNMWMMWKDN231662AWDAWDJHABWDJKNW",
              refreshToken: "ACNAWKLDMLAWD451566+2"
          ),
          companyModel: CompanyModel(
            id: 1,
            name: "Bolluq ltd mmc",
            modelModule: [
              ModelModule(id: 0,name: "Satis modulu"),
              ModelModule(id: 2,name: "Reklam modulu"),
              ModelModule(id: 2,name: "Logistik modulu"),
            ],
          ),
          isLogged: true


      ),

    ];
  }

}