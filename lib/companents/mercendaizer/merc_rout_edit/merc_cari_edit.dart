import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/model_mercbaza.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_dialog/dialog_select_user_connections.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/dialog_select_simpleuser_select.dart';

class ScreenMercCariEdit extends StatefulWidget {
  MercCustomersDatail modelMerc;
  List<UserModel> listUsers;
  String mercKod;
  String mercAd;

  ScreenMercCariEdit(
      {required this.modelMerc, required this.listUsers,required this.mercAd,required this.mercKod, super.key});

  @override
  State<ScreenMercCariEdit> createState() => _ScreenMercCariEditState();
}

class _ScreenMercCariEditState extends State<ScreenMercCariEdit> {
  List<User> listUsers=[];
  String selectedMercKod="";
  String selectedMercAd="";
  late MercCustomersDatail modelMerc;
  bool rutGunuBir = false;
  bool rutGunuIki = false;
  bool rutGunuUc = false;
  bool rutGunuDort = false;
  bool rutGunuBes = false;
  bool rutGunuAlti = false;

  @override
  void initState() {
    for (var element in widget.listUsers) {
      listUsers.add( User(
          code: element.code,
          roleId: element.roleId,
          roleName: element.roleName,
          fullName: element.name,
        isSelected: element.code==widget.modelMerc.code,
      ));

    }
    modelMerc=widget.modelMerc;
    rutGunuBir = modelMerc.days.any((element) => element.day==1);
    rutGunuIki = modelMerc.days.any((element) => element.day==2);
    rutGunuUc = modelMerc.days.any((element) => element.day==3);
    rutGunuDort = modelMerc.days.any((element) => element.day==4);
    rutGunuBes = modelMerc.days.any((element) => element.day==5);
    rutGunuAlti = modelMerc.days.any((element) => element.day==6);
    selectedMercKod=widget.mercKod;
    selectedMercAd=widget.mercAd;
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Scaffold(
      appBar: AppBar(
        title: CustomText(labeltext: widget.modelMerc.name),
      ),
      body: _body(context),
    )));
  }

  _body(BuildContext context) {
    return Column(
      children: [
        _infoMerc(context),
       _infoPlan(context),
        widgetRutGunleri(context),
      ],
    );
  }

  Widget _infoMerc(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.dialog(DialogSimpleUserSelect(
          selectedUserCode: widget.modelMerc.code,
          getSelectedUse:  (selectedUser) {
            setState(() {
              modelMerc.code=selectedUser.code!;
              modelMerc.name=selectedUser.name!;
            });
          },
          listUsers: widget.listUsers,
          vezifeAdi: "mercler".tr,
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
                      color: Colors.grey.shade200,
                      boxShadow: const [
                      BoxShadow(
                        offset: Offset(2,2),
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(labeltext: "${"rutKod".tr} : "),
                          CustomText(labeltext: modelMerc.code,fontWeight: FontWeight.w700,),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"merc".tr} : "),
                          CustomText(labeltext: modelMerc.name,fontWeight: FontWeight.w700,),
                        ],
                      ),
                    ],
                  ),
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
                      selectedUserCode: selectedMercKod,
                      getSelectedUse:  (selectedUser) {
                        setState(() {
                          selectedMercKod=selectedUser.code!;
                          selectedMercAd=selectedUser.name!;
                        });
                      },
                      listUsers: widget.listUsers,
                      vezifeAdi: "mercler".tr
                    ));
                  },
                  icon: const Icon(Icons.change_circle,color: Colors.green,),
                ))

          ],
        ),
      ),
    );
  }

  Widget _infoPlan(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0).copyWith(left: 10,top: 10,bottom: 5,right: 10),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                child: CustomText(
                  labeltext: "plan".tr,
                  fontsize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey)
                ),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                        color: Colors.grey.withOpacity(0.3)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0).copyWith(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Row(
                            children: [
                              CustomText(labeltext: "plan".tr+" : "),
                              CustomText(labeltext: modelMerc.totalPlan.toString())
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(labeltext: "satis".tr+" : "),
                              CustomText(labeltext: modelMerc.totalSelling.toString())
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(labeltext: "zaymal".tr+" : "),
                              CustomText(labeltext: modelMerc.totalRefund.toString())
                            ],
                          )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: modelMerc.sellingDatas.length*110,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: modelMerc.sellingDatas.length,
                          itemBuilder: (c, index) {
                            return widgetSatisDetal( modelMerc.sellingDatas.elementAt(index));
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  widgetSatisDetal(SellingData element) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 5,right: 10,left: 10,bottom: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    CustomText(labeltext: "${"expeditor".tr} : ",fontWeight: FontWeight.w700),
                    CustomText(labeltext: element.forwarderCode),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"plan".tr} : ", fontsize: 14,fontWeight: FontWeight.w700),
                                  CustomText(
                                      labeltext:
                                      "${element.plans} ${"manatSimbol".tr}",
                                      fontsize: 14),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"satis".tr} : ", fontsize: 14,fontWeight: FontWeight.w700),
                                  CustomText(
                                      labeltext:
                                      "${element.selling} ${"manatSimbol".tr}",
                                      fontsize: 14),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"zaymal".tr} : ", fontsize: 14,fontWeight: FontWeight.w700),
                                  CustomText(
                                      labeltext:
                                      "${element.refund} ${"manatSimbol".tr}",
                                      fontsize: 14),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                height: 50,
                child: CustomElevetedButton(
              label: "Plan deyis",
              cllback: (){},
                  elevation: 5,
              icon: Icons.edit,
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
                color: Colors.grey.shade200,
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

}
