import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_satis.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carihereket.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../giris_cixis/sceens/reklam_girisCixis/controller_giriscixis_reklam.dart';

class ControllerSifarisDetal extends GetxController {
  LocalBaseSatis localBaseSatis = LocalBaseSatis();
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  late RxList<ModelCariler> listCariler = List<ModelCariler>.empty(growable: true).obs;
  late RxList<ModelSimpleCari> listSelectedCariler = List<ModelSimpleCari>.empty(growable: true).obs;
  late Rx<ModelSatisEmeliyyati> modelSatisEmeliyyat = ModelSatisEmeliyyati().obs;
  RxBool dataLoading = true.obs;
  RxList<ModelSifarislerTablesi> listTabSifarisler = List<ModelSifarislerTablesi>.empty(growable: true).obs;
  @override
  void onInit() {
    initBases();
    super.onInit();
  }

  Future<void> initBases() async {
    await localBaseDownloads.init();
    await localBaseSatis.init();
    await getSatisDetail();
  }

  Future<void> getSatisDetail() async {
    dataLoading.value = true;
    listSelectedCariler.clear();
    listCariler.value = localBaseDownloads.getAllCariBaza();
    modelSatisEmeliyyat.value = localBaseSatis.getTodaySatisEmeliyyatlari();
    for (var element in modelSatisEmeliyyat.value.listSatis!) {
      if (listCariler.where((p) => p.code == element.cariKod).isNotEmpty) {
        ModelCariler model=listCariler.where((p) => p.code == element.cariKod).first;
        ModelSimpleCari modelSimpleCari=ModelSimpleCari(model.code, model.name, false);
        if(!listSelectedCariler.contains(modelSimpleCari)){
          print("element :"+modelSimpleCari.toString());
          listSelectedCariler.add(modelSimpleCari);
          print("listSelectedCariler :"+listSelectedCariler.toString());

        }
      }
    }
    listTabSifarisler.value = [
      ModelSifarislerTablesi(
          label: "Satis",
          icon: "images/sales.png",
          summa: modelSatisEmeliyyat.value.listSatis!.fold(
              0, (sum, element) => sum! + element.netSatis!),
          type: "s",
          color: Colors.blue),
      ModelSifarislerTablesi(
          label: "Iade",
          icon: "images/dollar.png",
          summa:
          modelSatisEmeliyyat.value.listIade!.fold(0, (sum, element) => sum! + element.netSatis!),
          type: "i",
          color: Colors.deepPurple),
      ModelSifarislerTablesi(
          label: "Kassa",
          icon: "images/payment.png",
          summa:
          modelSatisEmeliyyat.value.listKassa!.fold(0, (sum, element) => sum! + element.kassaMebleg!),
          type: "k",
          color: Colors.green),
    ];
    dataLoading.value = false;
    update();
  }

  Widget cardSatisItem(ModelSimpleCari e) {
    return  Stack(
      children: [
        Card(
          margin: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CustomText(labeltext: e.ckod!,fontsize: 12,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,top: 5,bottom: 5),
                    child: Image.asset("images/successupload.png",height: 60,width: 60,),
                  ),
                ],
              ),
              Container(width: 1,height: 100,color: Colors.black,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  CustomText(labeltext: e.cad!,fontsize: 16,fontWeight: FontWeight.w600,),
                 Padding(
                   padding: const EdgeInsets.all(5.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           CustomText(labeltext: "Cesit sayi :",fontsize: 14,fontWeight: FontWeight.normal,),
                           const SizedBox(width: 5,),
                           CustomText(labeltext: modelSatisEmeliyyat.value.listSatis!.where((element) => element.cariKod==e.ckod).length.toString(),fontsize: 14,fontWeight: FontWeight.normal,),
                         ],
                       ),
                       Row(
                         children: [
                           CustomText(labeltext: "Satis :",fontsize: 14,fontWeight: FontWeight.normal,),
                           const SizedBox(width: 5,),
                           CustomText(labeltext: "${prettify(modelSatisEmeliyyat.value.listSatis!.where((element) => element.cariKod==e.ckod)
                               .fold(0.0, (sum, element) => sum+element.netSatis!))} AZN",fontsize: 14,fontWeight: FontWeight.normal,),
                         ],
                       ),
                       Row(
                         children: [
                           CustomText(labeltext: "Endirim :",fontsize: 14,fontWeight: FontWeight.normal,),
                           const SizedBox(width: 5,),
                           CustomText(labeltext: "${prettify(modelSatisEmeliyyat.value.listSatis!.where((element) => element.cariKod==e.ckod)
                               .fold(0.0, (sum, element) => sum+element.endirimMebleg!))} AZN",fontsize: 14,fontWeight: FontWeight.normal,),
                         ],
                       ),
                     ],
                   ),
                 )


                ],),
              )
            ],
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: Checkbox(value: e.isChecked,onChanged: (va){},))
      ],
    );
  }



  String prettify(double d) {
    return d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
  }
}
class ModelSimpleCari{
  String? ckod;
  String? cad;
  bool? isChecked;

  ModelSimpleCari(this.ckod, this.cad, this.isChecked);

  @override
  String toString() {
    return 'ModelSimpleCari{ckod: $ckod, cad: $cad, isChecked: $isChecked}';
  }
}