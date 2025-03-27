import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:intl/intl.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';
import '../../widgets/custom_text_field.dart';
import '../hesabatlar/user_hesabatlar/useruzre_hesabatlar.dart';
import 'controller_live_track/controller_live_track.dart';
import 'model/model_live_track.dart';

class SearchLiveUsers extends StatefulWidget {
  ControllerLiveTrack controllerLive;
  Function(ModelLiveTrack) callBack;
  Function(bool) callBackGunluk;

  SearchLiveUsers({required this.controllerLive, required this.callBack, required this.callBackGunluk, super.key});

  @override
  State<SearchLiveUsers> createState() => _SearchLiveUsersState();
}

class _SearchLiveUsersState extends State<SearchLiveUsers> {
  List<ModelLiveTrack> selectedusers=[];


  @override
  void initState() {
    selectedusers=widget.controllerLive.listTrackdata;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            //color: Colors.black.withOpacity(0.08),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
          ),
          child: Column(
                children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CustomTextField(
                  containerHeight: 40,
                  suffixIcon: Icons.search_outlined,
                  align: TextAlign.center,
                  controller: widget.controllerLive.ctSearch,
                  fontsize: 14,
                  hindtext: "axtar".tr,
                  inputType: TextInputType.text,
                  onTextChange: (s) {
                    searchUsers(s);
                  },
                ),
              )),
          const SizedBox(
            height: 5,
          ),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10,),
                              CustomText(labeltext: "Girisde olan : ${selectedusers.where((e)=>e.lastInoutAction!.outLongitude=="").length}",),
                              const SizedBox(width: 5,),
                              CustomText(labeltext: "Cixis eden : ${selectedusers.where((e)=>e.lastInoutAction!.outLongitude!="").length}",),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(labeltext: "Online : ${selectedusers.where((e)=>e.currentLocation!.isOnline==true).length}",),
                              const SizedBox(width: 5,),
                              CustomText(labeltext: "Offline : ${selectedusers.where((e)=>e.currentLocation!.isOnline==false).length}",),
                              const SizedBox(width: 20,),
                            ],
                          ),
                        ],
                      )),
          Expanded(
            flex: 30,
            child: selectedusers.isNotEmpty?ListView.builder(
                itemCount: selectedusers.length,
                itemBuilder: (context, index) {
                  return WidgetWorkerItemLiveTarck(
                    callBackGunluk: (v){
                      widget.callBackGunluk.call(v);
                    },
                    selectedUser: widget.controllerLive.selectedModel.value,
                    context: context,
                    element: selectedusers.elementAt(index),
                    callBack: widget.callBack,
                  );
                }):NoDataFound(
              title: "melumattapilmadi".tr,
              width: 200,height: 200,),
          )
                ],
              ),
        ));
  }

  void searchUsers(String s) {
    if(s.isEmpty){
      selectedusers=widget.controllerLive.listTrackdata;
    }else{
      selectedusers=widget.controllerLive.listTrackdata.where((e)=>e.userFullName!.toString().toUpperCase().contains(s.toUpperCase())||
          e.userCode!.toUpperCase().contains(s.toUpperCase())).toList();
    }
    setState(() {
    });();
  }

}

class WidgetWorkerItemNotWorkedToday extends StatefulWidget {
  WidgetWorkerItemNotWorkedToday({
    super.key,
    required this.context,
    required this.element,
    required this.callBack,
    required this.loggedUserModel,
  });

  final BuildContext context;
  final ModelLiveTrack element;
  final LoggedUserModel loggedUserModel;
  Function(ModelLiveTrack) callBack;

  @override
  State<WidgetWorkerItemNotWorkedToday> createState() => _WidgetWorkerItemNotWorkedTodayState();
}

