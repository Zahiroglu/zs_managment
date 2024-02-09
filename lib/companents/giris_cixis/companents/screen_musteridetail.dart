import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/umumi_widgetler/cari_hesabat/marketuzre_hesabatlar.dart';
import 'package:zs_managment/companents/umumi_widgetler/cari_hesabat/model_cari_hesabatlar.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:url_launcher/url_launcher.dart';
import 'package:zs_managment/companents/umumi_widgetler/cari_hesabat/widgetHesabatListItems.dart';

import '../../../widgets/simple_info_dialog.dart';

class ScreenMusteriDetail extends StatefulWidget {
  ModelCariler modelCariler;
  AvailableMap availableMap;


  ScreenMusteriDetail({required this.modelCariler,required this.availableMap, super.key});

  @override
  State<ScreenMusteriDetail> createState() => _ScreenMusteriDetailState();
}

class _ScreenMusteriDetailState extends State<ScreenMusteriDetail> {
  Set<map.Marker> markers = <map.Marker>{};
  bool backClicked = false;
  ModelCariHesabatlar modelCariHesabatlar=ModelCariHesabatlar();

  @override
  void initState() {
    addMarker();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(width: MediaQuery
                .of(context)
                .size
                .width, height: MediaQuery
                .of(context)
                .size
                .height,),
            Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(2, 0))
              ]),
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: myGoogleMap(),
            ),
            const SizedBox(
              height: 10,
            ),
            Positioned(
                top: (MediaQuery
                    .of(context)
                    .size
                    .height / 3) - 50,
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xaabbbbbb),
                          Color(0xFFFFFFFF),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.decal,
                      )
                  ),
                  height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.shopping_cart),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Expanded(
                          child: CustomText(
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            labeltext: widget.modelCariler.name!,
                            color: Colors.black, fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 100,
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                    icon: backClicked
                        ? Icon(Icons.arrow_downward)
                        : Icon(Icons.arrow_upward),
                    onPressed: () {
                      setState(() {
                        backClicked = true;
                      });
                      Get.back();
                    }),
              ),
            ),
            widget.modelCariler.mesafe!="s"?Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.directions, color: Colors.blue),
                      CustomText(labeltext: widget.modelCariler.mesafe??"0"),
                    ],
                  ),
                )):SizedBox(),
            Positioned(
                top: (MediaQuery
                    .of(context)
                    .size
                    .height / 3) - 75,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                          'images/moneyback.png', width: 25, height: 25),
                      SizedBox(width: 5,),
                      CustomText(labeltext: widget.modelCariler.debt.toString()! + " ₼",
                          fontsize: 16),
                    ],
                  ),
                )),
            Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height / 3.1,
              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height - MediaQuery
                    .of(context)
                    .size
                    .height / 3 ,
                color: Colors.white12,
                child: widgetDigerMelumatlar(),
              ),

            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: CustomElevetedButton(
                textsize: 16,
                hasshadow: true,
                height: 35,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 50,
                cllback: () {
                  createRoutBetweenTwoPoints(widget.modelCariler);
                },
                label: widget.availableMap.mapName,
                surfaceColor: Colors.white,
                borderColor: Colors.green,
                elevation: 10,
                isSvcFile: true,
                svcFile: widget.availableMap.icon,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget myGoogleMap() {
    return map.GoogleMap(
      scrollGesturesEnabled: false,
      markers: markers,
      onCameraMove: (possition) {},
      padding: const EdgeInsets.all(2),
      mapToolbarEnabled: false,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapType: map.MapType.normal,
      minMaxZoomPreference: const map.MinMaxZoomPreference(10, 19),
      onCameraIdle: () {},
      initialCameraPosition: map.CameraPosition(
          target: map.LatLng(
              double.parse(widget.modelCariler.longitude.toString()),
              double.parse(widget.modelCariler.latitude.toString())),
          zoom: 21),
      onMapCreated: (map.GoogleMapController controller) async {},
    );
  }

  void addMarker() {
    markers.add(map.Marker(
        markerId: const map.MarkerId("Men"),
        icon: map.BitmapDescriptor.defaultMarker,
        position: map.LatLng(
            double.parse(widget.modelCariler.longitude.toString()),
            double.parse(widget.modelCariler.latitude.toString()))));
  }

  Future<void> createRoutBetweenTwoPoints(ModelCariler modelCariler) async {
    Coords cordEnd = Coords(double.parse(modelCariler.longitude.toString()),
        double.parse(modelCariler.latitude.toString()));
    try {
      await MapLauncher.showMarker(mapType: widget.availableMap.mapType,
          coords: cordEnd,
          title: modelCariler.name!);
    } catch (exp) {
      Get.dialog(ShowInfoDialog(
        messaje: "Secmis oldugunuz ${widget.availableMap
            .mapName} hal hazirda cavab vermir.Basqa programla evez edin!",
        icon: Icons.info_outlined,
        callback: (va) {
          if (va) {
            openMapSettingScreen();
          }
        },
      ));
    }
  }

  Future<void> openMapSettingScreen() async {
    widget.availableMap = await Get.toNamed(RouteHelper.mobileMapSettingMobile);
    setState(() {});
  }

  Widget widgetDigerMelumatlar() {
    return ListView(
      padding: const EdgeInsets.all(0).copyWith(top: 5),
      children: [
        SizedBox(
            height: 125,
            child: widgetMusteriHesabatlari()),
        ///sexsi bilgileri
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(labeltext: "Sexsi melumatlar",
              fontWeight: FontWeight.bold,
              fontsize: 16,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12)
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          labeltext: "${"Mesul sexs".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: CustomText(
                            overflow: TextOverflow.ellipsis,
                            maxline: 1,
                            labeltext: "${widget.modelCariler.ownerPerson}",
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
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
                          labeltext: "${"Telefon".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        InkWell(
                          onTap: () {
                            _makePhoneCall(
                                "tel:${widget.modelCariler.phone}");
                          },
                          child: CustomText(
                            overflow: TextOverflow.ellipsis,
                            maxline: 1,
                            labeltext: "${widget.modelCariler.phone}",
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.normal,
                          ),
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
                          labeltext: "${"Voun".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          labeltext: "${widget.modelCariler.tin}",
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
                          labeltext: "${"Ana Cari".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          labeltext: "${widget.modelCariler.mainCustomer}",
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10,),

        ///regional melumatlar
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(labeltext: "Regional melumatlar",
              fontWeight: FontWeight.bold,
              fontsize: 16,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12)
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          labeltext: "${"region".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          labeltext: "${widget.modelCariler.district}",
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
                          labeltext: "${"tamun".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: CustomText(
                            overflow: TextOverflow.ellipsis,
                            maxline: 2,
                            labeltext: "${widget.modelCariler.fullAddress}",
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10,),

        ///diget melumatlar
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(labeltext: "Diger melumatlar",
              fontWeight: FontWeight.bold,
              fontsize: 16,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12)
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          labeltext: "${"Rut gunu".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 5,),
                            Wrap(
                              children: [
                                widget.modelCariler.day1.toString() == "1"
                                    ? widgetRutGunuItems("gun1".tr)
                                    : const SizedBox(),
                                widget.modelCariler.day2.toString() == "1"
                                    ? widgetRutGunuItems("gun2".tr)
                                    : const SizedBox(),
                                widget.modelCariler.day3.toString() == "1"
                                    ? widgetRutGunuItems("gun3".tr)
                                    : const SizedBox(),
                                widget.modelCariler.day4.toString() == "1"
                                    ? widgetRutGunuItems("gun4".tr)
                                    : const SizedBox(),
                                widget.modelCariler.day5.toString() == "1"
                                    ? widgetRutGunuItems("gun5".tr)
                                    : const SizedBox(),
                                widget.modelCariler.day6.toString() == "1"
                                    ? widgetRutGunuItems("gun6".tr)
                                    : const SizedBox(),
                                widget.modelCariler.day7.toString() == "1"
                                    ? widgetRutGunuItems("bagli".tr)
                                    : const SizedBox(),
                              ],
                            ),
                          ],
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
                          labeltext: "Sahe".tr + " : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          labeltext: "${widget.modelCariler.area} kvm",
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
                          labeltext: "Katerina".tr + " : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          labeltext: "${widget.modelCariler.category}",
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
                          labeltext: "Sticker".tr + " : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          labeltext: "${widget.modelCariler.postalCode}",
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
                          labeltext: "Temsilci Kod".tr + " : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          labeltext: "${widget.modelCariler.forwarderCode}",
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 200,),

      ],
    );
  }

  Container widgetRutGunuItems(String s) =>
      Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: CustomText(labeltext: s, color: Colors.white, fontsize: 12),
      );

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

 Widget widgetMusteriHesabatlari() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(labeltext: "Hesabatlar",
          fontWeight: FontWeight.bold,
          fontsize: 16,),
        WidgetCarihesabatlar(height: 100,cad: widget.modelCariler.name!,ckod: widget.modelCariler.code!),
      ],
    );


  }

}