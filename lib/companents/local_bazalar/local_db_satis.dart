import 'package:hive/hive.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_downloads.dart';
import 'package:zs_managment/companents/dashbourd/models/model_rut_perform.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carihereket.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carikassa.dart';

class LocalBaseSatis {
  late Box boxBaseSatis = Hive.box<ModelCariHereket>("baseSatis");
 late Box boxBaseKassa = Hive.box<ModelCariKassa>("baseKassa");
  late Box boxBaseIade = Hive.box<ModelCariHereket>("baseIade");


  Future<void> init() async {
    boxBaseSatis = await Hive.openBox<ModelCariHereket>("baseSatis");
    boxBaseKassa = await Hive.openBox<ModelCariKassa>("baseKassa");
    boxBaseIade = await Hive.openBox<ModelCariHereket>("baseIade");
  }

  Future<void> clearAllData() async {
    await boxBaseSatis.clear();
    await boxBaseKassa.clear();
    await boxBaseIade.clear();
  }

  ModelSatisEmeliyyati getTodaySatisEmeliyyatlari(){
    return ModelSatisEmeliyyati(
      listSatis: getAllSatisToday(),
      listIade: getAllIadelerToday(),
      listKassa: getAllKassaToday()
    );
  }


  List<ModelCariHereket> getAllSatisToday() {
    List<ModelCariHereket> listSatis=[];
    boxBaseSatis.toMap().forEach((key, value) {
      if (convertDayByLastday(DateTime.parse(value.tarix))) {
        listSatis.add(value);
      }});
    listSatis.sort((a, b) => a.tarix!.compareTo(b.tarix!));

    return listSatis;
  }
  List<ModelCariHereket> getAllIadelerToday() {
    List<ModelCariHereket> listSatis=[];
    boxBaseIade.toMap().forEach((key, value) {
      if (convertDayByLastday(DateTime.parse(value.tarix))) {
        listSatis.add(value);
      }});
    listSatis.sort((a, b) => a.tarix!.compareTo(b.tarix!));

    return listSatis;
  }
  List<ModelCariKassa> getAllKassaToday() {
    List<ModelCariKassa> listKassa=[];
    boxBaseKassa.toMap().forEach((key, value) {
      if (convertDayByLastday(DateTime.parse(value.tarix))) {
        listKassa.add(value);
      }});
    listKassa.sort((a, b) => a.tarix!.compareTo(b.tarix!));

    return listKassa;
  }
  bool convertDayByLastday(DateTime element) {
    return element.toString().substring(0,11) == DateTime.now().toString().substring(0,11) ? true : false;
  }

  ///Satis Emeliyyatlari
  Future<void> addHereketToBase(List<ModelCariHereket> hereketler) async {
    for (ModelCariHereket model in hereketler) {
      deleteItemFromHereketler(model);
      await boxBaseSatis.put("${model.cariKod!}-${model.stockKod!}", model);
    }
  }
  List<ModelCariHereket> getAllHereket() {
    List<ModelCariHereket> list = [];
    boxBaseSatis.toMap().forEach((key, value) {
      if (convertDayByLastday(DateTime.parse(value.tarix))) {
        list.add(value);
      }
    });
    return list;
  }
  List<ModelCariHereket> getAllHereketbyCariKod(String cariKod) {
    List<ModelCariHereket> list = [];
    boxBaseSatis.toMap().forEach((key, value) {
      if(value.cariKod==cariKod&&convertDayByLastday(DateTime.parse(value.tarix))){
      list.add(value);
      }
    });
    return list;
  }
  Future<void> updateModelHereket(ModelCariHereket model) async {
    await deleteItemFromHereketler(model);
    await boxBaseSatis.put("${model.cariKod!}-${model.stockKod!}", model);
  }
  Future<void> deleteItemFromHereketler(ModelCariHereket model) async {
    dynamic desiredKey;
    boxBaseSatis.toMap().forEach((key, value) {
      if (value.stockKod == model.stockKod&&model.cariKod==value.cariKod&&convertDayByLastday(DateTime.parse(value.tarix))) {
        desiredKey = key;
      }
    });
    if (desiredKey != null) {
      boxBaseSatis.delete(desiredKey);
    }
  }
  Future<void> deleteItemsFromHereketler(String ckod) async {
    dynamic desiredKey;
    boxBaseSatis.toMap().forEach((key, value) {
      if (value.cariKod ==ckod&&convertDayByLastday(DateTime.parse(value.tarix))) {
        desiredKey = key;
      }
    });
    if (desiredKey != null) {
      boxBaseSatis.delete(desiredKey);
    }
  }

