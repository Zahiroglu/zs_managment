import 'package:get/get.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';

class ControllerUserZiyaret extends GetxController {
  LocalUserServices userService = LocalUserServices();
  RxList<ModelMainInOut> listGirisCixis = List<ModelMainInOut>.empty(growable: true).obs;
  RxList<ModelInOutDay> listGunlukGirisCixislar = List<ModelInOutDay>.empty(growable: true).obs;
  RxList<ModelMainInOut> modelInOut = List<ModelMainInOut>.empty(growable: true).obs;
  String totalIsSaati="0";
  RxBool dataLoading = true.obs;
  late CheckDviceType checkDviceType = CheckDviceType();
  ExeptionHandler exeptionHandler=ExeptionHandler();

  @override
  Future<void> onInit() async {
    await userService.init();
    super.onInit();
  }


  @override
  void dispose() {
    Get.delete<ControllerUserZiyaret>;
    super.dispose();
  }

  Future<void> getAllUsers( List<ModelMainInOut> listGirisCixislar) async {
    dataLoading.value = true;
    if(listGirisCixislar.isNotEmpty) {
      print("ModelInOutDay leng"+ listGirisCixislar.first.modelInOutDays.length.toString());
      for (ModelInOutDay element in listGirisCixislar.first.modelInOutDays) {
        listGunlukGirisCixislar.add(element);
      }
    }
    listGirisCixis.value=listGirisCixislar;
    dataLoading.value = false;
    update();
  }


}
