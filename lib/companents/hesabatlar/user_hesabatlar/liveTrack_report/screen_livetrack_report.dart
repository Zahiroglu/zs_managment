import 'dart:async';
import 'dart:math' as math;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/marketuzre_hesabatlar.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import '../../../live_track/model/model_live_track.dart';
import 'controller_live_track_report.dart';
import 'model_live_track_map.dart';

class ScreenLiveTrackReport extends StatefulWidget {
  String userCode;
  int roleId;
  String startDay;
  String endDay;
  int rutDay;

  ScreenLiveTrackReport({required this.userCode,required this.roleId,
    required this.startDay,required this.endDay,required this.rutDay, super.key});

  @override
  State<ScreenLiveTrackReport> createState() => _ScreenLiveTrackReportState();
}

class _ScreenLiveTrackReportState extends State<ScreenLiveTrackReport> {
  ControllerLiveTrackReport controllerGirisCixis =Get.put(ControllerLiveTrackReport());
  map.GoogleMapController? newgooglemapxontroller;
  int selectedIndex=0;
  bool expandMore=false;
  bool showPanel = true;
  final AxisDirection axisDirection =
      AxisDirection.down; // Set triangle location up,left,right,down

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (controllerGirisCixis.initialized) {
      controllerGirisCixis.getMyConnectedUsersCurrentLocations(widget.userCode,widget.roleId.toString(),widget.startDay,widget.endDay,widget.rutDay.toString());
    }
  }

  @override
  void dispose() {
    controllerGirisCixis.customInfoWindowController.value.dispose();
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
                      : Column(
                          children: [
                            Expanded(flex: 5, child: widgetGoogleMap()),
                            showPanel
                                ? Expanded(flex: 6, child: widgetShowList())
                                : Expanded(flex: 2, child: widgetShowList())
                          ],
                        ),
                ))));
  }

  Widget widgetGoogleMap() {
    return Obx(()=>Stack(
      children: [
        map.GoogleMap(
          initialCameraPosition: map.CameraPosition(
              target: controllerGirisCixis.initialPosition.value, zoom: 17),
          onTap: (v) {
            controllerGirisCixis.selectedModel.value = MyConnectedUsersCurrentLocationReport();
            controllerGirisCixis.customInfoWindowController.value.hideInfoWindow!();
            controllerGirisCixis.selectedModel.value = MyConnectedUsersCurrentLocationReport();
            setState(() {
              showPanel=true;

            });
          },
          polylines: controllerGirisCixis.polylines.toSet(),
          markers: controllerGirisCixis.markers,
          circles: controllerGirisCixis.circles.toSet(),
          padding: const EdgeInsets.all(2),
          onCameraMove: (po){
            controllerGirisCixis.customInfoWindowController.value.onCameraMove!();
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
                child: const Icon(Icons.arrow_back))),
        Positioned(
            bottom: 60,
            right: 15,
            child: InkWell(
                onTap: () {
                  setState(() {
                    showPanel = !showPanel;
                  });
                },
                child:
                showPanel ? const Icon(Icons.fullscreen) : const Icon(Icons.fit_screen_outlined))),
        Obx(()=>controllerGirisCixis.selectedModel.value.type!=0?CustomInfoWindow(
          controller: controllerGirisCixis.customInfoWindowController.value,
          height: controllerGirisCixis.selectedModel.value.type!=0?170:50,
          width:controllerGirisCixis.selectedModel.value.type!=0?MediaQuery.of(context).size.width*0.8:MediaQuery.of(context).size.width*0.3,
          offset: controllerGirisCixis.selectedModel.value.type!=0?30:10,
        ):const SizedBox()),
        Align(
          alignment: Alignment.bottomCenter,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.transparent
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              CustomElevetedButton(
                icon: Icons.arrow_circle_left_outlined,
                elevation: 5,
                  borderColor: Colors.blue,
                  textColor: Colors.blue,
                  height: 30,
                  cllback: (){
                  _animateNext((selectedIndex-1)!=0?selectedIndex-1:0);
                  }, label: "Evvelki"),
              CustomElevetedButton(
                iconLeft: false,
                icon: Icons.arrow_circle_right_outlined,
                  elevation: 5,
                  borderColor: Colors.blue,
                  textColor: Colors.blue,
                  height: 30,
                  cllback: (){
                    _animateNext((selectedIndex>controllerGirisCixis.listTrackdata.length?selectedIndex:selectedIndex+1));
                  }, label: "Sonraki")
                      ],),
            ),
          ),),
        Positioned(
          bottom: 100,
          right: 5,
          child: InkWell(
            onTap: (){
              _showDaylyReportDialog();
            },
            child: Container(
              height: 40,
              width: 40,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.5),
              ),
              child: const Center(
                child: Icon(Icons.info_outline, color: Colors.deepOrange),
              ),
            ),
          ),
        )
      ],
    ));
  }

  void _onMapCreated(map.GoogleMapController controller) {
    newgooglemapxontroller = controller;
    controllerGirisCixis.customInfoWindowController.value.googleMapController = controller;

    //_getCurrentLocation();
  }

  widgetShowList() {
    return Container(
      padding: const EdgeInsets.all(5).copyWith(top: 10),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount:controllerGirisCixis.listLastInoutAction.length,
                  itemBuilder: (c, index) {
                    return stapListItems(
                        controllerGirisCixis.listLastInoutAction[index],index+1);
                  }))
        ],
      ),
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

  stapListItems(LastInoutAction data, int index) {
    return InkWell(
      onTap: (){
        setState(() {
          showPanel=false;
          selectedIndex=index;
          controllerGirisCixis.selectedModel.value=controllerGirisCixis.listTrackdata.where((e)=>e.pastInputCustomerCode==data.customerCode!).first;
        });
        map.CameraPosition cameraPosition = map.CameraPosition(target:
        map.LatLng(double.parse(data.customerLatitude!),
            double.parse(data.customerLongitude!)), zoom: 20,);
        map.CameraUpdate cameraUpdate=map.CameraUpdate.newCameraPosition(cameraPosition);
        newgooglemapxontroller!.animateCamera(cameraUpdate);
        controllerGirisCixis.customInfoWindowController.value.addInfoWindow!(
            controllerGirisCixis.widgetCustomInfo(data,Get.context!), map.LatLng(
            double.parse(data.customerLatitude!),
            double.parse(data.customerLongitude!)));

      },
      child: Card(
        elevation:  selectedIndex!=index?2:15,
        surfaceTintColor:data.inDate!=null?data.outDate!.isNotEmpty?Colors.green:Colors.orange:Colors.red,
        margin: const EdgeInsets.only(bottom: 10),
        shadowColor: data.inDate!=null?Colors.grey:Colors.red,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      CustomText(labeltext: data.customerName!),
                    ],
                  ),
                  data.inDate!=null?Column(
                   children: [
                     SizedBox(
                       height:30,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(children: [
                             CustomText(labeltext: "${"time".tr} : "),
                             data.inDate==null?const SizedBox():
                             data.outDate!.length<10?
                             CustomText(labeltext: "${data.inDate!.substring(10,16)} - ${"cixisedilmeyib".tr}"):
                             CustomText(labeltext: "${data.inDate!.substring(10,16)} -${data.outDate!.substring(10,16)}")
                             ,const SizedBox(width: 10,)

                           ],),
                           IconButton(
                               splashRadius: 5,
                               padding: const EdgeInsets.all(0),
                               onPressed: (){
                                 setState(() {
                                   expandMore=!expandMore;
                                   selectedIndex=index;
                                 });
                               }, icon: expandMore?const Icon(Icons.expand_less):const Icon(Icons.expand_more))
                         ],
                       ),
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                     Row(
                       children: [
                         data.hasKassa!?DecoratedBox(
                             decoration: BoxDecoration(
                                 color: Colors.blue.withOpacity(0.4),
                                 borderRadius: BorderRadius.circular(5)
                             ),
                             child: Padding(
                               padding: const EdgeInsets.all(1.0).copyWith(left: 5,right: 5),
                               child: CustomText(labeltext: "kassa".tr),
                             )):const SizedBox(),
                         const SizedBox(width: 10,),
                         data.hasSatis!?DecoratedBox(
                             decoration: BoxDecoration(
                                 color: Colors.green.withOpacity(0.4),
                                 borderRadius: BorderRadius.circular(5)
                             ),
                             child: Padding(
                               padding: const EdgeInsets.all(1.0).copyWith(left: 5,right: 5),
                               child: CustomText(labeltext: "satis".tr),
                             )):const SizedBox(),
                         const SizedBox(width: 10,),
                         data.hasIade!?DecoratedBox(
                             decoration: BoxDecoration(
                                 color: Colors.red.withOpacity(0.4),
                                 borderRadius: BorderRadius.circular(5)
                             ),
                             child: Padding(
                               padding: const EdgeInsets.all(1.0).copyWith(left: 5,right: 5),
                               child: CustomText(labeltext: "iade".tr),
                             )):const SizedBox(),
                       ],
                     ),
                     ],)
                   ],
                 ):const SizedBox(),
                  const SizedBox(height: 10,),
                  selectedIndex!=index?const SizedBox():expandMore?WidgetCarihesabatlar(cad: data.customerName!, ckod: data.customerCode!, height: 100):SizedBox()
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 5,
              child: DecoratedBox(
                decoration:  BoxDecoration(
                    color: data.inDate!=null?data.outDate!.isNotEmpty?Colors.green:Colors.orange:Colors.red,
                    shape: BoxShape.circle
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),

                  child: CustomText(labeltext: index.toString(),fontsize: 10,),
                )),
            ),
            data.workTimeInCustomer.toString()=="null"? Positioned(
              top: 10,
              right: 5,
              child: SizedBox(
                height:30,
                child: IconButton(
                    splashRadius: 5,
                    padding: const EdgeInsets.all(0),
                    onPressed: (){
                      setState(() {
                        expandMore=!expandMore;
                        selectedIndex=index;
                      });
                    }, icon: expandMore?const Icon(Icons.expand_less):const Icon(Icons.expand_more)),
              ),
            ):Positioned(
              top: 5,
              right: 5,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0).copyWith(left: 5,right: 5),
                    child: CustomText(labeltext: data.workTimeInCustomer.toString()),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _animateNext(int i) {
    setState(() {
      selectedIndex=i;
      controllerGirisCixis.selectedModel.value=controllerGirisCixis.listTrackdata[i];
    });
    map.CameraPosition cameraPosition = map.CameraPosition(target:
    map.LatLng(double.parse(controllerGirisCixis.listTrackdata[i].latitude!),
        double.parse(controllerGirisCixis.listTrackdata[i].longitude!)), zoom: 16,);
    map.CameraUpdate cameraUpdate=map.CameraUpdate.newCameraPosition(cameraPosition);
    newgooglemapxontroller!.animateCamera(cameraUpdate);
    if(controllerGirisCixis.listTrackdata[i].type!=0){
      controllerGirisCixis.customInfoWindowController.value.addInfoWindow!(
          controllerGirisCixis.widgetCustomInfo(controllerGirisCixis.listTrackdata[i].inOutCustomer!,Get.context!), map.LatLng(
          double.parse(controllerGirisCixis.listTrackdata[i].inOutCustomer!.customerLatitude!),
          double.parse(controllerGirisCixis.listTrackdata[i].inOutCustomer!.customerLongitude!)));
    }else{
      controllerGirisCixis.customInfoWindowController.value.addInfoWindow!(
          controllerGirisCixis.widgetCustomInfoForLocations(controllerGirisCixis.listTrackdata[i],Get.context!), map.LatLng(
          double.parse(controllerGirisCixis.listTrackdata[i].latitude!),
          double.parse(controllerGirisCixis.listTrackdata[i].longitude!)));
    }

  }

  void _showDaylyReportDialog() {
    Get.dialog(Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,

        ),
       // height: MediaQuery.of(context).size.height,
       // width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 150,),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
              padding: EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20,right: 20),
            //  height: MediaQuery.of(context).size.height*0.5,
              //width: MediaQuery.of(context).size.width*0.8,
              child: Column(
                children: [
                  CustomText(labeltext: "Gunluk rapor",fontsize: 16,fontWeight: FontWeight.bold,),
                  CustomText(labeltext: controllerGirisCixis.listTrackdata.first.locationDate.toString().substring(0,10),fontsize: 16,fontWeight: FontWeight.bold,),
                  const SizedBox(height: 10,),
                  Row(children: [
                    CustomText(labeltext: "isBaslama".tr+" : ",fontWeight: FontWeight.w500),
                    CustomText(labeltext: controllerGirisCixis.listLastInoutAction.first.inDate.toString().substring(10,16))
                  ],),
                  Row(children: [
                    CustomText(labeltext: "ziyaretSayi".tr+" : ",fontWeight: FontWeight.w500),
                    CustomText(labeltext: controllerGirisCixis.listTrackdata.where((e)=>e.type==1).length.toString())
                  ],),
                  Row(children: [
                    CustomText(labeltext: "ziyaretEdilmeyen".tr+" : ",fontWeight: FontWeight.w500),
                    CustomText(labeltext: controllerGirisCixis.listZiyaretEdilmeyenler.length.toString())
                  ],),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CustomElevetedButton(
                      height: 30,
                      label: "clouse".tr,
                      icon: Icons.close,
                      borderColor: Colors.blue,
                      textColor: Colors.blue,
                      cllback: (){
                        Get.back();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class WidgetInfoWindow extends StatelessWidget {
  final LastInoutAction element;
  final ControllerLiveTrackReport controllerGirisCixis;
  final Color color; // Set box Color
  final EdgeInsets padding; // Set content padding
  final double width; // Box width
  final double height; // Box Height
  final AxisDirection axisDirection; // Set triangle location up,left,right,down
  final double
  locationOfArrow; // set between 0 and 1, If 0.5 is set triangle position will be centered

  const WidgetInfoWindow({
    super.key,
    required this.element,
    required this.controllerGirisCixis,
    this.color = Colors.blue,
    this.padding = const EdgeInsets.only(left: 10,right: 10,top: 15),
    this.width = 400,
    this.height =140,
    this.axisDirection = AxisDirection.down,
    this.locationOfArrow = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    Size arrowSize = const Size(25, 25);

    return Stack(
      children: [
         Flexible(
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  offset: Offset(3, 2),
                  color: Colors.black38,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "images/shopplace.png",
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      labeltext: element.customerName ?? 'Unknown',
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const Divider(color: Colors.white),
                element.inDate!=null? _buildInOutDetails():CustomText(labeltext: "Ziyaret edilmeyib"),

              ],
            ),
          ),
        ),
        _buildArrow(arrowSize),
        _buildTopRightCloseButton(),
      ],
    );
  }

  Widget _buildInOutDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInOutRow("girisVaxt".tr, element.inDate!.substring(10,16)),
            _buildInOutRow("mesafe".tr, element.inDistance),
          ],
        ),
        if (element.outDate != null && element.outDate!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInOutRow("cixisVaxt".tr, element.outDate!.substring(10,16)),
              _buildInOutRow("mesafe".tr, element.outDistance),
            ],
          ),
          _buildWorkTimeRow(),
        ],
      ],
    );
  }

  Widget _buildInOutRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(labeltext: "$label: "),
        CustomText(labeltext: value?.toString() ?? 'N/A'),
      ],
    );
  }

  Widget _buildWorkTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(labeltext: "${"marketdeISvaxti".tr} : "),
        CustomText(labeltext: element.workTimeInCustomer?.toString() ?? 'N/A'),
      ],
    );
  }

  Widget _buildArrow(Size arrowSize) {
    double angle = _calculateArrowAngle();
    return Positioned(
      //left: 150,
       left: _getArrowLeftPosition(arrowSize),
      // right: _getArrowRightPosition(arrowSize),
      // top: _getArrowTopPosition(arrowSize),
       bottom: _getArrowBottomPosition(arrowSize),
      child: Transform.rotate(
        angle: angle,
        child: CustomPaint(
          size: arrowSize,
          painter: ArrowPaint(color: Colors.blue),
        ),
      ),
    );
  }

  double _calculateArrowAngle() {
    switch (axisDirection) {
      case AxisDirection.left:
        return math.pi * -0.4;
      case AxisDirection.up:
        return math.pi * -2;
      case AxisDirection.right:
        return math.pi * 0.5;
      case AxisDirection.down:
      default:
        return math.pi;
    }
  }

  double? _getArrowLeftPosition(Size arrowSize) {
    return axisDirection == AxisDirection.left
        ? -arrowSize.width/2
        : (axisDirection == AxisDirection.up || axisDirection == AxisDirection.down
        ? width * locationOfArrow - arrowSize.width +15
        : null);
  }



  double? _getArrowBottomPosition(Size arrowSize) {
    return axisDirection == AxisDirection.down ? -arrowSize.width+32 : null;
  }

  Widget _buildTopRightCloseButton() {
    return Positioned(
      top: 0,
      right: 4,
      child: InkWell(
        onTap: () {
          controllerGirisCixis.selectedModel.value = MyConnectedUsersCurrentLocationReport();
        },
        child: const Icon(Icons.clear),
      ),
    );
  }
}

