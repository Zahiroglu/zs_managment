import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/setting_panel/screen_maps_setting.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/global_models/model_maptypeapp.dart';

class LocalAppSetting {
  late Box appSettings = Hive.box("appSettings");

  Future<void> init() async {
    appSettings = await Hive.openBox("appSettings");
  }

  Future<void> addSelectedMyTypeToLocalDB(ModelAppSetting availableMap) async {
    print("changed setting value :"+availableMap.toString());
    await appSettings.clear();
    await appSettings.add(availableMap);
  }

  Future<ModelAppSetting> getAvaibleMap() async{
    ModelAppSetting model=ModelAppSetting(mapsetting: null, girisCixisType: "list");
    if(appSettings.values.firstOrNull!=null){
      model= await appSettings.values.firstOrNull;
    }
    return model;
  }



}
