import 'dart:async';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:map_picker/map_picker.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/connected_users/controller_rout_detail_user.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';

import '../controller_exppref.dart';

class EditMusteriDetailScreen extends StatefulWidget {
  ControllerExpPref controllerRoutDetailUser;
  String routname;
  ModelCariler cariModel;

  EditMusteriDetailScreen(
      {required this.controllerRoutDetailUser,
      required this.routname,
      required this.cariModel,
      super.key});

  @override
  State<EditMusteriDetailScreen> createState() =>
      _EditMusteriDetailScreenState();
}

class _EditMusteriDetailScreenState extends State<EditMusteriDetailScreen> {
  Set<Marker> markers = <Marker>{};
  MapPickerController mapPickerController = MapPickerController();
  final _controller = Completer<GoogleMapController>();
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 17,
  );
  bool mapEditClicked = false;
  TextEditingController ctSearcha = TextEditingController();
  TextEditingController ctSahe = TextEditingController();
  TextEditingController ctKateq = TextEditingController();
  TextEditingController ctReion = TextEditingController();
  GoogleMapController? newgooglemapxontroller;
  bool gun1Selected = false;
  ModelCariler cariModel = ModelCariler();
  bool marketBaglidir = false;
  bool rutGunuBir = false;
  bool rutGunuIki = false;
  bool rutGunuUc = false;
  bool rutGunuDort = false;
  bool rutGunuBes = false;
  bool rutGunuAlti = false;
  bool melumatlariDeyisGorunsun = true;

  @override
  void initState() {
    cariModel = widget.cariModel;
    marketBaglidir = cariModel.days!.any((element) => element.day==7);
    rutGunuBir = cariModel.days!.any((element) => element.day==1);
    rutGunuIki = cariModel.days!.any((element) => element.day==2);
    rutGunuUc = cariModel.days!.any((element) => element.day==3);
    rutGunuDort = cariModel.days!.any((element) => element.day==4);
    rutGunuBes = cariModel.days!.any((element) => element.day==5);
    rutGunuAlti = cariModel.days!.any((element) => element.day==6);
    ctSahe.text = cariModel.area!;
    ctKateq.text=cariModel.category!;
    ctReion.text=cariModel.district!;
    cameraPosition = CameraPosition(
      target: LatLng(double.parse(cariModel.longitude!.toString()),
          double.parse(cariModel.latitude.toString())),
      zoom: 14.4746,
    );
    addMarker();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          mapEditClicked
              ? myGoogleMapEditible()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: myGoogleMap()),
                    Expanded(flex: 5, child: infoMusteri(context))
                  ],
                ),
          melumatlariDeyisGorunsun? Positioned(
              top: 30,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    Get.back();
                  });
                },
              )):SizedBox(),
          melumatlariDeyisGorunsun?Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0)
                  .copyWith(top: 30, left: MediaQuery.of(context).size.width*0.72, right: 10),
              child: CustomElevetedButton(
                  fontWeight: FontWeight.bold,
                  textsize: 18,
                  textColor: Colors.black.withOpacity(1),
                  icon: Icons.save,
                  height: 35,
                  elevation: 15,
                  borderColor: Colors.black.withOpacity(1),
                  width: MediaQuery.of(context).size.width,
                  surfaceColor: Colors.transparent,
                  label: "change".tr,
                  cllback: () {
                    _melumatlariDeyis();
                  }),
            ),
          ):SizedBox()
        ],
      ),
    );
  }

  void addMarker() {
    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId("Men"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(double.parse(cariModel.longitude.toString()),
            double.parse(cariModel.latitude.toString()))));
  }

  @override
  void dispose() {
    if (newgooglemapxontroller != null) {
      newgooglemapxontroller!.dispose();
    }
    ctSearcha.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Widget myGoogleMapEditible() {
    return Stack(
      children: [
        MapPicker(
          iconWidget: Image.asset(
            "images/locationpin.png",
            height: 60,
          ),
          mapPickerController: mapPickerController,
          child: GoogleMap(
            markers: markers,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newgooglemapxontroller = controller;
            },
            onCameraMoveStarted: () {
              mapPickerController.mapMoving!();
            },
            onCameraMove: (cameraPosition) {
              setState(() {
                this.cameraPosition = cameraPosition;
              });
            },
            onCameraIdle: () async {
              mapPickerController.mapFinishedMoving!();
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevetedButton(
                  borderColor: Colors.black,
                    height: 40,
                    elevation: 5,
                    textColor: Colors.black,
                    icon: Icons.arrow_back,
                    fontWeight: FontWeight.bold,
                    width: MediaQuery.of(context).size.width / 2.5,
                    cllback: () {
                      setState(() {
                        mapEditClicked = false;
                        melumatlariDeyisGorunsun=true;
                      });
                    },
                    label: "cix".tr),
                CustomElevetedButton(
                    height: 40,
                    elevation: 5,
                    borderColor: Colors.green,
                    textColor: Colors.green,
                    fontWeight: FontWeight.bold,
                    icon: Icons.change_circle,
                    width: MediaQuery.of(context).size.width / 2.5,
                    cllback: () {
                      Get.dialog(ShowSualDialog(
                          messaje: "kordinatDeyissual",
                          callBack: (va) {
                            if (va) {
                              setState(() {
                                Get.back();
                                melumatlariDeyisGorunsun=true;
                                mapEditClicked = false;
                                cariModel.longitude =
                                    cameraPosition.target.latitude;
                                cariModel.latitude =
                                    cameraPosition.target.longitude;
                                addMarker();
                              });
                            }
                          }));
                    },
                    label: "Deyis")
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CustomText(
                      labeltext:
                          "${cameraPosition.target.longitude.toString()},${cameraPosition.target.latitude.toString()}",
                      color: Colors.white,
                      fontsize: 8),
                )),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(5.0).copyWith(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [searchField()],
            ),
          ),
        )
      ],
    );
  }

  Widget myGoogleMap() {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          scrollGesturesEnabled: true,
          onCameraMove: (possition) {},
          padding: const EdgeInsets.all(2),
          mapToolbarEnabled: true,
          zoomGesturesEnabled: true,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapType: MapType.normal,
          onCameraIdle: () {},
          initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(cariModel.longitude.toString()),
                  double.parse(cariModel.latitude.toString())),
              zoom: 15),
          onMapCreated: (GoogleMapController controller) async {},
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0, left: 8),
            child: CustomText(
                labeltext: "Cordinates :" +
                    cariModel.latitude.toString() +
                    "," +
                    cariModel.longitude.toString(),
                fontsize: 8),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 5, right: 5),
            child: CustomElevetedButton(
              height: 30,
              icon: Icons.edit_location_sharp,
              textColor: Colors.green,
              label: "kordiDeyis".tr,
              borderColor: Colors.green,
              cllback: (){
                setState(() {
                  mapEditClicked = true;
                  melumatlariDeyisGorunsun=false;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Widget searchField() {
    return SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextField(
          controller: ctSearcha,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textAlign: TextAlign.center,
          onSubmitted: (s) {
            if (s.isNotEmpty) {
              if (s.contains(",")) {
                int deyer = s.indexOf(",");
                String latitude = s.substring(0, deyer);
                String longitude = s.substring(deyer + 1, s.length);
                setState(() {
                  newgooglemapxontroller!.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                    target: LatLng(double.parse(latitude.toString()),
                        double.parse(longitude.toString())),
                    zoom: 15,
                  )));
                });
              } else {
                Get.dialog(ShowInfoDialog(
                    messaje:
                        "Gps duzgun daxil edilmeyib.Duzgun 'Misal : 40.2152215,49.1515151'",
                    icon: Icons.error,
                    callback: () {}));
              }
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.5),
            hintText: "40.1521,49.51515",
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

  Widget infoMusteri(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
                labeltext: cariModel.name!,
                fontsize: 24,
                fontWeight: FontWeight.w700,
                maxline: 2),
          ),
          widgetRutGunleri(context),
          widgetDigerParms(context),
        ],
      ),
    );
  }

  Widget widgetRutGunleri(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0).copyWith(left: 5),
            child: CustomText(
                labeltext: "rutmelumat",
                fontsize: 16,
                fontWeight: FontWeight.w600),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(labeltext: "${"fealiyyet".tr} : "),
                          AnimatedToggleSwitch<bool>.dual(
                            current: marketBaglidir ? true : false,
                            first: true,
                            second: false,
                            dif: 50.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.5,
                            height: 30,
                            fittingMode:
                                FittingMode.preventHorizontalOverlapping,
                            boxShadow: [
                              BoxShadow(
                                color: marketBaglidir
                                    ? Colors.red
                                    : Colors.blueAccent,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1.5),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() {
                                marketBaglidir = val;
                              });
                              return Future.delayed(
                                  const Duration(milliseconds: 100));
                            },
                            colorBuilder: (b) =>
                                b ? Colors.transparent : Colors.transparent,
                            iconBuilder: (value) => value
                                ? Icon(Icons.closed_caption_disabled_outlined,
                                    color: Colors.redAccent.withOpacity(0.8))
                                : Icon(
                                    Icons.open_in_new_rounded,
                                    color: Colors.blue.withOpacity(0.8),
                                  ),
                            textBuilder: (value) => value
                                ? Center(
                                    child: CustomText(
                                    labeltext: 'bagli'.tr,
                                    fontsize: 16,
                                    fontWeight: FontWeight.w800,
                                  ))
                                : Center(
                                    child: CustomText(
                                    labeltext: "aciq".tr,
                                    fontsize: 16,
                                    fontWeight: FontWeight.w800,
                                  )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  marketBaglidir
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(0.0)
                              .copyWith(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      CustomText(labeltext: "gun1".tr),
                                      Checkbox(
                                          value: rutGunuBir ? true : false,
                                          onChanged: (value) {
                                            setState(() {
                                              rutGunuBir = value!;
                                              print("Cari Modl :" +
                                                  cariModel.toString());
                                            });
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "gun2".tr),
                                      Checkbox(
                                          value: rutGunuIki,
                                          onChanged: (v) {
                                            setState(() {
                                              rutGunuIki = v!;
                                            });
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "gun3".tr),
                                      Checkbox(
                                          value: rutGunuUc,
                                          onChanged: (v) {
                                            setState(() {
                                              rutGunuUc = v!;
                                            });
                                          }),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      CustomText(labeltext: "gun4".tr),
                                      Checkbox(
                                          value: rutGunuDort,
                                          onChanged: (v) {
                                            setState(() {
                                              rutGunuDort = v!;
                                            });
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "gun5".tr),
                                      Checkbox(
                                          value: rutGunuBes,
                                          onChanged: (v) {
                                            setState(() {
                                              rutGunuBes = v!;
                                            });
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "gun6".tr),
                                      Checkbox(
                                          value: rutGunuAlti,
                                          onChanged: (v) {
                                            setState(() {
                                              rutGunuAlti = v!;
                                            });
                                          }),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  widgetDigerParms(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0).copyWith(left: 5),
            child: CustomText(
                labeltext: "digerMelumat".tr,
                fontsize: 16,
                fontWeight: FontWeight.w600),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomTextField(
                        containerHeight: 35,
                        hasLabel: true,
                        hasBourder: true,
                        obscureText: false,
                        onTopVisible: () {
                          setState(() {
                          });
                        },
                        updizayn: false,
                        controller:ctReion,
                        inputType: TextInputType.number,
                        hindtext: 'region'.tr,
                        fontsize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomTextField(
                      containerHeight: 35,
                        hasLabel: true,
                        hasBourder: true,
                        obscureText: false,
                        onTopVisible: () {
                          setState(() {
                          });
                        },
                        updizayn: false,
                        controller:ctSahe,
                        inputType: TextInputType.number,
                        hindtext: 'sahe'.tr,
                        fontsize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomTextField(
                        containerHeight: 35,
                        hasLabel: true,
                        obscureText: false,
                        onTopVisible: () {
                          setState(() {
                          });
                        },
                        updizayn: true,
                        controller:ctKateq,
                        inputType: TextInputType.text,
                        hindtext: 'kateq'.tr,
                        fontsize: 18),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _melumatlariDeyis() {
    if(marketBaglidir){
      rutGunuBir=false;
      rutGunuIki=false;
      rutGunuUc=false;
      rutGunuDort=false;
      rutGunuBes=false;
      rutGunuAlti=false;
    }
    setState(() {
      // ModelCariler model=ModelCariler(
      //   debt: cariModel.debt,
      //     forwarderCode: cariModel.forwarderCode,
      //     fullAddress: cariModel.fullAddress,
      //     mainCustomer: cariModel.mainCustomer,
      //     mesafe: cariModel.mesafe,
      //     ownerPerson: cariModel.ownerPerson,
      //     phone: cariModel.phone,
      //     postalCode: cariModel.postalCode,
      //     regionalDirectorCode: cariModel.regionalDirectorCode,
      //     salesDirectorCode: cariModel.salesDirectorCode,
      //     tin: cariModel.tin,
      //     ziyaret: cariModel.ziyaret,
      //     day1: rutGunuBir?1:0,
      //     day2: rutGunuIki?1:0,
      //     day3: rutGunuUc?1:0,
      //     day4: rutGunuDort?1:0,
      //     day5: rutGunuBes?1:0,
      //     day6: rutGunuAlti?1:0,
      //     day7: marketBaglidir?1:0,
      //     code: cariModel.code!,
      //     name: cariModel.name!,
      //     action: cariModel.action!,
      //     area: ctSahe.text,
      //     category: ctKateq.text,
      //     latitude: cariModel.latitude,
      //     longitude: cariModel.longitude,
      //     district: ctReion.text
      // );
      //widget.controllerRoutDetailUser.changeCustomersInfo(model);
    });
  }
}
