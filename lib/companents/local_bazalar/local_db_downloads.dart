import 'package:hive/hive.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_downloads.dart';
import 'package:zs_managment/companents/dashbourd/models/model_rut_perform.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_satis.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';

import '../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';

class LocalBaseDownloads {
  late Box downloads = Hive.box<ModelDownloads>("baseDownloads");
 late Box boxCariBaza = Hive.box<ModelCariler>("CariBaza");
  late Box boxAnbarBaza = Hive.box<ModelAnbarRapor>("AnbarBaza");
  late Box boxListConnectedUsers = Hive.box<UserModel>("listConnectedUsers");
  late Box boxListMercBaza = Hive.box<MercDataModel>("listMercDataModel");
  LocalGirisCixisServiz localGirisCixisServiz=LocalGirisCixisServiz();

  Future<void> init() async {
    downloads = await Hive.openBox<ModelDownloads>("baseDownloads");
    boxCariBaza = await Hive.openBox<ModelCariler>("CariBaza");
    boxAnbarBaza = await Hive.openBox<ModelAnbarRapor>("AnbarBaza");
    boxListConnectedUsers = await Hive.openBox<UserModel>("listConnectedUsers");
    boxListMercBaza = await Hive.openBox<MercDataModel>("listMercDataModel");
    await localGirisCixisServiz.init();
  }


  Future<void> clearAllData() async {
    await downloads.clear();
    await boxCariBaza.clear();
    await boxAnbarBaza.clear();
    await boxListConnectedUsers.clear();
    await boxListMercBaza.clear();
  }

  bool getIfCariBaseDownloaded(int moduleId){
    if(moduleId==3){
      print('Merc baza count :'+boxListMercBaza.toMap().length.toString());
      return boxListMercBaza.toMap().isNotEmpty?true:false;
    }else{
      print('Exp baza count :'+boxCariBaza.toMap().length.toString());
      return boxCariBaza.toMap().isNotEmpty?true:false;
    }
  }

  Future<void> addCariBaza(List<ModelCariler> cariler) async {
    await boxCariBaza.clear();
    for (ModelCariler model in cariler) {
      await boxCariBaza.put(model.code??"0", model);
    }
  }

  List<ModelCariler> getAllCariBaza() {
    List<ModelCariler> list = [];
    boxCariBaza.toMap().forEach((key, value) {
      list.add(value);
    });
    for (var element in list) {
      element.rutGunu=rutDuzgunluyuYoxla(element);
    }
    return list;
  }

  Future<void> updateModelCari(ModelCariler model) async {
    await deleteItemFromCari(model);
    await boxCariBaza.add(model);
  }

  Future<void> deleteItemFromCari(ModelCariler model) async {
    dynamic desiredKey;
    boxCariBaza.toMap().forEach((key, value) {
      if (value.code == model.code) {
        desiredKey = key;
      }
    });
    if (desiredKey != null) {
      boxCariBaza.delete(desiredKey);
    }
  }

  Future<void> addDownloadedBaseInfo(ModelDownloads base) async {
    await deleteItem(base.code!);
    await downloads.put(base.code, base);
  }

  Future<void> deleteItem(String code) async {
    dynamic desiredKey;
    downloads.toMap().forEach((key, value) {
      if (value.code == code) {
        desiredKey = key;
      }
    });
    if (desiredKey != null) {
      downloads.delete(desiredKey);
    }
  }

  List<ModelDownloads> getAllDownLoadBaseList() {
    List<ModelDownloads> list = [];
    downloads.toMap().forEach((key, value) {
      if(value.code=="myUserRut"){
        list.insert(0, value);
      }else{
        list.add(value);
      }
    });
    for (var element in list) {
      element.musteDonwload = convertDayByLastday(element);
      element.donloading=false;
      print("Yuklemekeler :"+element.toString());
    }
    return list;
  }

  bool? convertDayByLastday(ModelDownloads element) {
    String dayFerq=element.lastDownDay!.substring(0,10);
    String day2=DateTime.now().toString().substring(0,10);
    return dayFerq == day2 ? false : true;
  }

  bool checkIfUserMustDonwloadsBase(int? roleId) {
    int deyer=0;
    List<ModelDownloads> listustDown = getAllDownLoadBaseList();
    if(listustDown.isEmpty){
      deyer==0;
    }else{
      deyer = listustDown.where((element) => element.musteDonwload == true).length;
      print('Endirilmeli baza sayi :' + deyer.toString());
    }
    return deyer==0?false:true;
  }

//////Umumi Rut gostericilerini Doldur//////

