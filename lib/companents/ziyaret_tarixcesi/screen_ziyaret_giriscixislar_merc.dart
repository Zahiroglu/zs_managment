import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/mercendaizer/model_mercbaza.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_gunluk_giriscixis.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

class ScreenZiyaretGirisCixis extends StatefulWidget {
  ModelGunlukGirisCixis modelGunlukGirisCixis;
  String adSoyad;
  List<ModelMercBaza> modelCariler;

  ScreenZiyaretGirisCixis(
      {required this.modelGunlukGirisCixis,
      required this.adSoyad,
      required this.modelCariler,
      super.key});

  @override
  State<ScreenZiyaretGirisCixis> createState() =>
      _ScreenZiyaretGirisCixisState();
}

class _ScreenZiyaretGirisCixisState extends State<ScreenZiyaretGirisCixis> {
  String currentDay = "";
  List<ModelMercBaza> listCustomersByDay = [];
  List<ModelMercBaza> listZiyaretEdilmeyen = [];
  int ziyaretEdilmeyenMarketsayi = 0;
  var _scrollControllerNested;
  late PageController _controllerInfo;
  int _initialIndex = 0;
  String hefteninGunu = "";

  @override
  void initState() {
    _scrollControllerNested = ScrollController();
    _controllerInfo =
        PageController(initialPage: _initialIndex, viewportFraction: 1);
    melumatlariGuneGoreDoldur();
    // TODO: implement initState
    super.initState();
  }

  void melumatlariGuneGoreDoldur() {
    DateTime dateTime = DateTime.parse(widget.modelGunlukGirisCixis.tarix);
    switch (dateTime.weekday) {
      case 1:
        hefteninGunu = "gun1";
        widget.modelCariler.where((element) => element.gun1.toString() == "1").toList().forEach((element) {
          element.ziyaretSayi = widget.modelGunlukGirisCixis.listgiriscixis.where((e) => e.cariAd == element.cariad).length;
          element.sndeQalmaVaxti = curculateTimeDistanceForVisit(widget.modelGunlukGirisCixis.listgiriscixis.where((e) => e.cariAd == element.cariad).toList());
          if(listCustomersByDay.where((e) =>e.cariad==element.cariad ).isEmpty){
          listCustomersByDay.add(element);}
        });
        break;
      case 2:
        hefteninGunu = "gun2";
        widget.modelCariler
            .where((element) => element.gun2.toString() == "1")
            .toList()
            .forEach((element) {
          element.ziyaretSayi = widget.modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .length;
          element.sndeQalmaVaxti = curculateTimeDistanceForVisit(widget
              .modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .toList());
          if(listCustomersByDay.where((e) =>e.cariad==element.cariad ).isEmpty){
            listCustomersByDay.add(element);}     });
        break;
      case 3:
        hefteninGunu = "gun3";
        widget.modelCariler
            .where((element) => element.gun3.toString() == "1")
            .toList()
            .forEach((element) {
          element.ziyaretSayi = widget.modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .length;
          element.sndeQalmaVaxti = curculateTimeDistanceForVisit(widget
              .modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .toList());
          if(listCustomersByDay.where((e) =>e.cariad==element.cariad ).isEmpty){
            listCustomersByDay.add(element);}       });
        break;
      case 4:
        hefteninGunu = "gun4";
        widget.modelCariler
            .where((element) => element.gun4.toString() == "1")
            .toList()
            .forEach((element) {
          element.ziyaretSayi = widget.modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .length;
          element.sndeQalmaVaxti = curculateTimeDistanceForVisit(widget
              .modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .toList());
          if(listCustomersByDay.where((e) =>e.cariad==element.cariad ).isEmpty){
            listCustomersByDay.add(element);}       });
        break;
      case 5:
        hefteninGunu = "gun5";
        widget.modelCariler
            .where((element) => element.gun5.toString() == "1")
            .toList()
            .forEach((element) {
          element.ziyaretSayi = widget.modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .length;
          element.sndeQalmaVaxti = curculateTimeDistanceForVisit(widget
              .modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .toList());
          if(listCustomersByDay.where((e) =>e.cariad==element.cariad ).isEmpty){
            listCustomersByDay.add(element);}       });
        break;
      case 6:
        hefteninGunu = "gun6";
        widget.modelCariler
            .where((element) => element.gun6.toString() == "1")
            .toList()
            .forEach((element) {
          element.ziyaretSayi = widget.modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .length;
          element.sndeQalmaVaxti = curculateTimeDistanceForVisit(widget
              .modelGunlukGirisCixis.listgiriscixis
              .where((e) => e.cariAd == element.cariad)
              .toList());
          if(listCustomersByDay.where((e) =>e.cariad==element.cariad ).isEmpty){
            listCustomersByDay.add(element);}      });
        break;
    }
    for (var element in listCustomersByDay) {
      if (widget.modelGunlukGirisCixis.listgiriscixis
          .where((a) => a.cariAd == element.cariad)
          .isEmpty) {
        listZiyaretEdilmeyen.add(element);
        ziyaretEdilmeyenMarketsayi = ziyaretEdilmeyenMarketsayi + 1;
      }
    }

    setState(() {});
  }