    ///iade emeliyyatlari/////
  Future<void> addIadeToBase(List<ModelCariHereket> hereketler) async {
    for (ModelCariHereket model in hereketler) {
      deleteItemFromIadeler(model);
      await boxBaseIade.put("${model.cariKod!}-${model.stockKod!}", model);
    }
  }
  List<ModelCariHereket> getAllIadeler() {
    List<ModelCariHereket> list = [];
    boxBaseIade.toMap().forEach((key, value) {
      if (convertDayByLastday(DateTime.parse(value.tarix))) {
        list.add(value);
      }    }
    );
    return list;
  }
  List<ModelCariHereket> getAllIadelerbyCariKod(String cariKod) {
    List<ModelCariHereket> list = [];
    boxBaseIade.toMap().forEach((key, value) {
      if(value.cariKod==cariKod&&convertDayByLastday(DateTime.parse(value.tarix))){
        list.add(value);
      }
    });
    return list;
  }
  Future<void> updateModelIade(ModelCariHereket model) async {
    await deleteItemFromIadeler(model);
    await boxBaseIade.put("${model.cariKod!}-${model.stockKod!}", model);
  }
  Future<void> deleteItemFromIadeler(ModelCariHereket model) async {
    dynamic desiredKey;
    boxBaseIade.toMap().forEach((key, value) {
      if (value.stockKod == model.stockKod&&model.cariKod==value.cariKod&&convertDayByLastday(DateTime.parse(value.tarix))) {
        desiredKey = key;
      }
    });
    if (desiredKey != null) {
      boxBaseIade.delete(desiredKey);
    }
  }
  Future<void> deleteItemsFromIadeler(String ckod) async {
    dynamic desiredKey;
    boxBaseIade.toMap().forEach((key, value) {
      if (value.cariKod ==ckod&&convertDayByLastday(DateTime.parse(value.tarix))) {
        desiredKey = key;
      }
    });
    if (desiredKey != null) {
      boxBaseIade.delete(desiredKey);
    }
  }

  ///Kassa Elave et/////
  Future<void> addKassaToBase(ModelCariKassa model) async {
      deleteItemFromKassalar(model);
      await boxBaseKassa.put(model.cariKod!, model);
  }
  Future<void> deleteItemFromKassalar(ModelCariKassa model) async {
    dynamic desiredKey;
    boxBaseKassa.toMap().forEach((key, value) {
      if (value.cariKod == model.cariKod&&model.cariKod==value.cariKod&&convertDayByLastday(DateTime.parse(value.tarix))) {
        desiredKey = key;
      }
    });
    if (desiredKey != null) {
      boxBaseKassa.delete(desiredKey);
    }
  }
  List<ModelCariKassa> getAllKassa() {
    List<ModelCariKassa> list = [];
    boxBaseKassa.toMap().forEach((key, value) {
      if(value.tarix!=null) {
        if (convertDayByLastday(DateTime.parse(value.tarix))) {
          list.add(value);
        }
      }});

    return list;
  }

  List<ModelCariKassa> getAllKassabyCariKod(String cariKod) {
    List<ModelCariKassa> list = [];
    boxBaseKassa.toMap().forEach((key, value) {
      if(value.cariKod==cariKod){
        list.add(value);
      }
    });
    return list;
  }
}
class ModelSatisEmeliyyati{
  List<ModelCariHereket>? listSatis;
  List<ModelCariHereket>? listIade;
  List<ModelCariKassa>? listKassa;

  ModelSatisEmeliyyati({this.listSatis, this.listIade, this.listKassa});

  @override
  String toString() {
    return 'ModelSatisEmeliyyati{listSatis: $listSatis, listIade: $listIade, listKassa: $listKassa}';
  }
}