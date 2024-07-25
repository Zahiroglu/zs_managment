import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/controller_rout_detail_user.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../../hesabatlar/widget_simplechart.dart';

class RoutDetailScreenUsers extends StatefulWidget {
  DrawerMenuController drawerMenuController;

  RoutDetailScreenUsers({required this.drawerMenuController, super.key});

  @override
  State<RoutDetailScreenUsers> createState() => _RoutDetailScreenUsersState();
}

class _RoutDetailScreenUsersState extends State<RoutDetailScreenUsers> {
  ControllerRoutDetailUser controllerRoutDetailUser =
      Get.put(ControllerRoutDetailUser());
  PageController scrollController = PageController();

  @override
  void initState() {
    scrollController.addListener(() {});
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ControllerRoutDetailUser>();
    scrollController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CustomText(
            labeltext: "mercSistem".tr,
            textAlign: TextAlign.center,
            fontsize: 22,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            onPressed: () {
              widget.drawerMenuController.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
        body: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Obx(()=>Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _widgetUmumiInfoPanel(context, Colors.white),
        const SizedBox(height: 20,),
        Expanded(child: ListView.builder(
            itemCount: controllerRoutDetailUser.listMercler.length,
            itemBuilder: (c,index){
              return widgetItemMerc(controllerRoutDetailUser.listMercler.elementAt(index));

            }))
      ],
    ));
  }