  String curculateTimeDistanceForVisit(List<ModelGirisCixis> list) {
    int hours = 0;
    int minutes = 0;
    Duration difference = Duration();
    for (var element in list) {
      difference = difference +
          DateTime.parse(element.cixisTarix)
              .difference(DateTime.parse(element.girisTarix));
    }
    hours = hours + difference.inHours % 24;
    minutes = minutes + difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            controller: _scrollControllerNested,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverSafeArea(
                  sliver: SliverAppBar(
                    elevation: 10,
                    backgroundColor: Colors.white,
                    centerTitle: false,
                    expandedHeight: 320,
                    pinned: true,
                    floating: false,
                    stretch: true,
                    title: CustomText(labeltext: widget.adSoyad),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.blurBackground],
                      background:
                          infoZiyaretTarixcesi(widget.modelGunlukGirisCixis),
                      collapseMode: CollapseMode.values[0],
                      centerTitle: true,
                    ),
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: ColoredBox(
                          color: Colors.grey.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0).copyWith(top: 5, bottom: 5),
                            child: Column(
                              children: [
                                widgetTabItems(context),
                              ],
                            ),
                          ),
                        )),
                  ),
                )
              ];
            },
            body: pagetViewInfo(),
          ),
        ),
      ),
    );
  }

  Row widgetTabItems(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        CustomElevetedButton(
          surfaceColor: _initialIndex == 0 ? Colors.green: Colors.white,
          height: 35,
          elevation: _initialIndex == 0?5:0,
          width: MediaQuery.of(context).size.width * 0.4,
          cllback: () {
            _onPageViewChangeInfo(0);
          },
          label:
              "${"giriscixis".tr} ( ${widget.modelGunlukGirisCixis.listgiriscixis.length} )",
        ),
        const Spacer(),
        CustomElevetedButton(
          surfaceColor: _initialIndex == 1 ? Colors.green : Colors.white,
          height: 35,
          width: MediaQuery.of(context).size.width * 0.4,
          cllback: () {
            _onPageViewChangeInfo(1);
          },
          label:
              "${"cariRut".tr} ( ${listCustomersByDay.length.toString()} )",
        ),
        const Spacer(),
      ],
    );
  }

  Widget infoZiyaretTarixcesi(ModelGunlukGirisCixis model) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(top: 50, bottom: 60),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 1),
                          spreadRadius: 0.1,
                          blurRadius: 2)
                    ],
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        labeltext: model.tarix,
                        fontsize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          CustomText(
                              labeltext: "ziyaretSayi".tr + " : ",
                              fontWeight: FontWeight.w600),
                          CustomText(labeltext: model.girisSayi.toString(),fontWeight: FontWeight.bold,fontsize: 16),
                          const SizedBox(width: 15,),
                          Container(
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.all(2),
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue,
                            ),
                            child: CustomText(labeltext: "${"right".tr} - ${(listCustomersByDay.length-listCustomersByDay
                                .where((element) => element.ziyaretSayi! ==0).toList().length)}",color: Colors.white,fontWeight: FontWeight.bold,),
                          ),
                          const SizedBox(width: 5,),
                          Container(
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.all(2),
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red,
                            ),
                            child: CustomText(labeltext: "${"wrong".tr} - ${listCustomersByDay
                                .where((element) => element.ziyaretSayi! ==0).toList().length}",color: Colors.white,fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                              labeltext: "isBaslama".tr + " : ",
                              fontWeight: FontWeight.w600),
                          CustomText(
                              labeltext: model.iseBaslamaSaati.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                              labeltext: "isbitme".tr + " : ",
                              fontWeight: FontWeight.w600),
                          CustomText(
                              labeltext: model.isiQutarmaSaati.toString()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blue, width: 0.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CustomText(
                                      labeltext:
                                          "marketlerdeISvaxti".tr + " : ",
                                    ),
                                    CustomText(labeltext: model.sndeIsvaxti),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      labeltext: "erazideIsVaxti".tr+" : ",
                                    ),
                                    CustomText(
                                      labeltext: model.umumiIsVaxti,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    maxline: 2,
                                    labeltext: "rutZiyaretEdilmeyen".tr + " : ",
                                    color: Colors.white,
                                  ),
                                ),
                                CustomText(
                                  labeltext:
                                      ziyaretEdilmeyenMarketsayi.toString(),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 58,
                  right: 25,
                  child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 0.2),
                ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CustomText(labeltext: hefteninGunu),
                    ),
              ))
            ],
          ),
        )
      ],
    );
  }

  Widget pagetViewInfo() {
    return PageView(
      onPageChanged: _onPageViewChangeInfo,
      controller: _controllerInfo,
      children: [_widgetListGirisler(), _widgetListCariler()],
    );
  }

  void _onPageViewChangeInfo(int value) {
    setState(() {
      _controllerInfo.animateToPage(value, duration: const Duration(milliseconds: 100), curve: Curves.bounceOut);
      _initialIndex = value;
    });
  }

  Widget _widgetListGirisler() {
    return ListView.builder(
        itemCount: widget.modelGunlukGirisCixis.listgiriscixis.length,
        itemBuilder: (c, index) {
          return widgetListGirisItems(
              widget.modelGunlukGirisCixis.listgiriscixis.elementAt(index));
        });
  }

  Widget widgetListGirisItems(ModelGirisCixis model) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: model.rutUygunluq == "Sef" ? Colors.red : Colors.green,
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
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
                      labeltext: model.cariAd,
                      fontsize: 16,
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
                    CustomText(labeltext: "girisVaxt".tr+" : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.girisTarix.substring(11, 19)),
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
                    CustomText(labeltext: "cixisVaxt".tr+" : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.cixisTarix.substring(11, 19)),
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
                    CustomText(labeltext: "time".tr+" : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(
                        labeltext: carculateTimeDistace(
                            model.girisTarix, model.cixisTarix)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex:8,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomText(
                          maxline: 3,
                            fontsize: 12,
                            labeltext:"qeyd".tr+" : "+ model.ziyaretQeyd),
                      ),
                    ),
                    Expanded(
                      flex:2,
                      child: CustomText(
                          labeltext: "${model.girisTarix.substring(0, 10)}"),
                    ),
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
                      color: model.rutUygunluq == "Sef"
                          ? Colors.red
                          : Colors.green,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                fontsize: 12,
                labeltext: listCustomersByDay
                        .where((element) => element.cariad == model.cariAd)
                        .isEmpty
                    ? "wrong".tr
                    : "right".tr,
                color: listCustomersByDay
                        .where((element) => element.cariad == model.cariAd)
                        .isEmpty
                    ? Colors.red
                    : Colors.green,
              ),
            ))
      ],
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

  ///cari melumatlar
  Widget _widgetListCariler() {
    return ListView.builder(
        itemCount: listCustomersByDay.length,
        itemBuilder: (c, index) {
          return itemsCustomers(listCustomersByDay.elementAt(index));
        });
  }

  Widget itemsCustomers(ModelMercBaza element) {
    return Card(
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color:element.ziyaretSayi==0?Colors.red:Colors.green),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0).copyWith(left: 10, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      labeltext: element.cariad!,
                      fontWeight: FontWeight.w600,
                      maxline: 3,
                      fontsize: 16),
                  const SizedBox(
                    height: 2,
                  ),
                   _infoMarketMotivasion(element),
                  const SizedBox(
                    height: 5,
                  ),
                  _infoMarketRout(element)
                ],
              ),
            ),
            Positioned(
                top: 5,
                left: 5,
                child: Center(
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: element.ziyaretSayi==0
                            ? Colors.red
                            : Colors.green),
                    child: element.rutSirasi.toString() == "null"
                        ? SizedBox()
                        : Center(
                            child: CustomText(
                                labeltext: element.rutSirasi.toString())),
                  ),
                )),
            Positioned(
                top: 5,
                right: 8,
                child: Center(
                    child: CustomText(
                  labeltext: element.carikod.toString(),
                  fontsize: 10,
                  fontWeight: FontWeight.w700,
                )))
          ],
        ),
      ),
    );
  }

  Widget _infoMarketRout(ModelMercBaza element) {
    int valuMore = 0;
    if (element.gun1.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun2.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun3.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun4.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun5.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun6.toString() == "1") {
      valuMore = valuMore + 1;
    }
    return SizedBox(
      height: valuMore > 4 ? 60 : 28,
      width: 250,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          element.gun1.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun1".tr)
              : const SizedBox(),
          element.gun2.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun2".tr)
              : const SizedBox(),
          element.gun3.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun3".tr)
              : const SizedBox(),
          element.gun4.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun4".tr)
              : const SizedBox(),
          element.gun5.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun5".tr)
              : const SizedBox(),
          element.gun6.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun6".tr)
              : const SizedBox(),
          element.gun7.toString() == "1"
              ? WidgetRutGunu(rutGunu: "bagli".tr)
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _infoMarketMotivasion(ModelMercBaza element) {
    return DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"temKod".tr} : ", fontsize: 12),
                              CustomText(
                                  labeltext: element.expeditor!, fontsize: 12),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"Ziyaret sayi".tr} : ",
                                  fontsize: 12),
                              CustomText(
                                  labeltext: element.ziyaretSayi.toString(),
                                  fontsize: 12),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"Vaxt".tr} : ", fontsize: 12),
                              CustomText(
                                  labeltext: element.sndeQalmaVaxti!,
                                  fontsize: 12),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

}
