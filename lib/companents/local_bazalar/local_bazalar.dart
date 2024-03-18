import 'package:hive/hive.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';

import '../base_downloads/models/model_downloads.dart';

class LocalBazalar{


  deleteAllBases(){
     Hive.deleteFromDisk();

  }
}