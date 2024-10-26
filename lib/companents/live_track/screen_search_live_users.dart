import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:intl/intl.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';
import '../../widgets/custom_text_field.dart';
import 'model/model_live_track.dart';

class SearchLiveUsers extends StatelessWidget {
  ModelLiveTrack selectedUser;
  List<ModelLiveTrack> listUsers;
  Function(ModelLiveTrack) callBack;

  SearchLiveUsers({required this.listUsers, required this.callBack,required this.selectedUser, super.key});

  TextEditingController ctSearch = TextEditingController();

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
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CustomTextField(
                  containerHeight: 40,
                  suffixIcon: Icons.search_outlined,
                  align: TextAlign.center,
                  controller: ctSearch,
                  fontsize: 14,
                  hindtext: "axtar".tr,
                  inputType: TextInputType.text,
                  onTextChange: (s) {
                    //searchUsers(s);
                  },
                ),
              )),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 20,
            child: listUsers.isNotEmpty?ListView.builder(
                itemCount: listUsers.length,
                itemBuilder: (context, index) {
                  return WidgetWorkerItemLiveTarck(
                    selectedUser: selectedUser,
                    context: context,
                    element: listUsers.elementAt(index),
                    callBack: callBack,
                  );
                }):NoDataFound(
              title: "melumattapilmadi".tr,
              width: 200,height: 200,),
          )
                ],
              ),
        ));
  }
}

class WidgetWorkerItemNotWorkedToday extends StatelessWidget {
  WidgetWorkerItemNotWorkedToday({
    super.key,
    required this.context,
    required this.element,
    required this.callBack,
  });

  final BuildContext context;
  final ModelLiveTrack element;
  Function(ModelLiveTrack) callBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (element.currentLocation != null) {
          callBack(element).call;
          Get.back();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: element.lastInoutAction != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: CustomText(
                          overflow: TextOverflow.ellipsis,
                          labeltext:
                              "${element.userCode!}-${element.userFullName}",
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
                            labeltext: false ? "Online" : "Offline",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                    ],
                  ),
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
                  _widgetMarketInfo(context, element.lastInoutAction!)
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        overflow: TextOverflow.ellipsis,
                        labeltext:
                            "${element.userCode??""}-${element.userFullName??""}",
                        fontsize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ],
              ),
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
          _widgetInfoZiyaret(selectedModel)
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
  });

  final BuildContext context;
  final ModelLiveTrack element;
  final ModelLiveTrack selectedUser;
  Function(ModelLiveTrack) callBack;

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
       setState(() {
         expandMore=false;
       });
        if (widget.element.currentLocation != null) {
          widget.callBack(widget.element).call;
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
                        ? Colors.green
                        : Colors.red,
                    spreadRadius: 0,
                    blurRadius: 3,
                    blurStyle: BlurStyle.outer
                  )
                ],
                  border: Border.all(

                    width: 0.4,
                      color: widget.element.currentLocation!.isOnline!
                          ? Colors.green
                          : Colors.red),
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
                        const Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Icon(Icons.person),
                              // child: Image.network(
                              //   "https://st2.depositphotos.com/1570716/8433/i/950/depositphotos_84330370-stock-photo-portrait-of-a-smart-young.jpg",
                              //   fit: BoxFit.cover, // Ensures the image fills the circular avatar
                              //   width: double.infinity, // Ensures the image fits inside the CircleAvatar
                              //   height: double.infinity,
                              // ),
                            ),
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
                                    'Melumat tapilmadi',
                                fontsize: 16,
                                maxline: 1,
                                fontWeight: FontWeight.bold,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                            labeltext:widget.element.userPositionName??"Bilinmir",
                                            fontsize: 12,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600),
                                        Row(
                                          children: [
                                            CustomText(
                                                labeltext:
                                                    "${"sonYenilenme".tr} : ",
                                                fontsize: 12,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600),
                                            CustomText(
                                                fontsize: 12,
                                                color: Colors.black87,
                                                labeltext: widget
                                                    .element
                                                    .currentLocation!
                                                    .locationDate
                                                    .toString()
                                                    .substring(10, 16)),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                                color: Colors.black87,
                                                labeltext: "${"surret".tr} : ",
                                                fontsize: 12,
                                                fontWeight: FontWeight.w600),
                                            CustomText(
                                                fontsize: 12,
                                                color: Colors.black87,
                                                labeltext:
                                                    "${widget.element.currentLocation!.speed} km"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
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
              top: 2,
              right: 2,
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: widget.element.currentLocation!.isOnline!
                        ? Colors.green
                        : Colors.red,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)),
                child: Center(
                    child: CustomText(
                  labeltext: widget.element.currentLocation!.isOnline!
                      ? "Online"
                      : "Offline",
                  fontsize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
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
                  }, label: "Gunluk hesabat")
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
                  fontsize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext: selectedModel.inDate!.toString(),
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
                                  labeltext: " ${selectedModel.outDate!}")
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
    DateTime now = DateTime.now();
    int day = now.weekday;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String starDate = "$formattedDate 00:01";
    String endDate = "$formattedDate 23:59";
    Get.toNamed(RouteHelper.screenLiveTrackReport, arguments: [
      int.parse(widget.element.userPosition!),
      widget.element.userCode,
      day,
      starDate,
      endDate
    ]);
  }

  void _expandMore() {
    setState(() {
      expandMore = !expandMore;  // Toggle the boolean value
    });
  }
}
