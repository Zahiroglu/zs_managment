import 'dart:async';
import 'dart:math';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'controller_live_track_report.dart';
import 'model_live_track_map.dart';

class ScreenLiveTrackReport extends StatefulWidget {
  List<MyConnectedUsersCurrentLocationReport> listGirisCixis;

  ScreenLiveTrackReport({required this.listGirisCixis, super.key});

  @override
  State<ScreenLiveTrackReport> createState() => _ScreenLiveTrackReportState();
}

class _ScreenLiveTrackReportState extends State<ScreenLiveTrackReport> {
  ControllerLiveTrackReport controllerGirisCixis =
      Get.put(ControllerLiveTrackReport());
  map.GoogleMapController? newgooglemapxontroller;
  Completer<map.GoogleMapController> _controllerMap = Completer();
  bool showLeftSide = false;
  final AxisDirection axisDirection =
      AxisDirection.down; // Set triangle location up,left,right,down

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (controllerGirisCixis.initialized) {
      controllerGirisCixis.getAllGirisCixis(widget.listGirisCixis);
    }
  }

  @override
  void dispose() {
    controllerGirisCixis.customInfoWindowController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Obx(() => Scaffold(
                  body: controllerGirisCixis.dataIsLoading.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(flex: 5, child: widgetGoogleMap()),
                            showLeftSide
                                ? Expanded(flex: 6, child: widgetShowList())
                                : SizedBox()
                          ],
                        ),
                ))));
  }

  Widget widgetGoogleMap() {
    return Stack(
      children: [
        map.GoogleMap(
          initialCameraPosition: map.CameraPosition(
              target: controllerGirisCixis.initialPosition.value, zoom: 17),
          onTap: (v) {
            controllerGirisCixis.customInfoWindowController.hideInfoWindow!();
            controllerGirisCixis.selectedModel.value = MyConnectedUsersCurrentLocationReport();
            setState(() {});
          },
          polylines: controllerGirisCixis.polylines.value.toSet(),
          markers: controllerGirisCixis.markers.value,
          circles: controllerGirisCixis.circles.value.toSet(),
          padding: const EdgeInsets.all(2),
          onCameraMove: (po){
            controllerGirisCixis.customInfoWindowController.onCameraMove!();
          },
          mapToolbarEnabled: false,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          compassEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: map.MapType.normal,
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer()))
            ..add(Factory<HorizontalDragGestureRecognizer>(
                () => HorizontalDragGestureRecognizer()))
            ..add(Factory<ScaleGestureRecognizer>(
                () => ScaleGestureRecognizer())),
          onCameraIdle: () {},
          onMapCreated: _onMapCreated,
        ),
        Positioned(
            top: 20,
            left: 15,
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back))),
        Positioned(
            top: showLeftSide ? 10 : 20,
            right: showLeftSide ? 0 : 15,
            child: InkWell(
                onTap: () {
                  setState(() {
                    showLeftSide = !showLeftSide;
                  });
                },
                child:
                    showLeftSide ? Icon(Icons.clear) : Icon(Icons.list_alt))),
        CustomInfoWindow(
          controller: controllerGirisCixis.customInfoWindowController,
          height: 200,
          width:MediaQuery.of(context).size.width*0.6,
          offset: 50,
        ),
        // AnimatedPositioned(
        //   curve: Curves.decelerate,
        //   duration: Duration(milliseconds: 300),
        //   top: controllerGirisCixis.pinPillPosition.value,
        //   right: 0,
        //   left: 0,
        //   child: showCustomInfoByCariMelumat(
        //       true, controllerGirisCixis.selectedModel.value),
        // )
      ],
    );
  }

  void _onMapCreated(map.GoogleMapController controller) {

    _controllerMap.complete(controller);
    newgooglemapxontroller = controller;
    controllerGirisCixis.customInfoWindowController.googleMapController = controller;

    //_getCurrentLocation();
  }

  widgetShowList() {
    return Container(
      padding: EdgeInsets.all(5).copyWith(top: 10),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                labeltext: "Giris notkeleri",
                fontsize: 15,
              )
            ],
          ),
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: controllerGirisCixis.listTrackdata.length,
                  itemBuilder: (c, index) {
                    return stapListItems(
                        controllerGirisCixis.listTrackdata[index]);
                  }))
        ],
      ),
    );
  }

  Widget stapListItems(MyConnectedUsersCurrentLocationReport element) {
    Color color = Colors.blue;
    String headerTytle = "";
    switch (element.type) {
      case 0:
        color = Colors.blue;
        headerTytle = element.locationDate.toString();
        break;
      case 1:
        color = Colors.red;
        headerTytle = "${element.locationDate} - Giris noktesi";
        break;
      case 2:
        color = Colors.green;
        headerTytle = "${element.locationDate} - Cixis noktesi";

        break;
    }
    return InkWell(
      onTap: () async {
        changeCameraPosition(element);
        controllerGirisCixis.customInfoWindowController.addInfoWindow!(controllerGirisCixis.widgetCustomInfo(element),map.LatLng(double.parse(element.latitude!), double.parse(element.longitude!)));
        if (element.type == 0) {
          await controllerGirisCixis.onPositionPointClick(element, element.type == 0);
          setState(() {
            showLeftSide = false;
          });
        } else {
          await controllerGirisCixis.onPositionPointClick(element, element.type == 0);
          setState(() {
            showLeftSide = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8, right: 5),
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black)),
              ),
              CustomText(
                labeltext: headerTytle,
                fontsize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 17),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
              color: color,
            ))),
            child: element.type == 0
                ? widgetSimplePoints(element)
                : widgetSimpleGirisCixis(element),
          ),
        ],
      ),
    );
  }

  Column widgetSimplePoints(MyConnectedUsersCurrentLocationReport element) {
    return Column(
      children: [
        element.pastInputCustomerCode != ""
            ? DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomText(labeltext: "Market Kodu : "),
                              CustomText(
                                  labeltext:
                                      element.pastInputCustomerCode.toString()),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(labeltext: "Uzaqliq : "),
                              CustomText(
                                  labeltext:
                                      element.inputCustomerDistance.toString()),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "Market Adi : "),
                          CustomText(
                              labeltext:
                                  element.pastInputCustomerName.toString()),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomText(labeltext: "Enerji miqdari : "),
                CustomText(labeltext: "${element.batteryLevel} %"),
              ],
            ),
            Row(
              children: [
                CustomText(labeltext: "Hereket Surreti : "),
                CustomText(labeltext: "${element.speed} m/s"),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column widgetSimpleGirisCixis(MyConnectedUsersCurrentLocationReport element) {
    return Column(
      children: [
        Row(
          children: [
            CustomText(labeltext: element.inOutCustomer!.customerCode!),
            const SizedBox(
              width: 10,
            ),
            CustomText(labeltext: element.inOutCustomer!.customerName!)
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomText(labeltext: "Giris vaxti: "),
                        CustomText(
                            labeltext: element.inOutCustomer!.inDate
                                .toString()
                                .substring(10, 19)),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        CustomText(labeltext: "Uzaqliq : "),
                        CustomText(
                            labeltext:
                                element.inOutCustomer!.inDistance.toString()),
                      ],
                    ),
                  ],
                ),
                element.type == 2
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText(labeltext: "Cixis vaxti: "),
                                  CustomText(
                                      labeltext: element.inOutCustomer!.outDate
                                          .toString()
                                          .substring(10, 19)),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  CustomText(labeltext: "Uzaqliq : "),
                                  CustomText(
                                      labeltext: element
                                          .inOutCustomer!.outDistance
                                          .toString()),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(
                                  labeltext: "marketdeISvaxti".tr + " : "),
                              CustomText(
                                  labeltext: element
                                      .inOutCustomer!.workTimeInCustomer
                                      .toString()),
                            ],
                          )
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        )
      ],
    );
  }

  void changeCameraPosition(MyConnectedUsersCurrentLocationReport element) {
    double lat=double.parse(element.latitude!);
    double lng=double.parse(element.longitude!);
    map.CameraPosition position=map.CameraPosition(target: map.LatLng(lat,lng),zoom: 17);
    map.CameraUpdate cameraUpdate=map.CameraUpdate.newCameraPosition(position);
    newgooglemapxontroller!.animateCamera(cameraUpdate);
    setState(() {});

  }
}

