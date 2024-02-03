import 'package:get/get.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_satis.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carihereket.dart';

class ControllerSatis extends GetxController {
  RxList<ModelCariHereket> listSifarisler = List<ModelCariHereket>.empty(growable: true).obs;
  RxList<ModelAnbarRapor> listMehsullar = List<ModelAnbarRapor>.empty(growable: true).obs;
  RxList<ModelAnbarRapor> selectedListMehsullar = List<ModelAnbarRapor>.empty(growable: true).obs;
  RxList<ModelAnbarRapor> filterlistMehsullar = List<ModelAnbarRapor>.empty(growable: true).obs;
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  RxList<ModelAnaQrupAnbar> listAnaQruplar = List<ModelAnaQrupAnbar>.empty(growable: true).obs;
  ModelAnaQrupAnbar selectedAnaQrupModel=ModelAnaQrupAnbar();
  RxList<ModelAnaQrupAnbar> filteredListAnaQruplar = List<ModelAnaQrupAnbar>.empty(growable: true).obs;
  RxBool dataLoading = true.obs;
  RxString selectedAnaQrup = "".obs;
  ModelCariler modelGirisEdilmisCari = ModelCariler();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  LocalUserServices userService = LocalUserServices();
  LocalBaseSatis localBaseSatis = LocalBaseSatis();
  RxBool evvelkiSatisVarligi = false.obs;
  double evvelkiSifarisinHecmi=0;
  String emeliyyatTipi="s";
  RxString cariKod="".obs;

  @override
  void onInit() {
    initAllBases();
    super.onInit();
  }

  Future<void> initAllBases() async {
    await localBaseDownloads.init();
    await localBaseSatis.init();
    listMehsullar.value = localBaseDownloads.getAllMehsullar();
    loggedUserModel = userService.getLoggedUser();
    fillListAnaQruplar();
  }

  Future<void> getOldSatis(String ckod,String emeliyyat) async {
    emeliyyatTipi=emeliyyat;
    await localBaseSatis.init();
    cariKod.value=ckod;
    if(emeliyyat=="s") {
      listSifarisler.value = localBaseSatis.getAllHereketbyCariKod(ckod);
    }else{
      listSifarisler.value = localBaseSatis.getAllIadelerbyCariKod(ckod);

    }if (listSifarisler.isNotEmpty) {
      evvelkiSatisVarligi.value = true;
      evvelkiSifarisinHecmi=listSifarisler.fold(0, (sum, element) => sum+element.netSatis!);
    }
    update();
  }

  void fillListAnaQruplar() {
    dataLoading.value = true;
    listAnaQruplar.clear();
    filteredListAnaQruplar.clear();
    listAnaQruplar.add(ModelAnaQrupAnbar(
      groupAdi: "Butun Cesidler".toUpperCase(),
      cesidSayi: listMehsullar.length,
      stockOutSayi: listMehsullar.where((a) => a.qaliq == "0").toList().length,
      sifarisCesid: listSifarisler.length,
      totalEndirim: 0,
      totalSatis: 0,
    ));
    var listadlar = listMehsullar.map((element) => element.anaqrup).toList();
    for (var element in listadlar) {
      if (!listAnaQruplar.any((p) => p.groupAdi == element)) {
        listAnaQruplar.add(ModelAnaQrupAnbar(
          groupAdi: element.toString(),
          cesidSayi: listMehsullar
              .where((a) => a.anaqrup == element.toString())
              .toList()
              .length,
          stockOutSayi: listMehsullar
              .where((a) => a.anaqrup == element.toString() && a.qaliq == "0")
              .toList()
              .length,
          sifarisCesid: listSifarisler
              .where((p) => p.anaQrup == element.toString())
              .length,
          totalEndirim: listSifarisler
              .where((p) => p.anaQrup == element.toString())
              .toList()
              .fold(0, (sum, item) => sum! + item.endirimMebleg!),
          totalSatis: listSifarisler
              .where((p) => p.anaQrup == element.toString())
              .toList()
              .fold(0, (sum, item) => sum! + item.netSatis!),
        ));
      }
    }
    for (var element in listAnaQruplar) {
      filteredListAnaQruplar.add(element);
    }
    dataLoading.value = false;
    update();
  }

