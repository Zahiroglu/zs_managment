import 'package:hive/hive.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';

import '../base_downloads/models/model_downloads.dart';

class LocalBazalar{
  // late Box loggedUserBox = Hive.box("LoggedUsers");
  // late Box baseDownloads = Hive.box("baseDownloads");
  // late Box cariBaza = Hive.box("CariBaza");
  // late Box girisCixis = Hive.box("girisCixis");
  // late Box firstTimeOpen = Hive.box("firstTimeOpen");
  // late Box appSettings = Hive.box("appSettings");


  deleteAllBases(){
     Hive.deleteFromDisk();
     // late Box loggedUserBox = Hive.box("LoggedUsers");
     // loggedUserBox.clear();
     // late Box downloads = Hive.box<ModelDownloads>("baseDownloads");
     // downloads.clear();
     // late Box boxCariBaza = Hive.box<ModelCariler>("CariBaza");
     // boxCariBaza.clear();
     // late Box girisCixis = Hive.box<ModelGirisCixis>("girisCixis");
     // girisCixis.clear();
     // late Box firstTimeOpen = Hive.box("firstTimeOpen");
     // firstTimeOpen.clear();
     // late Box appSettings = Hive.box("appSettings");
     // appSettings.clear();
     // late Box anbarBaza = Hive.box("AnbarBaza");
     // anbarBaza.clear();
     // late Box baseSatis = Hive.box("baseSatis");
     // baseSatis.clear();
     // late Box baseKassa = Hive.box("baseKassa");
     // baseKassa.clear();
     // late Box baseIade = Hive.box("baseIade");
     // baseIade.clear();
  }
}