class WidgetInfoWindow extends StatelessWidget {
  final MyConnectedUsersCurrentLocationReport element;
  ControllerLiveTrackReport controllerGirisCixis;
  final Color color; // Set box Color
  final EdgeInsets padding; // Set content padding
  final double width; // Box width
  final double height; // Box Height
  final AxisDirection axisDirection; // Set triangle location up,left,right,down
  final double
      locationOfArrow; // set between 0 and 1, If 0.5 is set triangle position will be centered
  WidgetInfoWindow({
    super.key,
    required this.element,
    required this.controllerGirisCixis,
    this.color = Colors.blue,
    this.padding = const EdgeInsets.all(15),
    this.width = 500,
    this.height = 150,
    this.axisDirection = AxisDirection.down,
    this.locationOfArrow = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    Size arrowSize = const Size(25, 25);
    return element.userCode != null
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: width,
                height: height,
                padding: padding,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3,2),
                      //color: Colors.black,
                      color: element.type==0?Colors.blue:element.type==1?Colors.red:Colors.green,
                     // blurStyle: BlurStyle.inner,
                      blurRadius: 10,
                      spreadRadius: 0
                    )
                  ],
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: element.type == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex:2,
                            child: Image.asset(
                              "images/userplace.png",
                              width: width * 0.20,
                              height: height * 0.8,
                            ),
                          ),
                          Expanded(
                            flex:8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(labeltext: element.locationDate.toString(),fontWeight: FontWeight.bold,),
                                element.pastInputCustomerCode != ""
                                    ? Padding(
                                      padding: const EdgeInsets.all(5.0).copyWith(left: 0),
                                      child: DecoratedBox(decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black26),),
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(labeltext: "${"mKod".tr} : "),
                                                  CustomText(
                                                      labeltext:
                                                      element.pastInputCustomerCode.toString()),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  CustomText(labeltext: "${"mesafe".tr} : "),
                                                  CustomText(
                                                      labeltext:
                                                      element.inputCustomerDistance.toString()),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              CustomText(labeltext: "${"mAdi".tr} : "),
                                              CustomText(
                                                  labeltext:
                                                  element.pastInputCustomerName.toString()),
                                            ],
                                          )
                                        ],
                                      ),
                                                                        ),
                                                                      ),
                                    )
                                    : const SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CustomText(labeltext: "${"enerjyMiqdari".tr} : "),
                                        CustomText(labeltext: "${element.batteryLevel} %"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CustomText(labeltext: "${"hereketMiqdari".tr} : "),
                                        CustomText(labeltext: "${element.speed} m/s"),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "images/shopplace.png",
                            width: width * 0.30,
                            height: height * 0.8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    labeltext:
                                        element.inOutCustomer!.customerName!,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: width * 0.8,
                                color: Colors.white,
                                height: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                      labeltext:
                                          element.pastInputCustomerName!),
                                  CustomText(
                                      labeltext:
                                          element.pastInputCustomerCode!),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(labeltext: "${"girisVaxt".tr} : "),
                                      CustomText(
                                          labeltext: element
                                              .inOutCustomer!.inDate
                                              .toString()
                                              .substring(10, 19)),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "${"mesafe".tr} : "),
                                      CustomText(
                                          labeltext: element
                                              .inOutCustomer!.inDistance
                                              .toString()),
                                    ],
                                  ),
                                ],
                              ),
                              element.type == 2
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CustomText(
                                                    labeltext: "${"cixisVaxt".tr} : "),
                                                CustomText(
                                                    labeltext: element
                                                        .inOutCustomer!.outDate
                                                        .toString()
                                                        .substring(10, 19)),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                    labeltext: "${"mesafe".tr} : "),
                                                CustomText(
                                                    labeltext: element
                                                        .inOutCustomer!
                                                        .outDistance
                                                        .toString()),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CustomText(
                                                labeltext:
                                                    "marketdeISvaxti".tr +
                                                        " : "),
                                            CustomText(
                                                labeltext: element
                                                    .inOutCustomer!
                                                    .workTimeInCustomer
                                                    .toString()),
                                          ],
                                        )
                                      ],
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      ),
              ),
              Builder(builder: (context) {
                double angle = 0;
                switch (axisDirection) {
                  case AxisDirection.left:
                    angle = pi * -0.5;
                    break;
                  case AxisDirection.up:
                    angle = pi * -2;
                    break;
                  case AxisDirection.right:
                    angle = pi * 0.5;
                    break;
                  case AxisDirection.down:
                    angle = pi;
                    break;
                  default:
                    angle = 0;
                }
                return Positioned(
                  left: axisDirection == AxisDirection.left ? -arrowSize.width + 5 : (axisDirection == AxisDirection.up ||
                              axisDirection == AxisDirection.down ? width * locationOfArrow - arrowSize.width / 2 : null),
                  right: axisDirection == AxisDirection.right ? -arrowSize.width + 5 : null,
                  top: axisDirection == AxisDirection.up ? -arrowSize.width + 5 : (axisDirection == AxisDirection.right ||
                              axisDirection == AxisDirection.left ? height * locationOfArrow - arrowSize.width / 2 : null),
                  bottom: axisDirection == AxisDirection.down ? -arrowSize.width + 5 : null,
                  child: Transform.rotate(
                    angle: angle,
                    child: CustomPaint(
                      size: arrowSize,
                      painter: ArrowPaint(color: Colors.deepOrange),
                    ),
                  ),
                );
              }),
              Positioned(
                  top: 0,
                  left: 4,
                  child: CustomText(
                    labeltext: element.type == 0
                        ? element.pastInputCustomerCode!
                        : element.inOutCustomer!.customerCode!,
                    fontWeight: FontWeight.normal,
                    fontsize: 12,
                  )),
              Positioned(
                top: 0,
                right: 4,
                child: InkWell(
                    onTap: () {
                      controllerGirisCixis.selectedModel.value =
                          MyConnectedUsersCurrentLocationReport();
                    },
                    child: Icon(Icons.clear)),
              )
            ],
          )
        : SizedBox();
  }
}