  Future<void> changeSelectedQroupProducts(ModelAnaQrupAnbar element) async {
    selectedAnaQrup.value = element.groupAdi!;
    selectedAnaQrupModel = element;
    selectedListMehsullar.clear();
    filterlistMehsullar.clear();
    if (listAnaQruplar.indexOf(element) == 0) {
      for (var element in listMehsullar) {
        selectedListMehsullar.add(element);
        filterlistMehsullar.add(element);
      }
    } else {
      listMehsullar.where((p) => p.anaqrup == element.groupAdi).forEach((element) {
        selectedListMehsullar.add(element);
        filterlistMehsullar.add(element);
      });
    }
    update();
  }

  void addSatisToList(ModelAnbarRapor model, int miqdar) {
    if (listSifarisler.any((element) => element.stockKod == model.stokkod&&element.cariKod==cariKod.value)) {
      listSifarisler.where((p) => p.stockKod == model.stokkod&&p.cariKod==cariKod.value).first.miqdar = miqdar;
      listSifarisler.where((p) => p.stockKod == model.stokkod&&p.cariKod==cariKod.value).first.netSatis = miqdar * double.parse(model.satisqiymeti.toString());
    } else {
      ModelCariHereket modela = ModelCariHereket(
        tarix: DateTime.now().toString(),
        anaQrup: model.anaqrup,
        cariKod: modelGirisEdilmisCari.code,
        endirimMebleg: 0,
        gonderildi: false,
        miqdar: miqdar,
        netSatis: double.parse(model.satisqiymeti.toString()) * miqdar,
        qiymet: double.parse(model.satisqiymeti.toString()),
        stockKod: model.stokkod,
        temKod: loggedUserModel.userModel!.code!,
      );
      listSifarisler.add(modela);
    }
    update();
  }

  void remuveSatisToList(ModelAnbarRapor model, int miqdar) {
    if (miqdar == 0) {
      listSifarisler.removeWhere((element) => element.stockKod == model.stokkod&&element.cariKod==cariKod.value);
    } else {
      for (var element in listSifarisler) {
        if (element.stockKod == model.stokkod&&element.cariKod==cariKod.value) {
          element.miqdar = miqdar;
          element.netSatis = double.parse(model.satisqiymeti.toString()) * miqdar;
        }
      }
    }
    update();
  }

  void deleteAllSifarisBayAnaQrup(ModelAnaQrupAnbar element) {
    listSifarisler.removeWhere((el) => el.anaQrup == element.groupAdi);
    update();
  }

  void filterAnaQrup(String st) {
    filteredListAnaQruplar.clear();
    if (st.isNotEmpty) {
      listAnaQruplar
          .where((p) => p.groupAdi!.toUpperCase().contains(st.toUpperCase()))
          .forEach((element) {
        filteredListAnaQruplar.add(element);
      });
    } else {
      for (var element in listAnaQruplar) {
        filteredListAnaQruplar.add(element);
      }
    }
    update();
  }

  void filterMehsul(String st) {
    filterlistMehsullar.clear();
    if (st.isNotEmpty) {
      selectedListMehsullar
          .where((p) => p.stokadi!.toUpperCase().contains(st.toUpperCase())&&p.stokkod!.contains(st.toString()))
          .forEach((element) {
        filterlistMehsullar.add(element);
      });
    } else {
      for (var element in selectedListMehsullar) {
        filterlistMehsullar.add(element);
      }
    }
    update();
  }

  Future<void> addSifarislerToDatabase(String ckod) async {
    if(emeliyyatTipi=="s") {
      if(listSifarisler.isEmpty){
        await localBaseSatis.addHereketToBase(listSifarisler);

      }else {
        await localBaseSatis.addHereketToBase(listSifarisler);
        Get.back(result: "OK");
      }}else{
      await localBaseSatis.addIadeToBase(listSifarisler);
      if (evvelkiSatisVarligi.isFalse) {
        Get.back(result: "OK");
      } else {
        Get.back(result: "OK");
      }
    }
    Get.delete<ControllerSatis>();

  }

  void sortAnaGruplar() {
    ModelAnaQrupAnbar model=filteredListAnaQruplar.elementAt(0);
    filteredListAnaQruplar.sort((a, b) => a.groupAdi!.compareTo(b.groupAdi!));
    filteredListAnaQruplar.remove(model);
    filteredListAnaQruplar.insert(0, model);

    userService;

  }
}
