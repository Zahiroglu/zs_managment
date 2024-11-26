import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/new_screns_wait/controller_cixis_reklam.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/user_permitions_helper.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenCixish extends StatefulWidget {
  const ScreenCixish({super.key});

  @override
  State<ScreenCixish> createState() => _ScreenCixishState();
}

class _ScreenCixishState extends State<ScreenCixish> {
  ControllerCixisReklam controllerGirisCixis = Get.put(ControllerCixisReklam());
  PageController pageController=PageController();
  late LocationSettings locationSettings;
  int defaultTargetPlatform=0;
  bool followMe = false;
  String selectedItemsLabel = "Gunluk Rut";
  ModelCariler selectedCariModel = ModelCariler();
  int marketeGirisIcazeMesafesi = 1;
  String secilenMarketdenUzaqliqString = "";
  String girisErrorQeyd = "";
  double secilenMarketdenUzaqliq = 0;
  bool secilenMusterininRutGunuDuzluyu = false;
  bool istifadeciRutdanKenarGirisEdebiler = true;
  bool marketeGirisIcazesi = false;
  bool marketeCixisIcazesi = false;
  ScrollController scrollController = ScrollController();
  bool positionStreamStarted = false;
  LocalUserServices userService = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  UserPermitionsHelper permitionsHelper=UserPermitionsHelper();


  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<ControllerCixisReklam>(builder: (controller) {
        return Scaffold(
            body:Obx(() =>  controller.dataLoading.isTrue?const Center(child: CircularProgressIndicator(color: Colors.green),):widgetCixisUcun(context,controller))
        );
      }),
    );

  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


  Widget widgetCixisUcun(BuildContext context, ControllerCixisReklam controllerGirisCixis) {
    return Obx(() => Column(
      children: [
        Card(
          shadowColor: Colors.blue,
          elevation: 20,
          margin: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0)
                    .copyWith(top: 10, bottom: 25, left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(
                              labeltext: controllerGirisCixis
                                  .modelgirisEdilmis.value.customerName??"",
                              fontWeight: FontWeight.w600,
                              fontsize: 18,
                              maxline: 2),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "girisTarixi".tr,
                                  fontWeight: FontWeight.w700,
                                  fontsize: 16),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                  labeltext: controllerGirisCixis
                                      .modelgirisEdilmis.value.inDate.toString()
                                      .substring(0, 10),
                                  fontWeight: FontWeight.normal,
                                  fontsize: 14),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "Giris saati :",
                                  fontWeight: FontWeight.w700,
                                  fontsize: 16),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                  labeltext: controllerGirisCixis
                                      .modelgirisEdilmis.value.inDate.toString()
                                      .substring(11, 19),
                                  fontWeight: FontWeight.normal,
                                  fontsize: 14),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"mesafe".tr} : ",
                                  fontWeight: FontWeight.w700,
                                  fontsize: 16),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                  labeltext: controllerGirisCixis
                                      .snDenGirisUzaqligi.value,
                                  fontWeight: FontWeight.normal,
                                  fontsize: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomElevetedButton(
                            height: 40,
                            cllback: () {
                              controllerGirisCixis.girisiSil();
                            },
                            label: "Giris Sil",
                            icon: Icons.delete,
                            textColor: Colors.red,
                            borderColor: Colors.red,
                            elevation: 5,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomElevetedButton(
                            height: 40,
                            cllback: () {
                              showCixisDialog();
                            },
                            label: "cixiset".tr,
                            icon: Icons.exit_to_app,
                            surfaceColor: Colors.blue,
                            borderColor: Colors.white,
                            textColor: Colors.white,
                            elevation: 5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5).copyWith(left: 15),
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15))),
                    height: 30,
                    child: Center(
                        child: CustomText(
                            labeltext: controllerGirisCixis.snQalmaVaxti
                                .toString())),
                  ))
            ],
          ),
        ), //cixis ucun olan hisse
        SizedBox(
          height: MediaQuery.of(context).size.height*0.6,
          child: SingleChildScrollView(
            child: Column(children: [
              Card(
                shadowColor: Colors.black,
                elevation: 5,
                margin: const EdgeInsets.all(10).copyWith(bottom: 5,top: 0),
                child: controllerGirisCixis.cardSifarisler(context),
              ), //satis ucun
              Card(
                shadowColor: Colors.black,
                elevation: 5,
                margin: const EdgeInsets.all(10).copyWith(bottom: 5),
                child: controllerGirisCixis.cardTapsiriqlar(context),
              ), //tapsiriqlar ucun olan hisse
              Card(
                shadowColor: Colors.black,
                elevation: 5,
                margin: const EdgeInsets.all(10).copyWith(bottom: 5),
                child: controllerGirisCixis.cardSekilElavesi(context),
              ), //sekil elave etmek ucun
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(15).copyWith(bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    controllerGirisCixis.widgetMusteriHesabatlari(selectedCariModel),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ), //hesabatlar hissesi
            ],),
          ),
        )
      ],
    ));
  }

  Future<void> showCixisDialog() async {
    DialogHelper.showLoading("mesafeHesablanir".tr);
    _determinePosition().then((value) =>
    {
      secilenMarketdenUzaqliq = controllerGirisCixis.calculateDistance(value.latitude, value.longitude, double.parse(controllerGirisCixis.modelgirisEdilmis.value.customerLatitude!), double.parse(controllerGirisCixis.modelgirisEdilmis.value.customerLongitude!)),
      if (secilenMarketdenUzaqliq > 1)
        {
          secilenMarketdenUzaqliqString =
          "${(secilenMarketdenUzaqliq).round()} km",
        }
      else
        {
          secilenMarketdenUzaqliqString =
          "${(secilenMarketdenUzaqliq * 1000).round()} m",
        },
      if (secilenMarketdenUzaqliq < marketeGirisIcazeMesafesi / 1000)
        {
          marketeCixisIcazesi = true,
        }
      else
        {
          marketeCixisIcazesi = false,
        },
      DialogHelper.hideLoading(),
      Get.dialog(
          Material(
            color: Colors.transparent,
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery
                        .of(context)
                        .size
                        .height * 0.28,
                    horizontal: MediaQuery
                        .of(context)
                        .size
                        .width * 0.1),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomText(
                                    labeltext: "dcixis".tr,
                                    fontsize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Expanded(
                          flex: marketeCixisIcazesi ? 6 : 8,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0)
                                .copyWith(left: 20, right: 20),
                            child: marketeCixisIcazesi
                                ? Column(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    labeltext:
                                    "${controllerGirisCixis.modelgirisEdilmis
                                        .value
                                        .customerName!} ${"cixiEtmekIsteyi".tr}",
                                    fontsize: 18,
                                    maxline: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                TextField(
                                  controller: controllerGirisCixis.ctCixisQeyd,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                      hintText: "cxQeyd".tr,
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(width: 1, color: Colors.redAccent)
                                      )
                                  ),

                                ),
                              ],
                            )
                                : Column(
                              children: [
                                const Icon(Icons.info,
                                    color: Colors.red, size: 40),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomText(
                                  labeltext:
                                  "${"merketdenUzaqCixisXeta".tr}$marketeGirisIcazeMesafesi m-dir",
                                  fontsize: 14,
                                  maxline: 4,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: marketeCixisIcazesi ? 3 : 0,
                          child: marketeCixisIcazesi
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomElevetedButton(
                                  borderColor: Colors.black,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.4,
                                  height:40,
                                  textColor: Colors.red,
                                  icon: Icons.exit_to_app_rounded,
                                  elevation: 5,
                                  cllback: () {
                                    cixisEt(secilenMarketdenUzaqliq,value);
                                    Get.back();
                                  },
                                  label: "cixiset".tr)
                            ],
                          )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                    Positioned(
                        top: -5,
                        right: -5,
                        child: IconButton.outlined(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.highlight_remove,
                              color: Colors.red,
                            )))
                  ],
                )),
          ),
          barrierDismissible: false,
          transitionCurve: Curves.easeOut,
          transitionDuration: const Duration(milliseconds: 400))
    });
  }

  Future<void> cixisEt(double uzaqliq, Position value) async {
    await controllerGirisCixis.pripareForExit(value, uzaqliq,selectedCariModel).then((e){
      confiqGeolocatior();
     // _toggleListening();
      setState(() {});
    });

  }
  confiqGeolocatior(){
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          )
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
  }
}