class ArrowPaint extends CustomPainter {
  final Color color;

  ArrowPaint({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5745375, size.height * 0.06573708);
    path_0.lineTo(size.width * 0.9813667, size.height * 0.8794000);
    path_0.cubicTo(
        size.width * 1.001950,
        size.height * 0.9205625,
        size.width * 0.9852625,
        size.height * 0.9706208,
        size.width * 0.9441000,
        size.height * 0.9912000);
    path_0.cubicTo(
        size.width * 0.9325250,
        size.height * 0.9969875,
        size.width * 0.9197667,
        size.height,
        size.width * 0.9068292,
        size.height);
    path_0.lineTo(size.width * 0.09316958, size.height);
    path_0.cubicTo(
        size.width * 0.04714583,
        size.height,
        size.width * 0.009836208,
        size.height * 0.9626917,
        size.width * 0.009836208,
        size.height * 0.9166667);
    path_0.cubicTo(
        size.width * 0.009836208,
        size.height * 0.9037292,
        size.width * 0.01284829,
        size.height * 0.8909708,
        size.width * 0.01863392,
        size.height * 0.8794000);
    path_0.lineTo(size.width * 0.4254625, size.height * 0.06573708);
    path_0.cubicTo(
        size.width * 0.4460458,
        size.height * 0.02457225,
        size.width * 0.4961042,
        size.height * 0.007886875,
        size.width * 0.5372667,
        size.height * 0.02846929);
    path_0.cubicTo(
        size.width * 0.5533958,
        size.height * 0.03653296,
        size.width * 0.5664708,
        size.height * 0.04961000,
        size.width * 0.5745375,
        size.height * 0.06573708);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = color;
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
