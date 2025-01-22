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
  String roleId;
  String startDay;
  String endDay;

  ScreenLiveTrackReport({required this.userCode,required this.roleId,
    required this.startDay,required this.endDay, super.key});

  @override
  State<ScreenLiveTrackReport> createState() => _ScreenLiveTrackReportState();
}

class _ScreenLiveTrackReportState extends State<ScreenLiveTrackReport> {
  ControllerLiveTrackReport controllerGirisCixis =Get.put(ControllerLiveTrackReport());
  map.GoogleMapController? newgooglemapxontroller;
  int selectedIndex=0;
  bool expandMore=false;
  bool showPanel = true;
  final AxisDirection axisDirection = AxisDirection.down; // Set triangle location up,left,right,down
  bool showHistoryPanel=false;
  bool smoleHistoryPanel=false;
  bool sortListByDate=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (controllerGirisCixis.initialized) {
      controllerGirisCixis.getMyConnectedUsersCurrentLocations(widget.userCode,widget.roleId.toString(),widget.startDay,widget.endDay,"false");
    }
  }

  @override
  void dispose() {
    controllerGirisCixis.customInfoWindowController.value.dispose();
    newgooglemapxontroller!.dispose();
    Get.delete<ControllerLiveTrackReport>();
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
                          Expanded(
                            child: Column(
                                children: [
                                  Expanded(flex: 5,
                                      child: widgetGoogleMap()),
                                  showHistoryPanel?const SizedBox():showPanel
                                      ? Expanded(flex: 6, child: widgetShowList(context))
                                      : Expanded(flex: 2, child: widgetShowList(context))
                                ],
                              ),
                          ),
                          Expanded(
                            flex: showHistoryPanel ? smoleHistoryPanel?2:8 : 0,
                            child: showHistoryPanel ? widgetListHistoryPanel() : const SizedBox.shrink(),
                          ),                        ],
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
        showHistoryPanel?const SizedBox():Positioned(
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
        showHistoryPanel?const SizedBox():Obx(()=>CustomInfoWindow(
          controller: controllerGirisCixis.customInfoWindowController.value,
          height: controllerGirisCixis.selectedModel.value.type!=0?170:80,
          width:controllerGirisCixis.selectedModel.value.type!=0?
          MediaQuery.of(context).size.width*0.8:MediaQuery.of(context).size.width*0.5,
          offset: 30,
        )),
        showHistoryPanel?const SizedBox():Align(
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
          bottom: showHistoryPanel?null:100,
          top: showHistoryPanel?60:null,
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
        ),
        showHistoryPanel?const SizedBox():Positioned(
          top: 20,
          right: 5,
          child: InkWell(
            onTap: (){
                setState(() {
                  if(showHistoryPanel){
                    showHistoryPanel=false;
                    showPanel=true;
                  }else {
                    showPanel = false;
                    showHistoryPanel=true;
                  }});

            },
            child: Container(
              height: 40,
              width: 40,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.5),
              ),
              child:  const Center(
                child: Icon(Icons.history,color: Colors.black,),
              ),
            ),
          ),
        )
      ],
    ));
  }

  
  widgetListHistoryPanel(){
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(right: 0,bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                          children: [Icon(Icons.history),
                            const SizedBox(width: 10,),
                            CustomText(labeltext: "ziyaretTarixcesi".tr,fontsize: 16,color: Colors.black,)],
                        ),
               Row(
                 children: [
                   IconButton(onPressed: (){
                     setState(() {
                     if(sortListByDate) {
                       sortListByDate=false;
                       controllerGirisCixis.sortFilter(sortListByDate);
                     }else{
                       sortListByDate=true;
                       controllerGirisCixis.sortFilter(sortListByDate);                         }

                     });

                   }, icon:  Icon(Icons.sort,color: sortListByDate?Colors.blue:Colors.black,)),
                   IconButton(onPressed: (){
                     setState(() {
                       showHistoryPanel=false;
                       smoleHistoryPanel=false;
                       showPanel=true;
                     });

                   }, icon: const Icon(Icons.clear))
                 ],
               )
              ],
            ),
          ),
          const Divider(height: 10,color: Colors.black,thickness: 1,),
          Expanded(
            flex: 14,
            child: controllerGirisCixis.listTrackdata.isNotEmpty
                ? ListView.builder(
             // itemCount: controllerGirisCixis.listTrackdata.where((e)=>e.type==0).length,
              itemCount: controllerGirisCixis.listTrackdata.length,
              itemBuilder: (context, index) {
             //   return itemListHistory(controllerGirisCixis.listTrackdata.where((e)=>e.type==0).elementAt(index));
                return itemListHistory(controllerGirisCixis.listTrackdata.elementAt(index));
              },
            )
                : Center(child: CustomText(labeltext: "Tarixçə məlumatı yoxdur")),
          ),      ],
      ),
    );
  }

  itemListHistory(MyConnectedUsersCurrentLocationReport model) {
    Color marketColor=Colors.black;
    Icon iconMarker=Icon(Icons.circle_rounded,color: Colors.blue,size: 12,);
    int statusMarket=0;
    switch(model.type){
      case 1:
          statusMarket=1;
          marketColor=Colors.yellow;
          iconMarker=Icon(Icons.add_business,color: Colors.yellow,size: 24,);
        break;
      case 2:
          statusMarket=2;
          marketColor=Colors.green;
          iconMarker=Icon(Icons.business,color: Colors.green,size: 24,);
          break;
      case 0:
        if(model.pastInputCustomerName=="0"){
          iconMarker=Icon(Icons.circle_rounded,color: Colors.black,size: 12,);

        }statusMarket=0;
        break;


    }
    return Card(
      child: InkWell(
        onTap: (){
          _onHistoryItemClick(model);
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      height: 15,width: 1,color: Colors.black,),
                   iconMarker,
                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      height: 15,width: 1,color: Colors.black,)
                  ],
                ),
                ),
              const SizedBox(width: 2,),
              Expanded(
                flex: 10,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        model.pastInputCustomerName=="0"?
                        Column(
                          children: [_infoAdiLocationHistory(model),],
                        ): Column(children: [_infoGirisEdilmisLocatiom(model,statusMarket)
                        ],),



                      ],
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: CustomText(labeltext: model.locationDate!.substring(11,16),)),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: model.screenState!=
                            "b"? Image.asset(model.screenState==
                            "off"?"images/screenOff.png":"images/screenUnlock.png",fit: BoxFit.contain,
                          width: 20,height: 25,
                        ):const SizedBox())
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(map.GoogleMapController controller) {
    newgooglemapxontroller = controller;
    controllerGirisCixis.customInfoWindowController.value.googleMapController = controller;

    //_getCurrentLocation();
  }

  widgetShowList(BuildContext context) {
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
                  padding: const EdgeInsets.all(5),
                  itemCount:controllerGirisCixis.listLastInoutAction.length,
                  itemBuilder: (c, index) {
                    return stapListItems(
                        controllerGirisCixis.listLastInoutAction[index],index+1,context);
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

  stapListItems(LastInoutAction data, int index, BuildContext context) {
    MyConnectedUsersCurrentLocationReport model=controllerGirisCixis.listTrackdata.where((e)=>e.inOutCustomer==data).firstOrNull!;
    return InkWell(
      onTap: (){
        map.CameraPosition cameraPosition = map.CameraPosition(target:
        map.LatLng(double.parse(data.customerLatitude!), double.parse(data.customerLongitude!)), zoom: 20,);
        map.CameraUpdate cameraUpdate=map.CameraUpdate.newCameraPosition(cameraPosition);
        newgooglemapxontroller!.animateCamera(cameraUpdate);
        setState(() {
          showPanel=false;
          selectedIndex=index;
          controllerGirisCixis.selectedModel.value=model;
        });
        controllerGirisCixis.customInfoWindowController.value.addInfoWindow!(
            controllerGirisCixis.widgetCustomInfo(model, Get.context!,1),
            map.LatLng(double.parse(data.customerLatitude!), double.parse(data.customerLongitude!)));

      },
      child: Card(
        elevation:  selectedIndex!=index?2:15,
        surfaceTintColor:data.inDate!=null?data.outDate!.isNotEmpty?Colors.green:Colors.orange:Colors.red,
        margin: const EdgeInsets.only(bottom: 10),
        shadowColor: data.inDate!=null?Colors.grey:Colors.red,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0).copyWith(top: 5,left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(labeltext: data.customerName!),
                    ],
                  ),
                  data.inDate!=null?Column(
                   children: [
                     SizedBox(
                       height:40,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 5),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(children: [
                                   CustomText(labeltext: "${"time".tr} : "),
                                   data.inDate==null?const SizedBox():
                                   data.outDate!.length<10?
                                   CustomText(labeltext: "${data.inDate!.substring(10,16)} - ${"cixisedilmeyib".tr}"):
                                   CustomText(labeltext: "${data.inDate!.substring(10,16)} -${data.outDate!.substring(10,16)}")
                                   ,const SizedBox(width: 10,)

                                 ],),
                                 Row(children: [
                                   CustomText(labeltext: "${"mesafe".tr} : "),
                                   data.inDistance==null?const SizedBox():
                                   data.outDistance!.length<2?
                                   CustomText(labeltext: data.inDistance!):
                                   CustomText(labeltext: "${data.inDistance!} -${data.outDistance!}")
                                   ,const SizedBox(width: 10,)

                                 ],),
                               ],
                             ),
                           ),

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
                  selectedIndex!=index?const SizedBox():expandMore?WidgetCarihesabatlar(
                      loggedUser: controllerGirisCixis.userServices.getLoggedUser(),
                      cad: data.customerName!, ckod: data.customerCode!, height: 100):SizedBox()
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
    map.CameraPosition cameraPosition = map.CameraPosition(target:
    map.LatLng(double.parse(controllerGirisCixis.listTrackdata[i].latitude!), double.parse(controllerGirisCixis.listTrackdata[i].longitude!)), zoom: 19,);
    map.CameraUpdate cameraUpdate=map.CameraUpdate.newCameraPosition(cameraPosition);
    setState(() {
      selectedIndex=i;
      controllerGirisCixis.selectedModel.value=controllerGirisCixis.listTrackdata[i];
    });
    newgooglemapxontroller!.animateCamera(cameraUpdate);
      controllerGirisCixis.customInfoWindowController.value.addInfoWindow!(
          controllerGirisCixis.widgetCustomInfo(controllerGirisCixis.listTrackdata[i],Get.context!,controllerGirisCixis.selectedModel.value.type), map.LatLng(
          double.parse(controllerGirisCixis.listTrackdata[i].latitude!),
          double.parse(controllerGirisCixis.listTrackdata[i].longitude!)));

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

  _infoAdiLocationHistory(MyConnectedUsersCurrentLocationReport model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(labeltext: "Marketde deyil"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset("images/locaccuracy.png",width: 20,height: 20,fit: BoxFit.fill,),
                    CustomText(
                        fontsize: 12,
                        color: Colors.black87,
                        //labeltext: "${model.locAccuracy!??0} m"),
                        labeltext: "${model.locAccuracy} m"),
                  ],
                ),
                const SizedBox(width: 5,),
                Row(
                  children: [
                    Image.asset("images/batterystatus.png",width: 15,height: 12,fit: BoxFit.fill,),
                    const SizedBox(width: 0,),
                    CustomText(
                        fontsize: 12,
                        color: Colors.black87,
                        labeltext: "${model.batteryLevel} %"),
                  ],
                ),
                const SizedBox(width: 10,),
                Row(
                  children: [
                    Image.asset("images/userspeed.png",width: 15,height: 12,fit: BoxFit.fill,),
                    const SizedBox(width: 5,),
                    CustomText(
                        fontsize: 12,
                        color: Colors.black87,
                        labeltext: "${model.speed} m/s"),
                  ],
                ),
                const SizedBox(width: 10,),
                // widget.element.currentLocation!.isMoving!?
                model.isMoving!?
                Container(
                  height: 15,
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius:BorderRadius.all( Radius.circular(5))
                  ),
                  child: CustomText(labeltext: "${"hereketdedir".tr}"),
                ):Container(
                  height: 15,
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius:BorderRadius.all( Radius.circular(5))
                  ),
                  child: CustomText(labeltext: "${"stabildir".tr}",),)
              ],
            ),
          ],
        )
      ],

    );
  }

  _infoGirisEdilmisLocatiom(MyConnectedUsersCurrentLocationReport model, int statusMarket) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(labeltext: model.pastInputCustomerName??"Namelum"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            statusMarket==0?Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset("images/locaccuracy.png",width: 20,height: 20,fit: BoxFit.fill,),
                    CustomText(
                        fontsize: 12,
                        color: Colors.black87,
                        //labeltext: "${model.locAccuracy!??0} m"),
                        labeltext: "${model.locAccuracy} m"),
                  ],
                ),
                const SizedBox(width: 5,),
                Row(
                  children: [
                    Image.asset("images/batterystatus.png",width: 15,height: 12,fit: BoxFit.fill,),
                    const SizedBox(width: 0,),
                    CustomText(
                        fontsize: 12,
                        color: Colors.black87,
                        labeltext: "${model.batteryLevel} %"),
                  ],
                ),
                const SizedBox(width: 10,),
                Row(
                  children: [
                    Image.asset("images/userspeed.png",width: 15,height: 12,fit: BoxFit.fill,),
                    const SizedBox(width: 5,),
                    CustomText(
                        fontsize: 12,
                        color: Colors.black87,
                        labeltext: "${model.speed} m/s"),
                  ],
                ),
                const SizedBox(width: 10,),
               // widget.element.currentLocation!.isMoving!?
                model.isMoving!?
                Container(
                  height: 15,
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius:BorderRadius.all( Radius.circular(5))
                  ),
                  child: CustomText(labeltext: "${"hereketdedir".tr}"),
                ):Container(
                  height: 15,
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius:BorderRadius.all( Radius.circular(5))
                  ),
                  child: CustomText(labeltext: "${"stabildir".tr}",),)
              ],
            ):SizedBox(),
          ],
        ),
        statusMarket==0?CustomText(labeltext: "${"marketdenUzaqliq".tr} : ${model.inputCustomerDistance!} m"):SizedBox(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            model.inOutCustomer!=null? Expanded(
                flex:12,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    model.inOutCustomer!.outDate!=null?Padding(padding: const EdgeInsets.all(5),
                      child: statusMarket==2?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex:5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 15),
                                        padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:BorderRadius.all( Radius.circular(5))
                                        ),
                                        child: CustomText(labeltext: "cixisEdilib".tr,),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.social_distance,size: 14,),
                                          CustomText(labeltext:" - ${model.inOutCustomer!.outDistance}")

                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(labeltext: "${"marketdeISvaxti".tr} : "),
                                          CustomText(labeltext: model.inOutCustomer!.workTimeInCustomer.toString())
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          const SizedBox(width: 10,),
                        ],
                      ):
                      Container(
                        padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                        decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius:BorderRadius.all( Radius.circular(5))
                        ),
                        child: CustomText(labeltext: "${"marketeGirisEdib".tr} : ${model.inputCustomerDistance!} ",),),
                    ):SizedBox()
                  ],
                )):SizedBox(),
          ],
        ),
    ]);
  }

  void _onHistoryItemClick(MyConnectedUsersCurrentLocationReport model) {
    map.CameraPosition cameraPosition = map.CameraPosition(target:
    map.LatLng(double.parse(model.latitude!), double.parse(model.longitude!)), zoom: 20,);
    map.CameraUpdate cameraUpdate=map.CameraUpdate.newCameraPosition(cameraPosition);
    newgooglemapxontroller!.animateCamera(cameraUpdate);
    setState(() {
      smoleHistoryPanel=true;
      showPanel=false;
      selectedIndex=1;
      controllerGirisCixis.selectedModel.value=model;
    });
    controllerGirisCixis.customInfoWindowController.value.addInfoWindow!(
        controllerGirisCixis.widgetCustomInfo(model, Get.context!,0),
        map.LatLng(double.parse(model.latitude!), double.parse(model.longitude!)));


    // map.CameraPosition cameraPosition = map.CameraPosition(target:
    // map.LatLng(double.parse(model.latitude!), double.parse(model.longitude!)), zoom: 21,);
    // map.CameraUpdate cameraUpdate=map.CameraUpdate.newCameraPosition(cameraPosition);
    // if(mounted){
    //   setState(() {
    //     selectedIndex=controllerGirisCixis.listTrackdata.indexOf(model);
    //     controllerGirisCixis.selectedModel.value=model;
    //     showHistoryPanel=false;
    //     showPanel=false;
    //   });
    // }
    // newgooglemapxontroller!.animateCamera(cameraUpdate);
    // controllerGirisCixis.customInfoWindowController.value.addInfoWindow!(
    //       controllerGirisCixis.widgetCustomInfo(model, Get.context!, model.type),
    //       map.LatLng(
    //       double.parse(model.latitude!),
    //       double.parse(model.longitude!)));
  }
}

