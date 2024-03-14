import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';

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
                    expandedHeight: 250,
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
                        height: 280,
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
                            contoller.getDownloadMenu(context),
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

  void _openDrawer() {
    widget.drawerMenuController.openDrawer();
    setState(() {
    });
  }


}