class _WidgetWorkerItemNotWorkedTodayState extends State<WidgetWorkerItemNotWorkedToday> {
  bool expandMore=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      if(mounted){
        setState(() {
          expandMore=!expandMore;
        });
      }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child:
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 12,
                        child: CustomText(
                          overflow: TextOverflow.ellipsis,
                          labeltext:
                              "${widget.element.userCode!}-${widget.element.userFullName}",
                          fontsize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: false ? Colors.green : Colors.red,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5)),
                          child: Center(
                              child: CustomText(
                                fontsize: 10,
                            labeltext: false ? "Online" : "Offline",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                      widget.element.lastInoutAction != null? !expandMore?Expanded(
                        flex: 1,
                        child: Icon(Icons.info_rounded,color: Colors.blue.withOpacity(0.9),),
                      ):const SizedBox():const SizedBox(),
                    ],
                  ),
                  widget.element.lastInoutAction != null? expandMore?_widgetMarketInfo(context, widget.element.lastInoutAction!):const SizedBox():const SizedBox(),
                  widget.element.lastInoutAction != null?expandMore?WidgetRuthesabatlar(temsilciKodu: widget.element.userCode!,roleId: widget.element.userPosition!,
                    onClick: (){},height: 100,listP: widget.loggedUserModel.userModel!.permissions!,):const SizedBox():const SizedBox()
                 ],
              )
         ,
      ),
    );
  }

  _widgetMarketInfo(BuildContext context, LastInoutAction selectedModel) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      padding: const EdgeInsets.only(top: 5, left: 10),
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            labeltext: "sonuncuZiyaret",
            fontWeight: FontWeight.w800,
            color: Colors.blue,
          ),
          const SizedBox(
            height: 2,
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext: selectedModel.customerName!,
                  fontsize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext: selectedModel.inDate!.toString().substring(0, 10),
                  fontsize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 0,
          ),
          _widgetInfoZiyaret(selectedModel),
        ],
      ),
    );
  }

  _widgetInfoZiyaret(LastInoutAction selectedModel) {
    return Column(
      children: [
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                    labeltext: "${"girisVaxt".tr} : ",
                    fontsize: 14,
                    fontWeight: FontWeight.w600),
                CustomText(labeltext: " ${selectedModel.inDate.toString()}"),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.social_distance,
                  size: 12,
                ),
                CustomText(labeltext: " ${selectedModel.inDistance}"),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                    labeltext: "${"cixisVaxt".tr} : ",
                    fontsize: 14,
                    fontWeight: FontWeight.w600),
                selectedModel.outDate != null
                    ? CustomText(labeltext: " ${selectedModel.outDate!}")
                    : CustomText(labeltext: "cixisedilmeyib".tr),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            selectedModel.outDate != null
                ? Row(
                    children: [
                      const Icon(
                        Icons.social_distance,
                        size: 12,
                      ),
                      CustomText(labeltext: " ${selectedModel.outDistance}"),
                    ],
                  )
                : const SizedBox()
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                    labeltext: "${"marketdeISvaxti".tr} : ",
                    fontsize: 14,
                    fontWeight: FontWeight.w600),
                CustomText(labeltext: " ${selectedModel.workTimeInCustomer}"),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class WidgetWorkerItemLiveTarck extends StatefulWidget {
  WidgetWorkerItemLiveTarck({
    super.key,
    required this.context,
    required this.element,
    required this.callBack,
    required this.selectedUser,
    required this.callBackGunluk,
  });

  final BuildContext context;
  final ModelLiveTrack element;
  final ModelLiveTrack selectedUser;
  Function(ModelLiveTrack) callBack;
  Function(bool) callBackGunluk;

  @override
  State<WidgetWorkerItemLiveTarck> createState() =>
      _WidgetWorkerItemLiveTarckState();
}

