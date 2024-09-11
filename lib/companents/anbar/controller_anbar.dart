import 'package:get/get.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import '../../routs/rout_controller.dart';

class ControllerAnbar extends GetxController {
  RxList<ModelAnbarRapor> listMehsullar = List<ModelAnbarRapor>.empty(growable: true).obs;
  RxList<ModelAnbarRapor> listSelectedMehsullar = List<ModelAnbarRapor>.empty(growable: true).obs;
  RxList<ModelAnaQrupAnbar> listAnaQruplar = List<ModelAnaQrupAnbar>.empty(growable: true).obs;
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  RxBool dataLoading = true.obs;


  @override
  void onInit() {
    initAllDatabases();
    super.onInit();
  }



  Future<void> initAllDatabases() async {
    await localBaseDownloads.init();
    listMehsullar.value = localBaseDownloads.getAllMehsullar();
    fillListAnaQruplar();
    update();
  }

  void fillListAnaQruplar() {
    dataLoading.value = true;
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
        ));
      }
    }
    dataLoading.value = false;
    update();
  }

  Future<void> changeSelectedQroupProducts(ModelAnaQrupAnbar element) async {
    listSelectedMehsullar.value = listMehsullar.where((p) => p.anaqrup == element.groupAdi!).toList();
    await Get.toNamed(RouteHelper.anbarCesidlerSehfesi, arguments: [ listSelectedMehsullar.value]);
    update();
  }


}

class ModelAnaQrupAnbar {
  String? groupAdi;
  int? cesidSayi;
  int? stockOutSayi;
  double? totalSatis;
  int? sifarisCesid;
  double? totalEndirim;

  ModelAnaQrupAnbar({this.groupAdi, this.cesidSayi, this.stockOutSayi,this.totalSatis,this.totalEndirim,this.sifarisCesid});

  @override
  String toString() {
    return 'ModelAnaQrupAnbar{groupAdi: $groupAdi, cesidSayi: $cesidSayi, stockOutSayi: $stockOutSayi, totalSatis: $totalSatis, sifarisCesid: $sifarisCesid, totalEndirim: $totalEndirim}';
  }
}