class WidgetInfoWindow extends StatelessWidget {
  final MyConnectedUsersCurrentLocationReport element;
  final Color color; // Set box Color
  final EdgeInsets padding; // Set content padding
  final double width; // Box width
  final double height; // Box Height
  final AxisDirection axisDirection; // Set triangle location up,left,right,down
  final double locationOfArrow; // set between 0 and 1, If 0.5 is set triangle position will be centered
  final int statusMarker;
  final Function(bool) clouse;

  const WidgetInfoWindow({
    super.key,
    required this.element,
    this.color = Colors.blue,
    this.padding = const EdgeInsets.only(left: 10,right: 10,top: 15),
    this.width = 400,
    this.height =140,
    this.axisDirection = AxisDirection.down,
    this.locationOfArrow = 0.5,
    required this.statusMarker,
    required this.clouse
  });

  @override
  Widget build(BuildContext context) {
    Size arrowSize = const Size(25, 25);
    return Stack(
      children: [
        statusMarker==0? Container(
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
                  Icon(Icons.task),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomText(
                      labeltext: element.locationDate.toString(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white),
             // CustomText(labeltext: "Ziyaret edilmeyib"),
            ],
          ),
        ):Flexible(
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
                    Expanded(
                      child: CustomText(
                        maxline: 2,
                        labeltext: element.inOutCustomer!.customerName ?? 'Unknown',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white),
                element.inOutCustomer!.inDate!=null? _buildInOutDetails():CustomText(labeltext: "Ziyaret edilmeyib"),

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
            _buildInOutRow("girisVaxt".tr, element.inOutCustomer!.inDate!.substring(10,16)),
            _buildInOutRow("mesafe".tr, element.inOutCustomer!.inDistance),
          ],
        ),
        if (element.inOutCustomer!.outDate != null && element.inOutCustomer!.outDate!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInOutRow("cixisVaxt".tr, element.inOutCustomer!.outDate!.substring(10,16)),
              _buildInOutRow("mesafe".tr, element.inOutCustomer!.outDistance),
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
        CustomText(labeltext: element.inOutCustomer!.workTimeInCustomer?.toString() ?? 'N/A'),
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
       bottom: _getArrowBottomPosition(arrowSize)!/5,
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
          clouse.call(true);
        },
        child: const Icon(Icons.clear),
      ),
    );
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

