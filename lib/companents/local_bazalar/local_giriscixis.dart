import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/setting_panel/screen_maps_setting.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/global_models/model_maptypeapp.dart';

class LocalGirisCixisServiz {
  late Box girisCixis = Hive.box<ModelGirisCixis>("girisCixis");

  Future<void> init() async {
    girisCixis = await Hive.openBox<ModelGirisCixis>("girisCixis");
  }

  Future<void> addSelectedGirisCixisDB(ModelGirisCixis model) async {
    await girisCixis.put("${model.ckod!}|${model.girisvaxt!}", model);
  }

  Future<void> updateSelectedValue(ModelGirisCixis model) async {
    await deleteItem(model.ckod!,model.girisvaxt!);
    await girisCixis.put("${model.ckod!}|${model.girisvaxt!}", model);
    getAllGirisCixisToday();
  }

  Future<ModelGirisCixis> getGirisEdilmisMarket() async {
    ModelGirisCixis model = ModelGirisCixis();
    girisCixis.toMap().forEach((key, value) {
      if (value.cixismesafe == "0") {
        model = value;
      }
    });
    return model;
  }

 List<ModelGirisCixis> getAllGirisCixis() {
   deleteItemOld();
    List<ModelGirisCixis> listGirisler=[];
    girisCixis.toMap().forEach((key, value) {
      if (value.cixismesafe != "0") {
        listGirisler.add(value);
      }
    });
    return listGirisler;
  }

 List<ModelGirisCixis> getAllGirisCixisToday() {
    List<ModelGirisCixis> listGirisler=[];
    girisCixis.toMap().forEach((key, value) {
      if (value.cixismesafe != "0"&&convertDayByLastday(value)) {
          int count =girisCixis.toMap().entries.where((element) => element.value.ckod==value.ckod).toList().length;
          value.girisSayi==count;
        listGirisler.add(value);
      }});
    listGirisler.sort((a, b) => a.girisvaxt!.compareTo(b.girisvaxt!));

    return listGirisler;
  }

  bool convertDayByLastday(ModelGirisCixis element) {
    DateTime lastDay = DateTime.parse(element.tarix!);
    return lastDay.toString().substring(0,11) == DateTime.now().toString().substring(0,11) ? true : false;
  }

  Future<void> deleteItemOld() async {
    final box = Hive.box<ModelGirisCixis>("girisCixis");
    final Map<dynamic, ModelGirisCixis> deliveriesMap = box.toMap();
    deliveriesMap.forEach((key, value) {
      if (convertDayByLastday(value)==false) {
        box.delete(key);
      }
    });
  }

  Future<void> deleteItem(String ckod,String girisVaxt) async {
    final box = Hive.box<ModelGirisCixis>("girisCixis");
    final Map<dynamic, ModelGirisCixis> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.ckod == ckod && value.girisvaxt==girisVaxt) {
        desiredKey = key;
      }
    });
    box.delete(desiredKey);
  }

  Future<void> clearAllGiris() async {
    await girisCixis.clear();
  }
}
