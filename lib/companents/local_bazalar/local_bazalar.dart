import 'package:hive/hive.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';

import '../base_downloads/models/model_downloads.dart';

class LocalBazalar{
  LocalUserServices localUserServices=LocalUserServices();
  LocalGirisCixisServiz localGirisCixisServiz=LocalGirisCixisServiz();
  LocalBaseDownloads localBaseDownloads=LocalBaseDownloads();
  deleteAllBases(){Hive.deleteFromDisk();}


  clearAllBaseDownloads() async {
    await  localBaseDownloads.init();
    await localBaseDownloads.clearAllData();

  }

  clearAllGirisCixis() async {
    await  localGirisCixisServiz.init();
  //  await localGirisCixisServiz.clearAllGiris();
  }

  clearLoggedUserInfo() async {
   await  localUserServices.init();
   await localUserServices.clearALLdata();
  }

  claerBaseUrl() async {
    await  localUserServices.init();
    await localUserServices.clearBaseUrl();
  }

}