import 'package:flutter/material.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/login/models/model_useracces.dart';
import 'package:zs_managment/login/models/user_model.dart';

class UserAccessController {

  List<GroupUserAcces> allUsersAcces(){
    List<GroupUserAcces> allUsersAcces=[
      GroupUserAcces(id: 1,groupName: "Umumi",listAccess: [
        UserAccess(id: 1,accesName: "canSeeScreenUserContoroll",accesType: AccesType.notAccess,accesKod: "U1"),
        UserAccess(id: 2,accesName: "canSeeScreenDashbourd",accesType: AccesType.notAccess,accesKod: "U2"),
        UserAccess(id: 3,accesName: "canSeeScreenAnbar",accesType: AccesType.notAccess,accesKod: "U3"),
        UserAccess(id: 4,accesName: "canSeeScreenOnlineMap",accesType: AccesType.notAccess,accesKod: "U4"),
      ]),
      GroupUserAcces(id: 1,groupName: "Mercedaizing",listAccess: [
          UserAccess(id: 1,accesName: "canSeeScreenAllMercsRouts",accesType: AccesType.notAccess,accesKod: "M1"),
          UserAccess(id: 2,accesName: "canSeeScreenMercDetail",accesType: AccesType.notAccess,accesKod: "M2"),
          UserAccess(id: 3,accesName: "canSeeScreenMercEdit",accesType: AccesType.notAccess,accesKod: "M3"),
          UserAccess(id: 4,accesName: "canSeeScreenAddNewMusteri",accesType: AccesType.notAccess,accesKod: "M4"),
          UserAccess(id: 5,accesName: "canSeeScreenMercMusteriEdit",accesType: AccesType.notAccess,accesKod: "M5"),
      ]),
      GroupUserAcces(id: 2,groupName: "Satis",listAccess: [
          UserAccess(id: 1,accesName: "canSeeScreenAllExpList",accesType: AccesType.notAccess,accesKod: "S1"),
          UserAccess(id: 2,accesName: "canSeeScreenExpRoutDetail",accesType: AccesType.notAccess,accesKod: "S2"),
          UserAccess(id: 3,accesName: "canSeeScreenExpCustomerDetail",accesType: AccesType.notAccess,accesKod: "S3"),
          UserAccess(id: 4,accesName: "canSeeScreenExpEditCustomerDetail",accesType: AccesType.notAccess,accesKod: "S4"),
          UserAccess(id: 5,accesName: "canSeeScreenExpEditRoutDetail",accesType: AccesType.notAccess,accesKod: "S5"),
      ]),
    ];
    return allUsersAcces;
  }