  Future<ModelRutPerform> getRutDatailForMerc(bool hamisi,String temKod) async {
    ModelRutPerform modelRutPerform=ModelRutPerform();
    List<ModelCariler> listCariler=[];
    List<ModelCariler> listRutGUNU=[];
    List<ModelCariler> listZiyaretedilmeyen=[];
    List<ModelGirisCixis> listGirisCixis= localGirisCixisServiz.getAllGirisCixisToday();
    if(hamisi){
      listCariler= getAllMercBazaForGirisCixis();
      listRutGUNU =listCariler.where((element) => rutDuzgunluyuYoxla(element)=="Duz").toList();
    }else{
      listCariler= getAllMercBazaForGirisCixis().toList().where((element) => element.forwarderCode==temKod).toList();
      listRutGUNU =listCariler.where((element) => rutDuzgunluyuYoxla(element)=="Duz"&&element.forwarderCode==temKod).toList();
    }
    listZiyaretedilmeyen =ziyaretEdilmeyenler(listRutGUNU,listGirisCixis);
    int sayDuzgunZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.rutgunu=="Duz").toList()).length;
    int saySefZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.rutgunu=="Sef").toList()).length;
    modelRutPerform=ModelRutPerform(
      listGunlukRut: listRutGUNU,
      listZiyaretEdilmeyen: listZiyaretedilmeyen,
      snSayi: listCariler.length,
      rutSayi: listRutGUNU.length,
      duzgunZiya:sayDuzgunZiyaret,
      rutkenarZiya: saySefZiyaret,
      listGirisCixislar: localGirisCixisServiz.getAllGirisCixisToday(),
      ziyaretEdilmeyen: listRutGUNU.length-sayDuzgunZiyaret,
      snlerdeQalma: circulateSnlerdeQalmaVaxti(localGirisCixisServiz.getAllGirisCixisToday()),
      umumiIsvaxti: localGirisCixisServiz.getAllGirisCixisToday().isEmpty?"":circulateUmumiIsVaxti(localGirisCixisServiz.getAllGirisCixisToday().first,localGirisCixisServiz.getAllGirisCixisToday().last),
    );
    if(modelRutPerform.snSayi==null){
      return ModelRutPerform();
    }else {
      return modelRutPerform;
    }}


  Future<ModelRutPerform> getRutDatail(bool hamisi,String temKod) async {
    ModelRutPerform modelRutPerform=ModelRutPerform();
    List<ModelCariler> listCariler=[];
    List<ModelCariler> listRutGUNU=[];
    List<ModelCariler> listZiyaretedilmeyen=[];
    List<ModelGirisCixis> listGirisCixis= localGirisCixisServiz.getAllGirisCixisToday();

    if(hamisi){
      listCariler=getAllCariBaza();
      listRutGUNU =listCariler.where((element) => rutDuzgunluyuYoxla(element)=="Duz").toList();
    }else{
      listCariler=getAllCariBaza().toList().where((element) => element.forwarderCode==temKod).toList();
      listRutGUNU =listCariler.where((element) => rutDuzgunluyuYoxla(element)=="Duz"&&element.forwarderCode==temKod).toList();
    }
    listZiyaretedilmeyen =ziyaretEdilmeyenler(listRutGUNU,listGirisCixis);
    int sayDuzgunZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.rutgunu=="Duz").toList()).length;
    int saySefZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.rutgunu=="Sef").toList()).length;
    modelRutPerform=ModelRutPerform(
      listGunlukRut: listRutGUNU,
      listZiyaretEdilmeyen: listZiyaretedilmeyen,
      snSayi: listCariler.length,
      rutSayi: listRutGUNU.length,
      duzgunZiya:sayDuzgunZiyaret,
      rutkenarZiya: saySefZiyaret,
      listGirisCixislar: localGirisCixisServiz.getAllGirisCixisToday(),
      ziyaretEdilmeyen: listRutGUNU.length-sayDuzgunZiyaret,
      snlerdeQalma: circulateSnlerdeQalmaVaxti(localGirisCixisServiz.getAllGirisCixisToday()),
      umumiIsvaxti: localGirisCixisServiz.getAllGirisCixisToday().isEmpty?"":circulateUmumiIsVaxti(localGirisCixisServiz.getAllGirisCixisToday().first,localGirisCixisServiz.getAllGirisCixisToday().last),
    );
    if(modelRutPerform.snSayi==null){
      return ModelRutPerform();
    }else {
      return modelRutPerform;
    }}

  List<ModelGirisCixis> dublicatesRemuvedList(List<ModelGirisCixis> listAll){
    List<ModelGirisCixis> newList=[];
    for (var element in listAll) {
      if(newList.where((a) => a.ckod==element.ckod).isEmpty){
        newList.add(element);
      }
    }
    return newList;
  }

  String rutDuzgunluyuYoxla(ModelCariler selectedModel) {
    String rutgun = "Sef";
    int hefteningunu = DateTime
        .now()
        .weekday;
    if(selectedModel.days!=null){
    switch (hefteningunu) {
      case 1:
        if (selectedModel.days!.any((element) => element.day==1)) {
          rutgun = "Duz";

        }
        break;
      case 2:
        if (selectedModel.days!.any((element) => element.day==2)) {
          rutgun = "Duz";
        }
        break;
      case 3:
        if (selectedModel.days!.any((element) => element.day==3)) {
          rutgun = "Duz";
        }
        break;
      case 4:
        if (selectedModel.days!.any((element) => element.day==4)) {
          rutgun = "Duz";
        }
        break;
      case 5:
        if (selectedModel.days!.any((element) => element.day==5)) {
          rutgun = "Duz";
        }
        break;
      case 6:
        if (selectedModel.days!.any((element) => element.day==6)) {
          rutgun = "Duz";
        }
        break;
      default:
        rutgun = "Sef";
    }}
    return rutgun;
  }

 String circulateSnlerdeQalmaVaxti(List<ModelGirisCixis> allGirisCixis) {
    String vaxt="";
    Duration umumiVaxtDeqiqe=const Duration();
    for (var element in allGirisCixis) {
      umumiVaxtDeqiqe=umumiVaxtDeqiqe+getTimeDifferenceFromNow(DateTime.parse(element.girisvaxt.toString()),DateTime.parse(element.cixisvaxt.toString()));
    }
    int hours = umumiVaxtDeqiqe.inHours % 24;
    int minutes = umumiVaxtDeqiqe.inMinutes % 60;
    if(hours<1){
      return "$minutes deq";
    }else{
      return "$hours saat $minutes deq";
    }
  }

  Duration getTimeDifferenceFromNow(DateTime girisvaxt,DateTime cixisVaxt) {
    Duration difference = cixisVaxt.difference(girisvaxt);
    return difference;
  }

  circulateUmumiIsVaxti(ModelGirisCixis first, ModelGirisCixis last) {
    Duration umumiVaxtDeqiqe=getTimeDifferenceFromNow(DateTime.parse(first.girisvaxt.toString()),DateTime.parse(last.cixisvaxt.toString()));
    int hours = umumiVaxtDeqiqe.inHours % 24;
    int minutes = umumiVaxtDeqiqe.inMinutes % 60;
    if(hours<1){
      return "$minutes deq";
    }else{
      return "$hours saat $minutes deq";
    }
  }

  List<ModelCariler> ziyaretEdilmeyenler(List<ModelCariler> listRutGUNU, List<ModelGirisCixis> listGirisCixis) {
    List<ModelCariler> ziyaretEdilemyenler=[];
    for (var element in listRutGUNU) {
      if(listGirisCixis.any((value) => value.ckod==element.code)){
        print("${element.name}: giris edilib");
      }else{
        ziyaretEdilemyenler.add(element);
      }

    }
    return ziyaretEdilemyenler;
  }

  ///Anbar bazasi////
  Future<void> addAnbarBaza(List<ModelAnbarRapor> mallar) async {
    await boxAnbarBaza.clear();
    for (ModelAnbarRapor model in mallar) {
      await boxAnbarBaza.put(model.stokkod!, model);
    }
  }

  List<ModelAnbarRapor> getAllMehsullar() {
    List<ModelAnbarRapor> list = [];
    boxAnbarBaza.toMap().forEach((key, value) {
      list.add(value);
    });

    return list;
  }

  bool getIfAnbarBaseDownloaded(){
    return boxAnbarBaza.toMap().isNotEmpty?true:false;
  }

  ///listUsers baza
  Future<void> addConnectedUsers(List<UserModel> listUser) async {
    await boxAnbarBaza.clear();
    for (UserModel model in listUser) {
      await boxListConnectedUsers.put(model.name!, model);
    }
  }

  List<UserModel> getAllConnectedUserFromLocal() {
    List<UserModel> list = [];
    boxListConnectedUsers.toMap().forEach((key, value) {
      list.add(value);
    });

    return list;
  }

  Future<List<MercDataModel>> getAllMercDatail() async {
    List<MercDataModel> list = [];
    boxListMercBaza.toMap().forEach((key, value) {
      list.add(value);
    });
    return list;
  }
  List<ModelCariler> getAllMercBazaForGirisCixis()  {
    List<ModelCariler> listCariler = [];
    List<MercDataModel> list = [];
    boxListMercBaza.toMap().forEach((key, value) {
      list.add(value);
    });
    for(MercDataModel model in list){
      List<MercCustomersDatail> musteriler=model.mercCustomersDatail!;
      for(MercCustomersDatail modelMerc in musteriler){
        ModelCariler modelCari=ModelCariler(
            name: modelMerc.name,
            code: modelMerc.code,
            forwarderCode: model.user!.code,
            fullAddress: modelMerc.fullAddress,
            days: modelMerc.days,
            action: modelMerc.action,
            area: modelMerc.area,
            category: modelMerc.category,
            district: modelMerc.district,
            latitude: modelMerc.latitude,
            longitude: modelMerc.longitude,
            debt: modelMerc.debt,
            mainCustomer: modelMerc.mainCustomer,
            mesafe: "",
            mesafeInt: 0,
            ownerPerson: modelMerc.ownerPerson,
            phone: modelMerc.phone,
            postalCode: modelMerc.postalCode,
            regionalDirectorCode: modelMerc.regionalDirectorCode,
            rutGunu: "",
            salesDirectorCode: modelMerc.salesDirectorCode,
            tin: modelMerc.tin,
            ziyaretSayi: 0

        );
        listCariler.add(modelCari);
      }
    }
    return listCariler;
  }

  Future<void> addAllToMercBase(List<MercDataModel> cariler) async {
    await boxListMercBaza.clear();
    for (MercDataModel model in cariler) {
      await boxListMercBaza.put(model.user!.code??"0", model);
    }
  }

}
