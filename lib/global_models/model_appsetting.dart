import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/setting_panel/screen_maps_setting.dart';
import 'package:zs_managment/global_models/model_maptypeapp.dart';
part 'model_appsetting.g.dart';


@HiveType(typeId: 10)
class ModelAppSetting{
  @HiveField(0)
  ModelMapApp? mapsetting;
  @HiveField(1)
  String? girisCixisType;
  @HiveField(2)
  bool? userStartWork;


  ModelAppSetting.name(this.mapsetting);


  ModelAppSetting({ this.mapsetting, this.girisCixisType, this.userStartWork});

  factory ModelAppSetting.fromJson(Map<String, dynamic> json) => ModelAppSetting(
      mapsetting: json["mapsetting"] == null ? null : ModelMapApp.fromJson(json["mapsetting"]),
      girisCixisType: json['girisCixisType']==null?"map":json["girisCixisType"],
      userStartWork: json['userStartWork']==null?false:json["userStartWork"]
  );

  @override
  String toString() {
    return 'ModelAppSetting{mapsetting: $mapsetting, girisCixisType: $girisCixisType, userStartWork: $userStartWork}';
  }
}