import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/controller_satis.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';

class ScreenSifarisler extends StatefulWidget {
  ModelCariler modelCari;
  String satisTipi="s";
  ScreenSifarisler({required this.modelCari,required this.satisTipi, super.key});

  @override
  State<ScreenSifarisler> createState() => _ScreenSifarislerState();
}

class _ScreenSifarislerState extends State<ScreenSifarisler> {
  ControllerSatis controllerSatis = Get.put(ControllerSatis());
  bool mustSearch = false;
  TextEditingController ctSearch = TextEditingController();

  @override
  void initState() {
    if (controllerSatis.initialized) {
      controllerSatis.getOldSatis(widget.modelCari.code!,widget.satisTipi.toString());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        _cixisAlqoritmasiniQur();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 65,
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            title: !mustSearch
                ? CustomText(labeltext: widget.modelCari.name!)
                : searchField(),
            actions: [
              mustSearch
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          mustSearch = false;
                          ctSearch.text = "";
                          controllerSatis.filterAnaQrup("");
                        });
                      },
                      icon: Icon(Icons.clear))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          mustSearch = true;
                        });
                      },
                      icon: Icon(Icons.search_outlined))
            ],
          ),
          body: Obx(() => controllerSatis.dataLoading.isFalse
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0).copyWith(left: 15,right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(labeltext:widget.satisTipi=="s"?"Satis":"IADE",color: Colors.black,fontsize: 18,fontWeight: FontWeight.w800,),
                            InkWell(
                                onTap: (){
                                  controllerSatis.sortAnaGruplar();
                                },
                                child: const Icon(Icons.sort))
                          ],
                        ),
                      ),
                      _body(context),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: _footer(context)),
                    ],
                  ),
                )
              : LoagindAnimation(
                  isDark: Get.isDarkMode,
                  icon: "lottie/loagin_animation.json",
                  textData: "Melumatlar yuklenir...")),
        ),
      ),
    );
  }

  Widget searchField() {
    return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: ctSearch,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textAlign: TextAlign.center,
          onChanged: (st) {
            controllerSatis.filterAnaQrup(st);
            setState(() {});
          },
          decoration: const InputDecoration(
            hintText: "Axtar...",
            contentPadding: EdgeInsets.all(0),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.redAccent)),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ));
  }

  Widget _body(BuildContext context) {
    return Obx(() => SizedBox(
          height: controllerSatis.listSifarisler.isNotEmpty ||
                  controllerSatis.evvelkiSatisVarligi.isTrue
              ? MediaQuery.of(context).size.height * 0.72
              : MediaQuery.of(context).size.height * 0.86,
          child: ListView(
            children: controllerSatis.filteredListAnaQruplar
                .map((element) => widgetAnaGroup(element))
                .toList(),
          ),
        ));
  }

  Widget _footer(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: controllerSatis.listSifarisler.isNotEmpty ||
              controllerSatis.evvelkiSatisVarligi.isTrue
          ? MediaQuery.of(context).size.height * 0.14
          : 0,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(-2, 0),
                  color: Colors.grey,
                  spreadRadius: 0.1,
                  blurRadius: 5)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        labeltext: "Total satis : ",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        labeltext:
                            "${prettify(controllerSatis.listAnaQruplar.fold(0.0, (sum, item) => sum + item.totalSatis!))} ₼",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      CustomText(
                        labeltext: "Total endirim : ",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        labeltext:
                            "${prettify(controllerSatis.listAnaQruplar.fold(0.0, (sum, item) => sum + item.totalEndirim!))} ₼",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      CustomText(
                        labeltext: "Satis brut : ",
                        fontsize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      CustomText(
                        labeltext:
                            "${prettify(controllerSatis.listAnaQruplar.fold(0.0, (sum, item) => sum + item.totalSatis!) - controllerSatis.listAnaQruplar.fold(0.0, (sum, item) => sum + item.totalEndirim!))} ₼",
                        fontsize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ],
              ),
              CustomElevetedButton(
                  width: 120,
                  elevation: 5,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  surfaceColor: Colors.blue,
                  textsize: 20,
                  icon: Icons.verified_user_outlined,
                  hasshadow: true,
                  cllback: () {
                    Get.dialog(ShowSualDialog(
                        messaje: "Sifarisi tesdiqlediyinize eminsiniz?",
                        callBack: (va) async {
                          if (va) {
                            Get.back();
                            await controllerSatis.addSifarislerToDatabase(widget.modelCari.code!);
                          }
                        }));
                  },
                  label: "Sifarisi Tesdiqle")
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetAnaGroup(ModelAnaQrupAnbar element) {
    return InkWell(
      onTap: () async {
        mustSearch = false;
        ctSearch.text = "";
        controllerSatis.modelGirisEdilmisCari = widget.modelCari;
        controllerSatis.changeSelectedQroupProducts(element);
        bool result = await Get.toNamed(RouteHelper.getScreenSifarisElaveEt(),
            arguments: controllerSatis);
        if (result) {
          controllerSatis.fillListAnaQruplar();
          setState(() {});
        }
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    labeltext: element.groupAdi!,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                      height: 1, color: Colors.black, indent: 0, endIndent: 5),
                  const SizedBox(
                    height: 5,
                  ),
                  element.totalSatis != 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              labeltext: element.sifarisCesid.toString() +
                                  " cesid secildi",
                              fontWeight: FontWeight.normal,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.blue,
                                            offset: Offset(0, 0),
                                            blurRadius: 5,
                                            spreadRadius: 0.1,
                                            blurStyle: BlurStyle.outer)
                                      ],
                                      border: Border.all(
                                          color: Colors.blue, width: 1.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 70,
                                  width: 100,
                                  child: Column(
                                    children: [
                                      CustomText(
                                        labeltext: "Net satis",
                                        fontWeight: FontWeight.w800,
                                      ),
                                      CustomText(
                                          color: Colors.blue,
                                          labeltext:
                                              prettify(element.totalSatis!),
                                          fontWeight: FontWeight.normal,
                                          fontsize: 18),
                                      CustomText(
                                          color: Colors.blue,
                                          labeltext: "Azn",
                                          fontWeight: FontWeight.normal,
                                          fontsize: 12),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.deepPurple,
                                            offset: Offset(0, 0),
                                            blurRadius: 5,
                                            spreadRadius: 0.1,
                                            blurStyle: BlurStyle.outer)
                                      ],
                                      border: Border.all(
                                          color: Colors.deepPurple, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 70,
                                  width: 100,
                                  child: Column(
                                    children: [
                                      CustomText(
                                        labeltext: "Endirim",
                                        fontWeight: FontWeight.w800,
                                      ),
                                      CustomText(
                                        labeltext:
                                            prettify(element.totalEndirim!),
                                        fontWeight: FontWeight.normal,
                                        fontsize: 18,
                                        color: Colors.deepPurple,
                                      ),
                                      CustomText(
                                        labeltext: "Azn",
                                        fontWeight: FontWeight.normal,
                                        fontsize: 12,
                                        color: Colors.deepPurple,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.green,
                                            offset: Offset(0, 0),
                                            blurRadius: 5,
                                            spreadRadius: 0.1,
                                            blurStyle: BlurStyle.outer)
                                      ],
                                      border: Border.all(
                                          color: Colors.green, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 70,
                                  width: 100,
                                  child: Column(
                                    children: [
                                      CustomText(
                                        labeltext: "Brut Satis",
                                        fontWeight: FontWeight.w800,
                                      ),
                                      CustomText(
                                        labeltext: prettify(
                                            (element.totalSatis! -
                                                element.totalEndirim!)),
                                        fontWeight: FontWeight.normal,
                                        fontsize: 18,
                                        color: Colors.green,
                                      ),
                                      CustomText(
                                        labeltext: "Azn",
                                        fontWeight: FontWeight.normal,
                                        fontsize: 12,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                    labeltext:
                                        "Cesid Sayi :${element.cesidSayi}"),
                              ],
                            )
                          ],
                        ),
                ],
              ),
              element.totalSatis != 0
                  ? Positioned(
                      top: 0,
                      right: 5,
                      child: InkWell(
                        onTap: () {
                          _deleteAllSifarisBayAnaQrup(element);
                        },
                        child: const Icon(
                          Icons.layers_clear_outlined,
                          color: Colors.red,
                        ),
                      ))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAllSifarisBayAnaQrup(ModelAnaQrupAnbar element) {
    Get.dialog(ShowSualDialog(
        messaje: "${element.groupAdi} aid butun sifarisleri silmeye eminsiniz?",
        callBack: (va) {
          controllerSatis.deleteAllSifarisBayAnaQrup(element);
          Get.back();
          setState(() {
            controllerSatis.fillListAnaQruplar();
          });
        }));
  }

  String prettify(double d) {
    return d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  void _cixisAlqoritmasiniQur() {
    if (controllerSatis.evvelkiSifarisinHecmi == controllerSatis.listSifarisler.fold(0.0, (sum, element) => sum + element.netSatis!)) {
      mustSearch = false;
      Get.back();
      Get.back(result: []);
      Get.delete<ControllerSatis>();
    } else {
      Get.dialog(ShowSualDialog(
          messaje: "Sifaris tesdiqlemeden geri qayitsaniz  deyisiklik nezere alinmayacaq.Geri qayitmaga eminsiniz?", callBack: (va){
        if(va){
          mustSearch = false;
          Get.back();
          Get.back(result: "OK");
          Get.delete<ControllerSatis>();
        }
      }));

    }

  }
}
