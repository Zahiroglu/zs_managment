import 'package:zs_managment/app_companents/model/model_vezifeler.dart';
import 'package:zs_managment/login/models/model_useracces.dart';

class ModelModules {
  int? modulID;
  String? moduleName;
  List<ModelVezifeler>? listVezifeler;

  ModelModules({this.modulID, this.moduleName, this.listVezifeler});

  List<ModelModules> getAktivModules() {
    return [
      ModelModules(modulID:0,moduleName: 'SATIS SOBESI',listVezifeler:
          [
            ModelVezifeler(roleId:0, roleName:"SATIS MUDIRI"),
            ModelVezifeler(roleId:1, roleName:"BOLGE MUDIRI"),
            ModelVezifeler(roleId:2,roleName: "TECRUBECI BOLGE MUDIRI"),
            ModelVezifeler(roleId:3,roleName: "SATIS TEMSILCISI"),
            ModelVezifeler(roleId:4,roleName: "TECRUBECI SATIS TEMSILCISI"),
          ]),
      ModelModules(modulID:1,moduleName: 'CMR SOBESI',listVezifeler:
          [
            ModelVezifeler(roleId:5,roleName: "CRM MUDIRI"),
            ModelVezifeler(roleId:6, roleName: "CRM AUDIT",),
            ModelVezifeler(roleId:7,roleName:  "CRM TECRUBECI AUDIT"),
            ModelVezifeler(roleId:8,roleName:  "CRM OPERATOR"),
          ]),
      ModelModules(modulID:2,moduleName: 'REKLAM SOBESI',listVezifeler:
          [
            ModelVezifeler(roleId:9,roleName:  "SUPERVAIZER"),
            ModelVezifeler(roleId:10,roleName:  "TECRUBECI SUPERVAIZER"),
            ModelVezifeler(roleId:11,roleName:  "MERCENDAIZER"),
            ModelVezifeler(roleId:12,roleName:  "TECRUBECI MERCENDAIZER"),
          ])

    ];
  }
}