  List<GroupUserAcces>getUserAccessByUserRoleId(int roleId){
    List<GroupUserAcces> listaccess=[];
    switch(roleId){
      case 0 ://satis mudiri
        listaccess=[
          GroupUserAcces(id: 1,groupName: "Umumi",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenUserContoroll",accesType: AccesType.notAccess,accesKod: "U1"),
            UserAccess(id: 3,accesName: "canSeeScreenAnbar",accesType: AccesType.notAccess,accesKod: "U3"),
            UserAccess(id: 4,accesName: "canSeeScreenOnlineMap",accesType: AccesType.notAccess,accesKod: "U4"),
          ]),
          GroupUserAcces(id: 1,groupName: "Mercedaizing",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllMercsRouts",accesType: AccesType.notAccess,accesKod: "M1"),
            UserAccess(id: 2,accesName: "canSeeScreenMercDetail",accesType: AccesType.notAccess,accesKod: "M2"),
            UserAccess(id: 3,accesName: "canSeeScreenMercEdit",accesType: AccesType.notAccess,accesKod: "M3"),
            UserAccess(id: 4,accesName: "canSeeScreenAddNewMusteri",accesType: AccesType.notAccess,accesKod: "M4"),
            UserAccess(id: 5,accesName: "canSeeScreenMercMusteriEdit",accesType: AccesType.notAccess,accesKod: "M5"),
          ]),
          GroupUserAcces(id: 2,groupName: "Satis",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllExpList",accesType: AccesType.notAccess,accesKod: "S1"),
            UserAccess(id: 2,accesName: "canSeeScreenExpRoutDetail",accesType: AccesType.notAccess,accesKod: "S2"),
            UserAccess(id: 3,accesName: "canSeeScreenExpCustomerDetail",accesType: AccesType.notAccess,accesKod: "S3"),
            UserAccess(id: 4,accesName: "canSeeScreenExpEditCustomerDetail",accesType: AccesType.notAccess,accesKod: "S4"),
            UserAccess(id: 5,accesName: "canSeeScreenExpEditRoutDetail",accesType: AccesType.notAccess,accesKod: "S5"),
          ]),
        ];
        break;
      case 1://bolgeMudiri
        listaccess=[
          GroupUserAcces(id: 1,groupName: "Umumi",listAccess: [
            UserAccess(id: 3,accesName: "canSeeScreenAnbar",accesType: AccesType.notAccess,accesKod: "U3"),
            UserAccess(id: 4,accesName: "canSeeScreenOnlineMap",accesType: AccesType.notAccess,accesKod: "U4"),
          ]),
          GroupUserAcces(id: 1,groupName: "Mercedaizing",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllMercsRouts",accesType: AccesType.notAccess,accesKod: "M1"),
            UserAccess(id: 2,accesName: "canSeeScreenMercDetail",accesType: AccesType.notAccess,accesKod: "M2"),
            UserAccess(id: 3,accesName: "canSeeScreenMercEdit",accesType: AccesType.notAccess,accesKod: "M3"),
            UserAccess(id: 4,accesName: "canSeeScreenAddNewMusteri",accesType: AccesType.notAccess,accesKod: "M4"),
            UserAccess(id: 5,accesName: "canSeeScreenMercMusteriEdit",accesType: AccesType.notAccess,accesKod: "M5"),
          ]),
          GroupUserAcces(id: 2,groupName: "Satis",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllExpList",accesType: AccesType.notAccess,accesKod: "S1"),
            UserAccess(id: 2,accesName: "canSeeScreenExpRoutDetail",accesType: AccesType.notAccess,accesKod: "S2"),
            UserAccess(id: 3,accesName: "canSeeScreenExpCustomerDetail",accesType: AccesType.notAccess,accesKod: "S3"),
            UserAccess(id: 4,accesName: "canSeeScreenExpEditCustomerDetail",accesType: AccesType.notAccess,accesKod: "S4"),
            UserAccess(id: 5,accesName: "canSeeScreenExpEditRoutDetail",accesType: AccesType.notAccess,accesKod: "S5"),
          ]),
        ];
        break;
      case 2://tecrubeci bolge mudiri
        listaccess=[
          GroupUserAcces(id: 1,groupName: "Umumi",listAccess: [
            UserAccess(id: 3,accesName: "canSeeScreenAnbar",accesType: AccesType.notAccess,accesKod: "U3"),
            UserAccess(id: 4,accesName: "canSeeScreenOnlineMap",accesType: AccesType.notAccess,accesKod: "U4"),
          ]),
          GroupUserAcces(id: 1,groupName: "Mercedaizing",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllMercsRouts",accesType: AccesType.notAccess,accesKod: "M1"),
            UserAccess(id: 2,accesName: "canSeeScreenMercDetail",accesType: AccesType.notAccess,accesKod: "M2"),
            UserAccess(id: 3,accesName: "canSeeScreenMercEdit",accesType: AccesType.notAccess,accesKod: "M3"),
            UserAccess(id: 4,accesName: "canSeeScreenAddNewMusteri",accesType: AccesType.notAccess,accesKod: "M4"),
            UserAccess(id: 5,accesName: "canSeeScreenMercMusteriEdit",accesType: AccesType.notAccess,accesKod: "M5"),
          ]),
          GroupUserAcces(id: 2,groupName: "Satis",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllExpList",accesType: AccesType.notAccess,accesKod: "S1"),
            UserAccess(id: 2,accesName: "canSeeScreenExpRoutDetail",accesType: AccesType.notAccess,accesKod: "S2"),
            UserAccess(id: 3,accesName: "canSeeScreenExpCustomerDetail",accesType: AccesType.notAccess,accesKod: "S3"),
            UserAccess(id: 4,accesName: "canSeeScreenExpEditCustomerDetail",accesType: AccesType.notAccess,accesKod: "S4"),
            UserAccess(id: 5,accesName: "canSeeScreenExpEditRoutDetail",accesType: AccesType.notAccess,accesKod: "S5"),
          ]),
        ];
        break;
      case 3: //expeditor
        listaccess=[
          GroupUserAcces(id: 1,groupName: "Umumi",listAccess: [
            UserAccess(id: 3,accesName: "canSeeScreenAnbar",accesType: AccesType.notAccess,accesKod: "U3"),
            UserAccess(id: 4,accesName: "canSeeScreenOnlineMap",accesType: AccesType.notAccess,accesKod: "U4"),
          ]),
          GroupUserAcces(id: 1,groupName: "Mercedaizing",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllMercsRouts",accesType: AccesType.notAccess,accesKod: "M1"),
          ]),
          GroupUserAcces(id: 2,groupName: "Satis",listAccess: [
            UserAccess(id: 2,accesName: "canSeeScreenExpRoutDetail",accesType: AccesType.notAccess,accesKod: "S2"),
            UserAccess(id: 3,accesName: "canSeeScreenExpCustomerDetail",accesType: AccesType.notAccess,accesKod: "S3"),
          ]),
        ];
        break;
      case 4: //tecrubeci expeditor
        listaccess=[
          GroupUserAcces(id: 1,groupName: "Umumi",listAccess: [
            UserAccess(id: 3,accesName: "canSeeScreenAnbar",accesType: AccesType.notAccess,accesKod: "U3"),
            UserAccess(id: 4,accesName: "canSeeScreenOnlineMap",accesType: AccesType.notAccess,accesKod: "U4"),
          ]),
          GroupUserAcces(id: 1,groupName: "Mercedaizing",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllMercsRouts",accesType: AccesType.notAccess,accesKod: "M1"),
          ]),
          GroupUserAcces(id: 2,groupName: "Satis",listAccess: [
            UserAccess(id: 2,accesName: "canSeeScreenExpRoutDetail",accesType: AccesType.notAccess,accesKod: "S2"),
            UserAccess(id: 3,accesName: "canSeeScreenExpCustomerDetail",accesType: AccesType.notAccess,accesKod: "S3"),
          ]),
        ];
        break;
      case 5:
        listaccess=[
          GroupUserAcces(id: 1,groupName: "Umumi",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenUserContoroll",accesType: AccesType.fullAccess,accesKod: "U1"),
            UserAccess(id: 3,accesName: "canSeeScreenAnbar",accesType: AccesType.fullAccess,accesKod: "U3"),
            UserAccess(id: 4,accesName: "canSeeScreenOnlineMap",accesType: AccesType.fullAccess,accesKod: "U4"),
          ]),
          GroupUserAcces(id: 1,groupName: "Mercedaizing",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllMercsRouts",accesType: AccesType.fullAccess,accesKod: "M1"),
            UserAccess(id: 2,accesName: "canSeeScreenMercDetail",accesType: AccesType.fullAccess,accesKod: "M2"),
            UserAccess(id: 3,accesName: "canSeeScreenMercEdit",accesType: AccesType.fullAccess,accesKod: "M3"),
            UserAccess(id: 4,accesName: "canSeeScreenAddNewMusteri",accesType: AccesType.fullAccess,accesKod: "M4"),
            UserAccess(id: 5,accesName: "canSeeScreenMercMusteriEdit",accesType: AccesType.fullAccess,accesKod: "M5"),
          ]),
          GroupUserAcces(id: 2,groupName: "Satis",listAccess: [
            UserAccess(id: 1,accesName: "canSeeScreenAllExpList",accesType: AccesType.fullAccess,accesKod: "S1"),
            UserAccess(id: 2,accesName: "canSeeScreenExpRoutDetail",accesType: AccesType.fullAccess,accesKod: "S2"),
            UserAccess(id: 3,accesName: "canSeeScreenExpCustomerDetail",accesType: AccesType.fullAccess,accesKod: "S3"),
            UserAccess(id: 4,accesName: "canSeeScreenExpEditCustomerDetail",accesType: AccesType.fullAccess,accesKod: "S4"),
            UserAccess(id: 5,accesName: "canSeeScreenExpEditRoutDetail",accesType: AccesType.fullAccess,accesKod: "S5"),
          ]),
        ];
        break;
    }





    return listaccess;
  }



}


