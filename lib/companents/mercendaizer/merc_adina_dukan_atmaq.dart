import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/dialog_select_simpleuser_select.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

import '../login/services/api_services/users_controller_mobile.dart';

class ScreenMercAdinaMusteriEalveEtme extends StatefulWidget {
  ModelCariler modelCari;
  List<UserModel> listUsers;
  AvailableMap availableMap;
  ScreenMercAdinaMusteriEalveEtme({required this.modelCari,required this.listUsers,required this.availableMap,super.key});

  @override
  State<ScreenMercAdinaMusteriEalveEtme> createState() => _ScreenMercAdinaMusteriEalveEtmeState();
}

class _ScreenMercAdinaMusteriEalveEtmeState extends State<ScreenMercAdinaMusteriEalveEtme> {
  UserModel selectedMerc=UserModel();
  bool rutGunuBir = false;
  bool rutGunuIki = false;
  bool rutGunuUc = false;
  bool rutGunuDort = false;
  bool rutGunuBes = false;
  bool rutGunuAlti = false;
  TextEditingController ctPlan=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    ctPlan.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(labeltext: widget.modelCari.name!),
        ),
        body: _body(),
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0).copyWith(top: 0,left: 5,right: 5,bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                  child: CustomText(
                    labeltext: "cariMelumatlar".tr,
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                customersListItems(widget.modelCari),
              ],
            ),
          ),
          _infoMerc(context),
          const SizedBox(height: 5,),
          _widgetPlanAdd(context),
          const SizedBox(height: 10,),
          widgetRutGunleri(context),
        ],
      ),
    );
  }

  Widget customersListItems(ModelCariler element) {
    int valuMore = 0;
    if (element.day1.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.day2.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.day3.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.day4.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.day5.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.day6.toString() == "1") {
      valuMore = valuMore + 1;
    }
    return Card(
        elevation: 5,
        color: Get.isDarkMode ? Colors.black : Colors.white,
        margin: const EdgeInsets.all(10).copyWith(top: 3),
        shadowColor: Colors.blue,
        borderOnForeground: true,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 15, left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    fontsize: 18,
                    labeltext: element.name!,
                    fontWeight: FontWeight.w600,
                    maxline: 2,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(
                        labeltext: "${"Rut gunu".tr} : ",
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        height: valuMore > 4 ? 60 : 25,
                        width: 250,
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: [
                            element.day1.toString() == "1"
                                ? WidgetRutGunu(rutGunu: "gun1".tr)
                                : const SizedBox(),
                            element.day2.toString() == "1"
                                ? WidgetRutGunu(rutGunu: "gun2".tr)
                                : const SizedBox(),
                            element.day3.toString() == "1"
                                ? WidgetRutGunu(rutGunu: "gun3".tr)
                                : const SizedBox(),
                            element.day4.toString() == "1"
                                ? WidgetRutGunu(rutGunu: "gun4".tr)
                                : const SizedBox(),
                            element.day5.toString() == "1"
                                ? WidgetRutGunu(rutGunu: "gun5".tr)
                                : const SizedBox(),
                            element.day6.toString() == "1"
                                ? WidgetRutGunu(rutGunu: "gun6".tr)
                                : const SizedBox(),
                            element.day7.toString() == "1"
                                ? WidgetRutGunu(rutGunu: "bagli".tr)
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(
                        labeltext: "${"sahe".tr} : ",
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        labeltext: element.area!+" kv",
                        fontWeight: FontWeight.w600,
                      ),


                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(
                        labeltext: "${"kateq".tr} : ",
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        labeltext: element.category!,
                        fontWeight: FontWeight.w600,
                      ),


                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: element.action == false
                          ? Colors.red
                          : Colors.green),
                  child: element.orderNumber == 0
                      ? const SizedBox()
                      : Center(
                      child: CustomText(
                        labeltext: element.orderNumber.toString() ?? "0",
                        color: Colors.white,
                      )),
                )),
            Positioned(
                right: 5,
                top: 2,
                child: Row(
                  children: [
                    CustomText(labeltext: element.code!, fontsize: 10),
                    const SizedBox(width: 5,),
                    InkWell(
                        onTap: () {
                          Get.toNamed(
                              RouteHelper.getwidgetScreenMusteriDetail(),
                              arguments: [
                                element,
                                widget.availableMap
                              ]);
                        },
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 32,
                        )),
                  ],
                ))
          ],
        ));
  }


  Widget _infoMerc(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.dialog(DialogSimpleUserSelect(
          selectedUserCode: selectedMerc.code.toString(),
          getSelectedUse:  (selectedUser) {
            setState(() {
              selectedMerc.code=selectedUser.code;
              selectedMerc.name=selectedUser.name;
            });
          },
          listUsers: widget.listUsers,
          vezifeAdi: "Mercendaizerler",
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0).copyWith(left: 10),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                  child: CustomText(
                    labeltext: "mercBaglanti".tr,
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5,top: 5,bottom: 5),
                  margin: const EdgeInsets.all(10).copyWith(top: 5),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).cardColor,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0,0),
                            color:Colors.blue,
                            blurRadius: 5,
                            spreadRadius: 1,
                          blurStyle: BlurStyle.outer
                        )
                      ]
                  ),
                  child: selectedMerc.code.toString()!="null"? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(labeltext: "rutKod".tr+ " : "),
                          CustomText(labeltext: selectedMerc.code!??"Merc teyin et",fontWeight: FontWeight.w700,),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "merc".tr+ " : "),
                          CustomText(labeltext: selectedMerc.name!,fontWeight: FontWeight.w700,),
                        ],
                      ),
                    ],
                  ):Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CustomText(labeltext: "mercTeyinet".tr,fontsize: 18,)],),
                )
              ],
            ),
            Positioned(
                top: 5,
                right: -0,
                child: IconButton(
                  iconSize: 32,
                  onPressed: (){
                    Get.dialog(DialogSimpleUserSelect(
                      selectedUserCode:selectedMerc.code!,
                      getSelectedUse:  (selectedUser) {
                        setState(() {
                          selectedMerc.code=selectedUser.code;
                          selectedMerc.name=selectedUser.name;
                        });
                      },
                      listUsers: widget.listUsers,
                      vezifeAdi: "Mercendaizerler",
                    ));
                  },
                  icon: const Icon(Icons.change_circle,color: Colors.green,),
                ))

          ],
        ),
      ),
    );
  }

  Widget widgetRutGunleri(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0).copyWith(left: 0,bottom: 5),
            child: CustomText(
                labeltext: "rutmelumat",
                fontsize: 16,
                fontWeight: FontWeight.w700),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(2,2),
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 2
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
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

  Widget _widgetPlanAdd(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0).copyWith(left: 20,top: 5),
          child: CustomText(
            labeltext: "cayPlan".tr,
            fontsize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 15,right: 10),
          child: Column(
            children: [
             SizedBox(
                 child: CustomTextField(
                     isImportant: true,
                     controller: ctPlan, inputType: TextInputType.number, hindtext: "plan".tr, fontsize: 18,obscureText: false,hintTextColor: Colors.grey,align: TextAlign.center),
             height: 60,width: MediaQuery.of(context).size.width,)
            ],
          ),
        ),
      ],
    );
  }

}
