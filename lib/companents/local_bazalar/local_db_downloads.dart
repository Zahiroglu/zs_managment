import 'package:hive/hive.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_downloads.dart';
import 'package:zs_managment/companents/dashbourd/models/model_rut_perform.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';

import '../giris_cixis/models/model_customers_visit.dart';
import '../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';

class LocalBaseDownloads {
  late Box downloads = Hive.box<ModelDownloads>("baseDownloads");
 late Box boxCariBaza = Hive.box<ModelCariler>("CariBaza");
  late Box boxAnbarBaza = Hive.box<ModelAnbarRapor>("AnbarBaza");
  late Box boxListConnectedUsers = Hive.box<UserModel>("listConnectedUsers");
  late Box boxListMercBaza = Hive.box<MercDataModel>("listMercDataModel");
  late Box boxMotivasiyaMerc = Hive.box<MercDataModel>("boxMotivasiyaMerc");
  LocalGirisCixisServiz localGirisCixisServiz=LocalGirisCixisServiz();

  Future<void> init() async {
    downloads = await Hive.openBox<ModelDownloads>("baseDownloads");
    boxCariBaza = await Hive.openBox<ModelCariler>("CariBaza");
    boxAnbarBaza = await Hive.openBox<ModelAnbarRapor>("AnbarBaza");
    boxListConnectedUsers = await Hive.openBox<UserModel>("listConnectedUsers");
    boxListMercBaza = await Hive.openBox<MercDataModel>("listMercDataModel");
    boxMotivasiyaMerc = await Hive.openBox<MercDataModel>("boxMotivasiyaMerc");
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
      return boxListMercBaza.toMap().isNotEmpty?true:false;

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

  Future<List<ModelDownloads>> getAllDownLoadBaseList() async{
    List<ModelDownloads> list = [];
    downloads.toMap().forEach((key, value) {
        list.add(value);
    });
    for (var element in list) {
      element.musteDonwload = convertDayByLastday(element);
      element.donloading=false;
    }
    if(list.any((element) => element.code=="myConnectedUsers")){
      ModelDownloads model=list.where((element) => element.code=="myConnectedUsers").first;
      list.removeWhere((element) => element.code=="myConnectedUsers");
      list.insert(0, model);
    }
    return list;
  }

  String getLastUpdatedFieldDate(String code) {
    String tarix="";
    downloads.toMap().forEach((key, value) {
       if(value.code.toString()==code.toString()){
         tarix=value.lastDownDay.toString().substring(0,16);
         tarix=tarix.replaceAll("T", " ");
       }
    });
    return tarix;
  }

  bool? convertDayByLastday(ModelDownloads element) {
    String dayFerq=element.lastDownDay!.substring(0,10);
    String day2=DateTime.now().toString().substring(0,10);
    return dayFerq == day2 ? false : true;
  }

  Future<bool> checkIfUserMustDonwloadsBase(int? roleId) async {
    int deyer=0;
    List<ModelDownloads> listustDown = await getAllDownLoadBaseList();
    if(listustDown.isEmpty){
      deyer==0;
    }else{
      deyer = listustDown.where((element) => element.musteDonwload == true).length;
    }
    return deyer==0?false:true;
  }

  Future<bool> checkIfUserMustDonwloadsBaseFirstTime(int? roleId) async {
    int deyer=0;
    List<ModelDownloads> listustDown = await getAllDownLoadBaseList();
    if(listustDown.isEmpty){
      deyer=1;
    }else{
      deyer = listustDown.where((element) => element.musteDonwload == true).length;
    }
    print("deyer :"+deyer.toString());
    return deyer==0?false:true;
  }

//////Umumi Rut gostericilerini Doldur//////

  Future<ModelRutPerform> getRutDatailForMerc(bool hamisi,String temKod,String loggedUser) async {
    print("Selected User :"+temKod.toString());
    ModelRutPerform modelRutPerform=ModelRutPerform();
    List<ModelCariler> listCariler=[];
    List<ModelCariler> listRutGUNU=[];
    List<ModelCariler> listZiyaretedilmeyen=[];
    int sayDuzgunZiyaret=0;
    int saySefZiyaret=0;
    List<ModelCustuomerVisit> listGirisCixis= [];
    List<ModelCustuomerVisit> listGonderilmeyeneler= localGirisCixisServiz.getAllUnSendedGirisCixis();
    if(hamisi){
      listCariler= await getAllMercCustomers();
      listGirisCixis= localGirisCixisServiz.getAllGirisCixisToday();
      listRutGUNU =listCariler.where((element) => element.rutGunu=="Duz").toList();
      sayDuzgunZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.isRutDay==true).toList()).length;
      saySefZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.isRutDay==false).toList()).length;
    }else{
      if(temKod=="m"){
        temKod=loggedUser;
      }
      await getAllMercCustomersByUserCode(temKod).then((list){
        listCariler=list;
        listRutGUNU = list.where((element) => element.rutGunu=="Duz").toList();
        listGirisCixis= localGirisCixisServiz.getAllGirisCixisTodayByCode(temKod);
        sayDuzgunZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.isRutDay==true).toList()).length;
        saySefZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.isRutDay==false).toList()).length;
      });

    }
    listZiyaretedilmeyen =ziyaretEdilmeyenler(listRutGUNU,listGirisCixis);
    modelRutPerform=ModelRutPerform(
      listGunlukRut: listRutGUNU,
      listZiyaretEdilmeyen: listZiyaretedilmeyen,
      snSayi: listCariler.length,
      rutSayi: listRutGUNU.length,
      duzgunZiya:sayDuzgunZiyaret,
      rutkenarZiya: saySefZiyaret,
      listGirisCixislar: localGirisCixisServiz.getAllGirisCixisToday(),
      listGonderilmeyenZiyaretler: listGonderilmeyeneler,
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
    List<ModelCustuomerVisit> listGirisCixis= localGirisCixisServiz.getAllGirisCixisToday();

    if(hamisi){
      listCariler=getAllCariBaza();
      listRutGUNU =listCariler.where((element) => rutDuzgunluyuYoxla(element)=="Duz").toList();
    }else{
      listCariler=getAllCariBaza().toList().where((element) => element.forwarderCode==temKod).toList();
      listRutGUNU =listCariler.where((element) => rutDuzgunluyuYoxla(element)=="Duz"&&element.forwarderCode==temKod).toList();
    }
    listZiyaretedilmeyen =ziyaretEdilmeyenler(listRutGUNU,listGirisCixis);
    int sayDuzgunZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.isRutDay==true).toList()).length;
    int saySefZiyaret=dublicatesRemuvedList(listGirisCixis.where((e) => e.isRutDay==false).toList()).length;
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

  List<ModelCustuomerVisit> dublicatesRemuvedList(List<ModelCustuomerVisit> listAll){
    List<ModelCustuomerVisit> newList=[];
    for (var element in listAll) {
      if(newList.where((a) => a.customerCode==element.customerCode).isEmpty){
        newList.add(element);
      }
    }
    return newList;
  }

  String rutDuzgunluyuYoxla(ModelCariler selectedModel) {
    String rutgun = "Sef";
    int hefteningunu = DateTime.now().weekday;
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

 String circulateSnlerdeQalmaVaxti(List<ModelCustuomerVisit> allGirisCixis) {
    Duration umumiVaxtDeqiqe=const Duration();
    for (var element in allGirisCixis) {
      umumiVaxtDeqiqe=umumiVaxtDeqiqe+getTimeDifferenceFromNow(DateTime.parse(element.inDate.toString()),DateTime.parse(element.outDate.toString()));
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

  circulateUmumiIsVaxti(ModelCustuomerVisit first, ModelCustuomerVisit last) {
    Duration umumiVaxtDeqiqe=getTimeDifferenceFromNow(DateTime.parse(first.inDate.toString()),DateTime.parse(last.outDate.toString()));
    int hours = umumiVaxtDeqiqe.inHours % 24;
    int minutes = umumiVaxtDeqiqe.inMinutes % 60;
    if(hours<1){return "$minutes deq";}else{return "$hours saat $minutes deq";}
  }

  List<ModelCariler> ziyaretEdilmeyenler(List<ModelCariler> listRutGUNU, List<ModelCustuomerVisit> listGirisCixis) {
    List<ModelCariler> ziyaretEdilemyenler=[];
    for (var element in listRutGUNU) {
      if(listGirisCixis.any((value) => value.customerCode==element.code)){
      }else{
        ziyaretEdilemyenler.add(element);
      }

    }
    return ziyaretEdilemyenler;
  }

  ///Anbar bazasi////
  Future<void> addAnbarBaza(List<ModelAnbarRapor> mallar) async {
    await boxAnbarBaza.clear();
    for (ModelAnbarRapor model in mallar) {await boxAnbarBaza.put(model.stokkod!, model);}
  }

  List<ModelAnbarRapor> getAllMehsullar() {
    List<ModelAnbarRapor> list = [];
    boxAnbarBaza.toMap().forEach((key, value) {list.add(value);});
    return list;
  }

  bool getIfAnbarBaseDownloaded(){
    return boxAnbarBaza.toMap().isNotEmpty?true:false;
  }

  ///listUsers baza
  Future<void> addConnectedUsers(List<UserModel> listUser) async {
    await boxAnbarBaza.clear();
    for (UserModel model in listUser) {
      if(model.name==null){
        await boxListConnectedUsers.put(model.code!, model);
      }else{
        await boxListConnectedUsers.put(model.name!, model);

      }
    }
  }

  List<UserModel> getAllConnectedUserFromLocal() {
    List<UserModel> list = [];
      boxListConnectedUsers.toMap().forEach((key, value) {list.add(value);});
    return list;
  }
  List<UserModel> getAllConnectedUserFromLocalMerc() {
    List<UserModel> list = [];
    boxListConnectedUsers.toMap().forEach((key, value) {list.add(value);});
    return list.where((e)=>e.roleId==23||e.roleId==24).toList();
  }
  Future<List<MercDataModel>> getAllMercDatail() async {
    List<MercDataModel> list = [];
    boxListMercBaza.toMap().forEach((key, value) {list.add(value);});
    return list;
  }
  Future<List<MercDataModel>> getAllMercDatailByCode(String code) async {
    List<MercDataModel> list = [];
    boxListMercBaza.toMap().forEach((key, value) {
      if(value.user.code==code){
        list.add(value);
      }
      });
    return list;
  }

  Future<List<ModelCariler>> getAllMercCustomers()  async{
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
            latitude:modelMerc.latitude,
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
        modelCari.rutGunu=rutDuzgunluyuYoxla(modelCari);
        listCariler.add(modelCari);
      }
    }
    return listCariler;
  }
  Future<List<ModelCariler>> getAllMercCustomersByUserCode(String temKodu)  async{
    List<ModelCariler> listCariler = [];
    List<MercDataModel> list = [];
    boxListMercBaza.toMap().forEach((key, value) {
      list.add(value);
    });
    for(MercDataModel model in list.where((e)=>e.user!.code==temKodu).toList()){
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
            latitude:modelMerc.latitude,
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
        modelCari.rutGunu=rutDuzgunluyuYoxla(modelCari);
        listCariler.add(modelCari);
      }
    }
    return listCariler;
  }

  Future<void> addAllToMercBase(List<MercDataModel> cariler) async {
    await boxListMercBaza.clear();
    for (MercDataModel model in cariler) {await boxListMercBaza.put(model.user!.code, model);}
  }

  Future<void> addDataMotivationMerc(List<MercDataModel> cariler) async {
    await boxMotivasiyaMerc.clear();
    for (MercDataModel model in cariler) {await boxMotivasiyaMerc.put(model.user!.code, model);}
  }

}