class _WidgetWorkerItemLiveTarckState extends State<WidgetWorkerItemLiveTarck> {
  bool expandMore=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      if(mounted){
        setState(() {
          expandMore=false;
        });
      }
        if (widget.element.currentLocation != null) {
          widget.callBack(widget.element).call();
          Get.back();
        }
      },
      child: Stack(
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: widget.element.currentLocation!.isOnline!
                        ? Colors.grey
                        : Colors.grey,
                    spreadRadius: 0,
                    blurRadius: 3,
                    blurStyle: BlurStyle.outer
                  )
                ],
                  border: Border.all(
                    width: 0.4,
                      color: widget.element.currentLocation!.isOnline!
                          ? Colors.grey
                          : Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10,bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                         Expanded(
                          flex: 1,
                          child:widget.element.currentLocation!.screenState!=
                              "b"? Image.asset(widget.element.currentLocation!.screenState==
                              "off"?"images/screenOff.png":"images/screenUnlock.png",fit: BoxFit.contain,
                          width: 30,height: 45,
                          ):const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                overflow: TextOverflow.ellipsis,
                                labeltext: widget.element.currentLocation
                                        ?.userFullName ??
                                    'melumattapilmadi'.tr,
                                fontsize: 16,
                                maxline: 1,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                  labeltext:widget.element.userPositionName??"melumattapilmadi".tr,
                                  fontsize: 10,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
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
                                              labeltext: "${widget.element.currentLocation!.locAccuracy} m"),
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
                                              labeltext: "${widget.element.currentLocation!.batteryLevel} %"),
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
                                              labeltext: "${widget.element.currentLocation!.speed} m/s"),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      widget.element.currentLocation!.isMoving!?
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
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex:12,
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(padding: const EdgeInsets.all(5),
                                        child: widget.element.lastInoutAction!.outDate!.length>5?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                flex:5,
                                                child: Container(
                                              padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                                              decoration: const BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:BorderRadius.all( Radius.circular(5))
                                              ),
                                              child: CustomText(labeltext: "${"cixisEdilib".tr} : ${widget.element.lastInoutAction!.outDate.toString().substring(11,16)}",),
                                            )),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                                flex:4,
                                                child: calculateOneHour(widget.element.lastInoutAction!.outDate)?CustomText(labeltext: "Yoxlanmalidir",color:Colors.red,fontWeight: FontWeight.w600,):const SizedBox())
                                          ],
                                        ):
                                        Container(
                                          padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                                          decoration: const BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:BorderRadius.all( Radius.circular(5))
                                          ),
                                          child: CustomText(labeltext: "${"marketdedir".tr} : ${widget.element.currentLocation!.inputCustomerDistance!} m",),),
                                      )
                                    ],
                                  )),
                                  Expanded(
                                    flex:3,
                                    child: SizedBox(
                                      height: 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                _expandMore();
                                              },
                                              icon:  Icon(!expandMore?Icons.expand_circle_down_rounded:Icons.expand_less))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  widget.element.lastInoutAction != null
                      ? expandMore?_widgetMarketInfo(
                          context, widget.element.lastInoutAction!):const SizedBox()
                      : const SizedBox()
                ],
              )),
          Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  CustomText(
                      fontsize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      labeltext: widget.element.currentLocation!.locationDate.toString().substring(10,16)),
                 Lottie.asset(widget.element.currentLocation!.isOnline!?"lottie/pointyasil.json":"lottie/pointqirmizi.json",height: 25,filterQuality: FilterQuality.medium,fit: BoxFit.fill),
                ],
              )),
          Positioned(
              top: 10,
              left: 12,
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.all(2),
                child: Center(
                    child: CustomText(
                  labeltext: widget.element.userCode??"",
                  fontsize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
              ))
        ],
      ),
    );
  }

  _widgetMarketInfo(BuildContext context, LastInoutAction selectedModel) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      padding: const EdgeInsets.only(top: 5, left: 10),
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                labeltext: "sonuncuZiyaret",
                fontWeight: FontWeight.w800,
                color: Colors.blue,
              ),
              CustomElevetedButton(
                icon: Icons.visibility,
                textColor: Colors.green,
                  borderColor: Colors.green,
                  height: 20,
                  width: 110,
                  cllback: (){
                    getGunlukHesabat();
                  }, label: "todeyRut".tr)
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext: selectedModel.customerName!,
                  fontsize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext: selectedModel.inDate!.toString().substring(0,10),
                  fontsize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 0,
          ),
          _widgetInfoZiyaret(selectedModel)
        ],
      ),
    );
  }

  _widgetInfoZiyaret(LastInoutAction selectedModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                    labeltext: "${"girisVaxt".tr} : ",
                    fontsize: 14,
                    fontWeight: FontWeight.w600),
                CustomText(labeltext: " ${selectedModel.inDate!.substring(11,16)}"),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.social_distance,
                  size: 12,
                ),
                CustomText(labeltext: " ${selectedModel.inDistance}"),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        widget.element.lastInoutAction!.outDate!.isNotEmpty
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                              labeltext: "${"cixisVaxt".tr} : ",
                              fontsize: 14,
                              fontWeight: FontWeight.w600),
                          selectedModel.outDate != null
                              ? CustomText(
                                  labeltext: " ${selectedModel.outDate!.substring(11,16)}")
                              : CustomText(labeltext: "cixisedilmeyib".tr),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      selectedModel.outDate != null
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.social_distance,
                                  size: 12,
                                ),
                                CustomText(
                                    labeltext: " ${selectedModel.outDistance}"),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                              labeltext: "${"marketdeISvaxti".tr} : ",
                              fontsize: 14,
                              fontWeight: FontWeight.w600),
                          CustomText(
                              labeltext:
                                  " ${selectedModel.workTimeInCustomer}"),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : CustomText(
                labeltext: "Marketden cari uzaqliq : ${widget.element.currentLocation!.inputCustomerDistance!} m")
      ],
    );
  }

  void getGunlukHesabat() {
    widget.callBackGunluk.call(true);
    DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String starDate = "$formattedDate 00:01";
    String endDate = "$formattedDate 23:59";
    Get.toNamed(RouteHelper.screenLiveTrackReport, arguments: [
      widget.element.userPosition!,
      widget.element.userCode,
      starDate,
      endDate
    ]);
  }

  void _expandMore() {
   if(mounted){
     setState(() {
       expandMore = !expandMore;  // Toggle the boolean value
     });
   }
  }


  bool calculateOneHour(String? outDate) {
    if (outDate == null) return false;

    // Özel tarih formatı
    final DateFormat dateFormat = DateFormat("yyyy.MM.dd HH:mm:ss.SSS");

    try {
      // Tarihi parse et
      DateTime dateTimeout = dateFormat.parse(outDate);

      // Şimdiki zaman
      DateTime now = DateTime.now();

      // Zaman farkını hesapla
      Duration difference = now.difference(dateTimeout);

      // 1 saatten fazla mı kontrol et
      return difference.inHours >= 1;
    } catch (e) {
      print("Geçersiz tarih formatı: $e");
      return false;
    }

  }
}
