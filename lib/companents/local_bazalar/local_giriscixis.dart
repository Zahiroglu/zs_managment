
import 'package:hive/hive.dart';
import '../giris_cixis/models/model_customers_visit.dart';
import '../rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';

class LocalGirisCixisServiz {
  Box<ModelCustuomerVisit>? girisCixis;
  Box<ModelMainInOut>? girisCixisServer;

  Future<void> init() async {
    girisCixis = await Hive.openBox<ModelCustuomerVisit>("girisCixis");
    girisCixisServer = await Hive.openBox<ModelMainInOut>("girisCixisServer");
  }

  Future<void> addSelectedGirisCixisDB(ModelCustuomerVisit model) async {
    await girisCixis!.put("${model.customerCode!}|${model.inDate!}|${model.operationType!}", model);
  }

  Future<void> addSelectedGirisCixisDBServer(ModelMainInOut model) async {
    await clearAllGirisServer();
    await girisCixisServer!.put("${model.userCode}", model);
  }
  Future<void> clearAllGirisServer() async {
    await girisCixisServer!.clear();
  }
  List<ModelMainInOut> getAllGirisCixisServer() {
    List<ModelMainInOut> listGirisler=[];
    girisCixisServer!.toMap().forEach((key, value) {
        listGirisler.add(value);
    });
    return listGirisler;
  }

  Future<void> updateSelectedValue(ModelCustuomerVisit model) async {
    await deleteItem(model);
    await girisCixis!.put("${model.customerCode!}|${model.inDate.toString()}|${model.operationType!}", model);
    getAllGirisCixisToday();
  }

  Future<ModelCustuomerVisit> getGirisEdilmisMarket() async {
    List<ModelCustuomerVisit> listGirisler=[];
    ModelCustuomerVisit model = ModelCustuomerVisit();
    girisCixis!.toMap().forEach((key, value) {
        listGirisler.add(value);
    });
    listGirisler.sort((a, b) => a.inDate!.compareTo(b.inDate!));
    if(listGirisler.isNotEmpty){
      if(listGirisler.last.operationType!="out"){
        model=listGirisler.last;
      }else{
        model = ModelCustuomerVisit();
      }

    }
    return model;
  }

 List<ModelCustuomerVisit> getAllGirisCixis() {
   deleteItemOld();
    List<ModelCustuomerVisit> listGirisler=[];
    girisCixis!.toMap().forEach((key, value) {
      if (value.outDistance != "0") {
        listGirisler.add(value);
      }
    });
    return listGirisler;
  }

 List<ModelCustuomerVisit> getAllUnSendedGirisCixis() {
   List<ModelCustuomerVisit> listGirisler=[];
   girisCixis!.toMap().forEach((key, value) {
     if (convertDayByLastday(value)&&value.gonderilme=="0") {
       int count =girisCixis!.toMap().entries.where((element) => element.value.customerCode==value.customerCode).toList().length;
       value.enterCount==count;
       listGirisler.add(value);
     }});
   listGirisler.sort((a, b) => a.inDate!.compareTo(b.inDate!));
   return listGirisler;
  }

 List<ModelCustuomerVisit> getAllGirisCixisToday() {
    List<ModelCustuomerVisit> listGirisler=[];
    girisCixis!.toMap().forEach((key, value) {
      if (value.outDistance != "0"&&convertDayByLastday(value)) {
          int count =girisCixis!.toMap().entries.where((element) => element.value.customerCode==value.customerCode).toList().length;
          value.enterCount==count;
        listGirisler.add(value);
      }});
    listGirisler.sort((a, b) => a.inDate!.compareTo(b.inDate!));

    return listGirisler;
  }
 List<ModelCustuomerVisit> getAllGirisCixisTodayByCode(String userCode) {
    List<ModelCustuomerVisit> listGirisler=[];
    girisCixis!.toMap().forEach((key, value) {
      if (value.outDistance != "0"&&convertDayByLastday(value)&&value.userCode==userCode) {
          int count =girisCixis!.toMap().entries.where((element) => element.value.customerCode==value.customerCode).toList().length;
          value.enterCount==count;
        listGirisler.add(value);
      }});
    listGirisler.sort((a, b) => a.inDate!.compareTo(b.inDate!));

    return listGirisler;
  }

  bool convertDayByLastday(ModelCustuomerVisit element) {
    DateTime lastDay = DateTime.parse(element.inDt.toString());
    return lastDay.toString().substring(0,11) == DateTime.now().toString().substring(0,11) ? true : false;
  }

  Future<void> deleteItemOld() async {
    final box = Hive.box<ModelCustuomerVisit>("girisCixis");
    final Map<dynamic, ModelCustuomerVisit> deliveriesMap = box.toMap();
    deliveriesMap.forEach((key, value) {
      if (convertDayByLastday(value)==false) {
        box.delete(key);
      }
    });
  }

  Future<void> deleteItem(ModelCustuomerVisit model) async {
    final box = Hive.box<ModelCustuomerVisit>("girisCixis");
    final Map<dynamic, ModelCustuomerVisit> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.customerCode == model.customerCode.toString() && value.inDate.toString()==model.inDate.toString()&& value.operationType.toString()==model.operationType.toString()) {
        desiredKey = key;
        box.delete(desiredKey);
      }
    });
  }

  Future<void> clearAllGiris() async {
    await girisCixis!.clear();
  }
}
