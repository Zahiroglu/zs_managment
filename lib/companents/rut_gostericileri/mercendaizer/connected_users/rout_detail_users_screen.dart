import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/controller_rout_detail_user.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';

import '../../../hesabatlar/user_hesabatlar/useruzre_hesabatlar.dart';

class RoutDetailScreenUsers extends StatefulWidget {
  DrawerMenuController drawerMenuController;

  RoutDetailScreenUsers({required this.drawerMenuController, super.key});

  @override
  State<RoutDetailScreenUsers> createState() => _RoutDetailScreenUsersState();
}

class _RoutDetailScreenUsersState extends State<RoutDetailScreenUsers> {
  ControllerRoutDetailUser controllerRoutDetailUser = Get.put(ControllerRoutDetailUser());
  MercDataModel selectedMerc=MercDataModel();
  bool itemExpended=false;
  ScrollController scrollController=ScrollController(initialScrollOffset: 0,keepScrollOffset: true);
  TextEditingController ctSearch=TextEditingController();
  bool searchModeAktiv=false;
  bool hasEndList=false;
  @override
  void initState() {
    scrollController=ScrollController();
    // scrollController.addListener((){
    //   if (scrollController.position.pixels == 0.0) {
    //     setState(() {
    //       hasEndList=false;
    //     });
    //   }else{
    //     setState(() {
    //       hasEndList=true;
    //     });
    //   }
    // });
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
          centerTitle: false,
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
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(onPressed: (){
            controllerRoutDetailUser.createDialogTogetExpCode(context);
          }, icon: const Icon(Icons.add_business,color: Colors.blue,)),
            IconButton(onPressed: (){
              setState(() {
                searchModeAktiv=!searchModeAktiv;
                ctSearch.text="";
                if(!searchModeAktiv){
                  controllerRoutDetailUser.changeSearchValue("");
                }
              });
          }, icon:  Icon(searchModeAktiv?Icons.search_off:Icons.search))
          ],
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
        searchModeAktiv?_widhetSearchMode():hasEndList?const SizedBox():_widgetUmumiInfoPanel(context, Colors.white),
        const SizedBox(height: 10,),
        Expanded(child: ListView.builder(
          controller: scrollController,
            shrinkWrap: true,
            itemCount: controllerRoutDetailUser.listFilteredMerc.length,
            itemBuilder: (c,index){
              return widgetItemMerc(controllerRoutDetailUser.listFilteredMerc.elementAt(index));

            }))
      ],
    ));
  }

  _widhetSearchMode(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 50,
      child: CustomTextField(
        fontsize: 14,
        controller: ctSearch,
        inputType: TextInputType.text,
        hindtext: "axtar".tr,
        align: TextAlign.center,
        onTextChange: (ckarakter){
          controllerRoutDetailUser.changeSearchValue(ckarakter);
        },
      ),
    );
  }

  _widgetUmumiInfoPanel(BuildContext context, Color color) {
    double satisFaiz=(controllerRoutDetailUser.listFilteredMerc.fold(0.0, (sum, element) => sum + element.user!.totalSelling)/controllerRoutDetailUser.listFilteredMerc.fold(0.0, (sum, element) => sum + element.user!.totalPlan)*100);
    double zaymalFaizi=(controllerRoutDetailUser.listFilteredMerc.fold(0.0, (sum, element) => sum + element.user!.totalRefund)/controllerRoutDetailUser.listFilteredMerc.fold(0.0, (sum, element) => sum + element.user!.totalSelling)*100);
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25).copyWith(top: 5),
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
                      CustomText( labeltext: "${controllerRoutDetailUser.listFilteredMerc.length} ${"merc".tr}",
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
                      CustomText( labeltext: controllerRoutDetailUser.listFilteredMerc.fold(
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
                      CustomText(labeltext: controllerRoutDetailUser.listFilteredMerc.fold(0.0, (sum, element) => sum + element.user!.totalSelling).toString() +
                        "manatSimbol".tr,
                                              fontWeight: FontWeight.bold,
                                            ),
                      const SizedBox(width: 5,),
                      Container(
                        padding: const EdgeInsets.all(2),
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                          color:satisFaiz<50? Colors.red:satisFaiz<80?Colors.yellowAccent:Colors.green,
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(Radius.circular(10))
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
                      CustomText( labeltext: controllerRoutDetailUser.listFilteredMerc.fold(
                                0.0, (sum, element) => sum +
                                    element.user!.totalRefund)
                            .toString() +
                        "manatSimbol".tr,
                                              fontWeight: FontWeight.bold,
                                            ),
                      const SizedBox(width: 5,),
                      Container(
                        padding: const EdgeInsets.all(2),
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                            color:zaymalFaizi>2.5? Colors.red:satisFaiz<1?Colors.yellowAccent:Colors.green,
                            border: Border.all(color: Colors.black),
                            borderRadius: const BorderRadius.all(Radius.circular(10))
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
    double totalPrim=0;
    if(element.motivationData!.byNetSales!=null){
      totalPrim=element.motivationData!.byNetSales!+element.motivationData!.byPlan!
          +element.motivationData!.byWasteProduct!;
    }
    double satisFaiz=(element.user!.totalSelling/element.user!.totalPlan)*100;
    double zaymalFaizi=(element.user!.totalRefund /element.user!.totalSelling)*100;
    Color color=Colors.white;
    Color textColors=Colors.black;
    // switch(satisFaiz){
    //   case >=15:
    //     color=Colors.green;
    //     textColors=Colors.white;
    //     break;
    //   case >=10:
    //     color=Colors.lightBlue;
    //     textColors=Colors.white;
    //     break;
    //   case >=80:
    //     color=Colors.white;
    //     textColors=Colors.black;
    //     break;
    // }
    return Padding(
      padding: const EdgeInsets.all(1),
      child: InkWell(
        focusColor: Colors.transparent,
        onTap: (){
         _changeInfoSetting(element);
         },
        child: Card(
          color: color,
          margin: const EdgeInsets.all(10).copyWith(bottom: 5),
          elevation: 20,
          shadowColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(labeltext: element.user!.name,fontWeight: FontWeight.bold,color: textColors,fontsize: 16,),
                    itemExpended&&selectedMerc==element? Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: totalPrim >= 0
                                ? Colors.green
                                : Colors.red),
                        child: Center(
                          child: CustomText(
                            labeltext:
                            "${totalPrim.toStringAsFixed(2)} ${"manatSimbol".tr}",
                            fontWeight: FontWeight.bold,
                          ),
                        )):CustomText(labeltext: element.user!.code,color: textColors,),
                  ],
                ),
                itemExpended&&selectedMerc==element?CustomText(labeltext: "motivasiya".tr,fontsize: 14,fontWeight: FontWeight.bold,)
                    :CustomText(labeltext: "${"marketSayi".tr} : ${element.mercCustomersDatail!.length}",color: textColors,),
                itemExpended&&selectedMerc==element?widgetItemMotivation(element,textColors):Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  height: 80,
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
                                  fontWeight: FontWeight.normal,color: textColors,
                                )),
                            const Spacer(),
                            CustomText( labeltext: element.user!.totalPlan
                                .toString() +
                                "manatSimbol".tr,color: textColors,
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
                                fontWeight: FontWeight.normal
                                ,color: textColors,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            CustomText(
                              labeltext: element.user!.totalSelling.toString() +
                                  "manatSimbol".tr,
                              fontWeight: FontWeight.bold
                              ,color: textColors,
                            ),
                            const SizedBox(width: 5,),
                            Container(
                              padding: const EdgeInsets.all(2),
                              height: 20,
                              width: 40,
                              decoration: BoxDecoration(
                                  color:satisFaiz<50? Colors.red:satisFaiz<80?Colors.yellowAccent:Colors.green,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(Radius.circular(10))
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
                                  fontWeight: FontWeight.normal
                                  ,color: textColors,
                                )),
                            const Spacer(),
                            CustomText(
                              labeltext:
                                      element.user!.totalRefund
                                  .toString() +
                                  "manatSimbol".tr
                                ,color: textColors,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(width: 5,),
                            Container(
                              padding: const EdgeInsets.all(2),
                              height: 20,
                              width: 40,
                              decoration: BoxDecoration(
                                  color:zaymalFaizi>2.5? Colors.red:satisFaiz<1?Colors.yellowAccent:Colors.green,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(Radius.circular(10))
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
                SizedBox(height: itemExpended&&selectedMerc==element?5:10,),
                AnimatedContainer(
                    height: itemExpended&&selectedMerc==element?150:0,
                    color: Colors.white,
                    duration: const Duration(milliseconds: 400),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          WidgetRuthesabatlar(height: 100,onClick: (){},roleId:"23",temsilciKodu: element.user!.code,)
                        ],
                      ),
                    )),
                SizedBox(height: itemExpended&&selectedMerc==element?10:0,),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeInfoSetting(MercDataModel element) {
    setState(() {
      if(itemExpended){
        if(selectedMerc==element){
        itemExpended=false;
        }
      }else{
        itemExpended=true;
       // scrollController.animateTo(300+MediaQuery.of(context).size.height/2, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      }
      selectedMerc=element;
    });
  }

  widgetItemMotivation(MercDataModel element,Color textColors) {

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)
      ),
      height: 95,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
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
                      CustomText( labeltext: element.user!.totalPlan
                          .toString() +
                          "manatSimbol".tr,color: textColors,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  const Spacer(),
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
                        width: 20,
                      ),
                      CustomText(
                        labeltext: element.user!.totalSelling.toString() +
                            "manatSimbol".tr,
                        fontWeight: FontWeight.bold
                        ,color: textColors,
                      ),
                    ],
                  ),
                  const Spacer(),
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
                      CustomText(
                        labeltext:
                        element.user!.totalRefund
                            .toString() +
                            "manatSimbol".tr
                        ,color: textColors,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const Spacer(),


                ],
              ),
              const SizedBox(height: 2,),
              const Divider(height: 1,color: Colors.grey,),
              const SizedBox(height: 2,),
             Padding(
               padding: const EdgeInsets.only(left: 5,right: 10),
               child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(
                         flex: 5,
                         child: Row(
                           children: [
                             CustomText(
                               labeltext: "netSatisdan".tr,
                               fontWeight: FontWeight.w700,
                               color: Colors.grey,),
                             const SizedBox(
                               width: 5,
                             ),
                             CustomText(
                                 labeltext:
                                 element.motivationData!.byNetSales!=null?"${element.motivationData!.byNetSales!.toStringAsFixed(2)} ${"manatSimbol".tr}":""),
                           ],
                         ),
                       ),
                     ],
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(
                         flex: 6,
                         child: Row(
                           children: [
                             CustomText(
                                 labeltext: "plandan".tr,
                                 color: Colors.grey,
                                 fontWeight: FontWeight.w700),
                             const SizedBox(
                               width: 5,
                             ),
                             CustomText(labeltext:element.motivationData!.byPlan!=null?"${element.motivationData!.byPlan!.toStringAsFixed(2)} ${"manatSimbol".tr}":""),
                           ],
                         ),
                       ),
                       Expanded(
                         flex: 5,
                         child: Row(
                           children: [
                             CustomText(
                                 labeltext: "planFaizle".tr,
                                 color: Colors.grey,
                                 fontWeight: FontWeight.w700),
                             const SizedBox(
                               width: 5,
                             ),
                             CustomText(labeltext:element.motivationData!.planPercent!=null?"${element.motivationData!.planPercent!.toStringAsFixed(2)} %":""),
                           ],
                         ),
                       ),
                     ],
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(
                         flex: 6,
                         child: Row(
                           children: [
                             CustomText(
                                 color: Colors.grey,
                                 labeltext: "zayMaldan".tr,
                                 fontWeight: FontWeight.w700),
                             const SizedBox(
                               width: 5,
                             ),
                             CustomText(
                                 labeltext:element.motivationData!.byWasteProduct!=null?"${element.motivationData!.byWasteProduct!.toStringAsFixed(2)} ${"manatSimbol".tr}":""),
                           ],
                         ),
                       ),
                       Expanded(
                         flex: 5,
                         child: Row(
                           children: [
                             CustomText(
                                 color: Colors.grey,
                                 labeltext: "zaymalFaizle".tr,
                                 fontWeight: FontWeight.w700),
                             const SizedBox(
                               width: 5,
                             ),
                             CustomText(
                                 labeltext:element.motivationData!.wasteProductPercent!=null?"${element.motivationData!.wasteProductPercent!} %":""),
                           ],
                         ),
                       ),
                     ],
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
}