class WidgetInfoWindowForLocation extends StatelessWidget {
  final MyConnectedUsersCurrentLocationReport element;
  final ControllerLiveTrackReport controllerGirisCixis;
  final Color color; // Set box Color
  final EdgeInsets padding; // Set content padding
  final double width; // Box width
  final double height; // Box Height
  final AxisDirection axisDirection; // Set triangle location up,left,right,down
  final double
  locationOfArrow; // set between 0 and 1, If 0.5 is set triangle position will be centered

  const WidgetInfoWindowForLocation({
    super.key,
    required this.element,
    required this.controllerGirisCixis,
    this.color = Colors.blue,
    this.padding = const EdgeInsets.only(left: 2,right: 2,top: 2),
    this.width = 0,
    this.height =30,
    this.axisDirection = AxisDirection.down,
    this.locationOfArrow = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    Size arrowSize = const Size(20, 20);

    return Stack(
      children: [
        Flexible(
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  offset: Offset(3, 2),
                  color: Colors.black38,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: CustomText(labeltext: element.locationDate!,)),
          ),
        ),
        _buildArrow(arrowSize),
      ],
    );
  }


  Widget _buildArrow(Size arrowSize) {
    double angle = _calculateArrowAngle();
    return Positioned(
      //left: 150,
      left: _getArrowLeftPosition(arrowSize),
      // right: _getArrowRightPosition(arrowSize),
      // top: _getArrowTopPosition(arrowSize),
      bottom: _getArrowBottomPosition(arrowSize),
      child: Transform.rotate(
        angle: angle,
        child: CustomPaint(
          size: arrowSize,
          painter: ArrowPaint(color: Colors.blue),
        ),
      ),
    );
  }

  double _calculateArrowAngle() {
    switch (axisDirection) {
      case AxisDirection.left:
        return math.pi * -0.4;
      case AxisDirection.up:
        return math.pi * -2;
      case AxisDirection.right:
        return math.pi * 0.5;
      case AxisDirection.down:
      default:
        return math.pi;
    }
  }

  double? _getArrowLeftPosition(Size arrowSize) {
    return axisDirection == AxisDirection.left
        ? -arrowSize.width/2
        : (axisDirection == AxisDirection.up || axisDirection == AxisDirection.down
        ? width * locationOfArrow - arrowSize.width +15
        : null);
  }



  double? _getArrowBottomPosition(Size arrowSize) {
    return axisDirection == AxisDirection.down ? -arrowSize.width+22 : null;
  }

}
class ArrowPaint extends CustomPainter {
  final Color color;

  ArrowPaint({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.57, size.height * 0.06);
    path.lineTo(size.width * 0.98, size.height * 0.88);
    path.cubicTo(size.width, size.height * 0.92, size.width * 0.98, size.height * 0.97, size.width * 0.94, size.height);
    path.cubicTo(size.width * 0.93, size.height, size.width * 0.92, size.height, size.width * 0.91, size.height);
    path.lineTo(size.width * 0.09, size.height);
    path.cubicTo(size.width * 0.05, size.height, size.width * 0.01, size.height * 0.96, size.width * 0.01, size.height * 0.92);
    path.lineTo(size.width * 0.43, size.height * 0.06);
    path.cubicTo(size.width * 0.45, size.height * 0.02, size.width * 0.5, size.height * 0.01, size.width * 0.54, size.height * 0.03);
    path.close();

    Paint paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

