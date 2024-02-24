import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/dashbourd/models/model_rut_perform.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/hesabatlar/giriscixis_hesabat/companents/widget_listitemsgiriscixis.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScreenGunlukGirisCixis extends StatefulWidget {
  ModelRutPerform model;

  ScreenGunlukGirisCixis({required this.model, super.key});

  @override
  State<ScreenGunlukGirisCixis> createState() => _ScreenGunlukGirisCixisState();
}

class _ScreenGunlukGirisCixisState extends State<ScreenGunlukGirisCixis> {
  bool backClicked = false;
  List<String> listTab = [
    "Giris-Cixislar",
    "Gunluk Rut",
    "Ziyaret Edilmeyenler"
  ];
  String selectedTabItem = "Giris-Cixislar";
  ModelCariler expandedItem = ModelCariler();
  int umumiGirsilerSay = 0;
  int rutGunuSay = 0;
  int ziyaretEdilmeyenlerSay = 0;

  @override
  void initState() {
    // TODO: implement initState
    print("ModelRutPerform :" + widget.model.toString());
    umumiGirsilerSay = widget.model.listGirisCixislar!.length ?? 0;
    rutGunuSay = widget.model.listGunlukRut!.length ?? 0;
    ziyaretEdilmeyenlerSay = widget.model.listZiyaretEdilmeyen!.length ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgetHeader(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.black : Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex:2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widgetSimpleTextInfo("Cari musteri sayi : ",widget.model.snSayi.toString()),
                          widgetSimpleTextInfo("Rut cari sayi : ",widget.model.rutSayi.toString()),
                          widgetSimpleTextInfo("Duz ziyaret sayi : ",widget.model.duzgunZiya.toString()),
                          widgetSimpleTextInfo("Sef ziyaret sayi : ",widget.model.rutkenarZiya.toString()),
                          widgetSimpleTextInfo("Umumi ziyaret sayi : ",widget.model.listGirisCixislar!.length.toString()),
                          widgetSimpleTextInfo("Ziyaret edilmeyen sayi : ",widget.model.ziyaretEdilmeyen.toString()),
                          widgetSimpleTextInfo("Sn-lerde is vaxti : ",widget.model.snlerdeQalma.toString()),
                          widgetSimpleTextInfo("Umumi is vaxti : ",widget.model.umumiIsvaxti.toString()),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          chartWidget(),
                          CustomText(labeltext: "Ziyaret Diagrami", fontsize: 10),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: listTab
                        .map((element) => widgetListTabItems(element))
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                  child: listTab.first.toString() == selectedTabItem.toString()
                      ? listviewGirisCixislar()
                      : listViewCariler())
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetSimpleTextInfo(String lable,String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 150,
            child: CustomText(labeltext: lable,fontWeight: FontWeight.w600)),
        Expanded(child: CustomText(labeltext: value)),
      ],
    );
  }

  Widget chartWidget() {
    final List<ChartData> chartData = [
      ChartData("Rut gunu", widget.model.rutSayi! - widget.model.duzgunZiya!,
          Colors.red),
      ChartData('Ziyaret', widget.model.duzgunZiya!, Colors.green),
    ];
    return SimpleChart(
      listCharts: chartData,
      height: 130,
      width: 150,
    );
  }

  ListView listviewGirisCixislar() {
    return ListView(
      children: widget.model.listGirisCixislar!
          .map((e) => WigetListItemsGirisCixis(model: e,))
          .toList(),
    );
  }

  ListView listViewCariler() {
    return ListView(
      children: selectedTabItem.toString() == listTab.last.toString()
          ? widget.model.listZiyaretEdilmeyen!
              .map((e) => widgetCustomers(e))
              .toList()
          : widget.model.listGunlukRut!.map((e) => widgetCustomers(e)).toList(),
    );
  }

  Widget widgetCustomers(ModelCariler e) {
    return InkWell(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 10,
        shadowColor: Colors.blueAccent.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: CustomText(
                        labeltext: e.name!,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomText(
                        labeltext: e.code!,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontsize: 12,
                      ),
                      expandedItem.code != e.code
                          ? IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(
                                  maxHeight: 30, maxWidth: 30),
                              onPressed: () {
                                setState(() {
                                  expandedItem = e;
                                });
                              },
                              icon: const Icon(Icons.expand_more))
                          : IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(
                                  maxHeight: 30, maxWidth: 30),
                              onPressed: () {
                                setState(() {
                                  expandedItem = ModelCariler();
                                });
                              },
                              icon: Icon(Icons.expand_less))
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(3.0),
                child: Divider(height: 1, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage("images/externalvisit.png"),
                    color: checkIfVisited(e.code!).$2 == 0
                        ? Colors.red
                        : Colors.green,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CustomText(
                      fontsize: 12,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      labeltext: checkIfVisited(e.code!).$1,
                      color: checkIfVisited(e.code!).$2 == 0
                          ? Colors.black
                          : Colors.green,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              expandedItem.code == e.code
                  ? widgetMoreDataForItems(e)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  widgetMoreDataForItems(ModelCariler e) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Divider(
            height: 2,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Rut Gunu",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                width: 5,
              ),
              const SizedBox(
                width: 5,
              ),
              Wrap(
                children: [
                  e.days!.any((a) => a.day==1)
                      ? widgetRutGunuItems("gun1".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==2)
                      ? widgetRutGunuItems("gun2".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==3)
                      ? widgetRutGunuItems("gun3".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==4)
                      ? widgetRutGunuItems("gun4".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==5)
                      ? widgetRutGunuItems("gun5".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==6)
                      ? widgetRutGunuItems("gun6".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day==7)
                      ? widgetRutGunuItems("bagli".tr)
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                labeltext: "Tam Unvan",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: ScreenUtil.defaultSize.width / 1.7,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxline: 1,
                  labeltext: "${e.fullAddress}",
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Rayon",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.district}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Sahe",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.area}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Kateqoriya",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.category}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Telefon",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.phone}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Voun",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.tin}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container widgetRutGunuItems(String s) => Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: CustomText(labeltext: s, color: Colors.white, fontsize: 12),
      );

  Widget widgetListGirisItems(ModelGirisCixis model) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: model.rutgunu == "Sef" ? Colors.red : Colors.green,
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomText(
                      labeltext: model.cariad!,
                      fontsize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      overflow: TextOverflow.ellipsis,
                      maxline: 2,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.blue,
                    ),
                    CustomText(labeltext: "Giris vaxti :"),
                    SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.girisvaxt!.substring(11, 19)),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.red,
                    ),
                    CustomText(labeltext: "Cixis vaxti :"),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.cixisvaxt!.substring(11, 19)),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: "Vaxt :"),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(
                        labeltext: carculateTimeDistace(
                            model.girisvaxt!, model.cixisvaxt!)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                        labeltext: "${model.girisvaxt!.substring(0, 11)}"),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: model.rutgunu == "Sef" ? Colors.red : Colors.green,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                labeltext: model.rutgunu == "Sef" ? "Rutdan kenar" : "Rut gunu",
                color: model.rutgunu == "Sef" ? Colors.red : Colors.green,
              ),
            ))
      ],
    );
  }

  Padding widgetHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 30,
            child: IconButton(
                icon: backClicked
                    ? const Icon(Icons.arrow_forward)
                    : const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    backClicked = true;
                    Get.back();
                  });
                }),
          ),
          const Spacer(),
          SizedBox(
              child: CustomText(
            labeltext: "Giris Cixislar".tr,
            fontsize: 18,
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(
            width: 5,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  String carculateTimeDistace(String? girisvaxt, String? cixisvaxt) {
    Duration difference =
        DateTime.parse(cixisvaxt!).difference(DateTime.parse(girisvaxt!));
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  Widget widgetListTabItems(String element) {
    String deyer = listTab.first.toString() == element.toString()
        ? umumiGirsilerSay.toString()
        : listTab.last.toString() == element.toString()
            ? ziyaretEdilmeyenlerSay.toString()
            : rutGunuSay.toString();
    return InkWell(
      onTap: () {
        setState(() {
          selectedTabItem = element;
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: selectedTabItem != element.toString()
                    ? Border.all(color: Colors.grey, width: 0.5)
                    : Border.all(color: Colors.blue, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            height: selectedTabItem == element.toString() ? 40 : 30,
            child: CustomText(
                fontsize: selectedTabItem == element.toString() ? 16 : 14,
                labeltext: element.tr,
                fontWeight: selectedTabItem == element.toString()
                    ? FontWeight.w700
                    : FontWeight.normal),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 0.1)),
                child: CustomText(
                  color: Colors.white,
                  fontsize: 8,
                  labeltext: deyer,
                ),
              ))
        ],
      ),
    );
  }

  (String, int) checkIfVisited(String s) {
    if (widget.model.listGirisCixislar!
        .where((element) => element.ckod == s)
        .isNotEmpty) {
      return ("Bu gun ziyaret edilib", 1);
    } else {
      return ("Ziyaret Edilmeyib", 0);
    }
  }
}