  _widgetUmumiInfoPanel(BuildContext context, Color color) {
    double satisFaiz=(controllerRoutDetailUser.listMercler.fold(0.0, (sum, element) => sum + element.user!.totalSelling)/controllerRoutDetailUser.listMercler.fold(0.0, (sum, element) => sum + element.user!.totalPlan)*100);
    double zaymalFaizi=(controllerRoutDetailUser.listMercler.fold(0.0, (sum, element) => sum + element.user!.totalRefund)/controllerRoutDetailUser.listMercler.fold(0.0, (sum, element) => sum + element.user!.totalSelling)*100);
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: color,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer),
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(2, 2),
                    spreadRadius: 0,
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer)
              ],
              // border: Border.all(color: Colors.black,width: 0.2)
            ),
            height: 160,
            child: Padding(
              padding: const EdgeInsets.all(10.0).copyWith(bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "images/workers.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: CustomText(
                        labeltext: "temsilciSayi".tr,
                        fontWeight: FontWeight.normal,
                      )),
                      const Spacer(),
                      CustomText( labeltext: "${controllerRoutDetailUser.listMercler.length} ${"merc".tr}",
                                              fontWeight: FontWeight.bold,
                                            ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                      height: 1, color: Colors.black45, thickness: 0.5),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "images/shopping.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: CustomText(
                        labeltext: "marketSayi".tr,
                        fontWeight: FontWeight.normal,
                      )),
                      const Spacer(),
                      CustomText( labeltext: "${controllerRoutDetailUser.listMercBaza.length} ${"market".tr}",
                                              fontWeight: FontWeight.bold,
                                            ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                      height: 1, color: Colors.black45, thickness: 0.5),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "images/salesplan.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: CustomText(
                        labeltext: "totalPlan".tr,
                        fontWeight: FontWeight.normal,
                      )),
                      const Spacer(),
                      CustomText( labeltext: controllerRoutDetailUser.listMercler.fold(
                                0.0, (sum, element) => sum + element.user!.totalPlan)
                            .toString() +
                        "manatSimbol".tr,
                                              fontWeight: FontWeight.bold,
                                            ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(
                      height: 1, color: Colors.black45, thickness: 0.5),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "images/sales.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomText(
                                                labeltext: "totalSatis".tr,
                                                fontWeight: FontWeight.normal,
                                              ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      CustomText(labeltext: controllerRoutDetailUser.listMercler.fold(0.0, (sum, element) => sum + element.user!.totalSelling).toString() +
                        "manatSimbol".tr,
                                              fontWeight: FontWeight.bold,
                                            ),
                      const SizedBox(width: 5,),
                      Container(
                        padding: EdgeInsets.all(2),
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                          color:satisFaiz<50? Colors.red:satisFaiz<80?Colors.yellowAccent:Colors.green,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Center(
                          child: CustomText(
                            color: Colors.white,
                            labeltext: satisFaiz
                                .toStringAsFixed(1) +
                                "%".tr,
                            fontsize: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                      height: 1, color: Colors.black45, thickness: 0.5),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "images/return.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: CustomText(
                        labeltext: "totalIade".tr,
                        fontWeight: FontWeight.normal,
                      )),
                      const Spacer(),
                      CustomText( labeltext: controllerRoutDetailUser.listMercler.fold(
                                0.0, (sum, element) => sum +
                                    element.user!.totalRefund)
                            .toString() +
                        "manatSimbol".tr,
                                              fontWeight: FontWeight.bold,
                                            ),
                      const SizedBox(width: 5,),
                      Container(
                        padding: EdgeInsets.all(2),
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                            color:zaymalFaizi>2.5? Colors.red:satisFaiz<1?Colors.yellowAccent:Colors.green,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Center(
                          child: CustomText(
                            color: Colors.white,
                            labeltext: zaymalFaizi
                                .toStringAsFixed(1) +
                                "%".tr,
                            fontsize: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  widgetItemMerc(MercDataModel element) {
    double satisFaiz=(element.user!.totalSelling/element.user!.totalPlan)*100;
    double zaymalFaizi=(element.user!.totalRefund /element.user!.totalSelling)*100;
    return InkWell(
      onTap: (){
        Get.toNamed(RouteHelper.screenMercRoutDatail, arguments: [element,controllerRoutDetailUser.listGirisCixis,controllerRoutDetailUser.listUsers]);

      },
      child: Card(
        color: Colors.grey.withOpacity(0.4),
        margin: const EdgeInsets.all(10).copyWith(bottom: 0),
        elevation: 20,
        shadowColor: Colors.grey.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(labeltext: element.user!.name,fontWeight: FontWeight.bold,),
                  CustomText(labeltext: element.user!.code),
                ],
              ),
              CustomText(labeltext: "marketSayi".tr+" : "+element.mercCustomersDatail!.length.toString()),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(5.0).copyWith(bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "images/salesplan.png",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: CustomText(
                                labeltext: "totalPlan".tr,
                                fontWeight: FontWeight.normal,
                              )),
                          const Spacer(),
                          CustomText( labeltext: element.user!.totalPlan
                              .toString() +
                              "manatSimbol".tr,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "images/sales.png",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomText(
                              labeltext: "totalSatis".tr,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          CustomText(
                            labeltext: element.user!.totalSelling.toString() +
                                "manatSimbol".tr,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(width: 5,),
                          Container(
                            padding: EdgeInsets.all(2),
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                                color:satisFaiz<50? Colors.red:satisFaiz<80?Colors.yellowAccent:Colors.green,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Center(
                              child: CustomText(
                                color: Colors.white,
                                labeltext: satisFaiz
                                    .toStringAsFixed(1) +
                                    "%".tr,
                                fontsize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "images/return.png",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: CustomText(
                                labeltext: "totalIade".tr,
                                fontWeight: FontWeight.normal,
                              )),
                          const Spacer(),
                          CustomText(
                            labeltext:
                                    element.user!.totalRefund
                                .toString() +
                                "manatSimbol".tr,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(width: 5,),
                          Container(
                            padding: EdgeInsets.all(2),
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                                color:zaymalFaizi>2.5? Colors.red:satisFaiz<1?Colors.yellowAccent:Colors.green,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Center(
                              child: CustomText(
                                color: Colors.white,
                                labeltext: zaymalFaizi
                                    .toStringAsFixed(1) +
                                    "%".tr,
                                fontsize: 8,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
