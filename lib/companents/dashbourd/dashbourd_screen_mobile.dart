import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/main_screen/drawer/model_drawerItems.dart';

import '../../widgets/custom_eleveted_button.dart';
import '../../widgets/custom_responsize_textview.dart';
import 'controllers/controller_dashbourd_exp.dart';

class DashborudScreenMobile extends StatefulWidget {
  DrawerMenuController drawerMenuController;
  DashborudScreenMobile({required this.drawerMenuController,super.key});

  @override
  State<DashborudScreenMobile> createState() => _DashborudScreenMobileState();
}

class _DashborudScreenMobileState extends State<DashborudScreenMobile> {
  ControllerDashBorudExp controllerDashBorudExp=Get.put(ControllerDashBorudExp());
  var _scrollControllerNested;

  @override
  void dispose() {
    Get.delete<ControllerDashBorudExp>();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerDashBorudExp>(builder: (contoller){return Material(
      child:  Scaffold(
          body: NestedScrollView(
            controller: _scrollControllerNested,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                Obx(() => SliverSafeArea(
                  sliver: SliverAppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    centerTitle: false,
                    expandedHeight: 270,
                    pinned: true,
                    floating: false,
                    stretch: true,
                    actions: [],
                    title: SizedBox(),
                    leading: IconButton(
                      icon: Icon(Icons.menu),onPressed:_openDrawer,
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.blurBackground],
                      background:  Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        decoration:  BoxDecoration(
                            color: Colors.blue.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.4),
                                  offset: const Offset(2,2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  blurStyle: BlurStyle.normal
                              )
                            ],
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            contoller.getUserInfoField(context),
                            Padding(
                              padding: const EdgeInsets.all(8.0).copyWith(top: 5),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    border: Border.all(color: Colors.black.withOpacity(0.2),width: 0.2),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0).copyWith(top: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex:5,
                                                child: CustomText(labeltext: "fodgetToStop".tr,maxline: 2,fontWeight: FontWeight.w600,)),
                                            Expanded(
                                                flex:3,
                                                child: CustomElevetedButton(
                                                    textColor: Colors.blueAccent,
                                                    borderColor: Colors.blue,
                                                    icon: Icons.work_off,
                                                    height: 35,
                                                    cllback: (){
                                                      controllerDashBorudExp.stopTodayWork();

                                                    }, label: "stopWork"))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: MediaQuery.of(context).size.width,),
                                      const Positioned(
                                          top: 0,
                                          right: -1,
                                          child: Icon(Icons.info,size: 18,color: Colors.red,))
                                    ],
                                  ),
                                ),
                              ),
                            )

                            // getDownloadMenu(context),
                          ],
                        ),
                      ),
                      collapseMode: CollapseMode.values[0],
                      centerTitle: true,
                    ),
                    // bottom: PreferredSize(
                    //     preferredSize: const Size.fromHeight(70),
                    //     child: ColoredBox(
                    //       color: Colors.white,
                    //       child:  contoller.widgetHesabatlar(context),
                    //     )),
                  ),
                ))
              ];
            },
            body:  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.65,
              decoration: const BoxDecoration(
                  color: Colors.white60
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    contoller.widgetHesabatlar(context),
                    contoller.widgetGunlukGirisCixislar(context),
                    const SizedBox(height: 20,),
                    contoller.widgetInfoEnter(context),
                  ],
                ),
              ),
            ),
          ),
        )
      );});

    }

  Widget getDownloadMenu(BuildContext context) {
    return Obx(() => controllerDashBorudExp.screenLoading.isFalse
        ? Padding(
      padding: const EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  border: Border.all(color: Colors.grey, width: 0.2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 2),
                        child: CustomText(
                            labeltext: "${"umuYensay".tr} : ${controllerDashBorudExp.listDonwloads.length}",
                            fontsize: 14),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 2),
                        child: CustomText(
                          labeltext: "${"umuYenmelisay".tr} : ${controllerDashBorudExp.listDonwloads.where((element) => element.musteDonwload==true).toList().length}",
                          fontsize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      iconSize: 35,
                      onPressed: () {
                        _changePageToDownloads();
                      },
                      icon: Icon(Icons.refresh))
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        )));
  }


  void _openDrawer() {
    widget.drawerMenuController.openDrawer();
    setState(() {
    });
  }

  void _changePageToDownloads() {
    SelectionButtonData buttondownloads = SelectionButtonData(
        icon: Icons.upcoming,
        label: "dovnloads".tr,
        activeIcon: Icons.upcoming_outlined,
        totalNotif: 0,
        statickField: false,
        isSelected: false,
        codename: "down");
    widget.drawerMenuController.changeSelectedIndex(2, buttondownloads, false);
    setState(() {});
  }



}
