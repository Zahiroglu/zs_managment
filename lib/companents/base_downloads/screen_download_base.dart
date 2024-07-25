import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/base_downloads/models/model_downloads.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import 'controller_base_downloads.dart';

class ScreenBaseDownloads extends StatefulWidget {
  bool fromFirstScreen;
  DrawerMenuController drawerMenuController;

  ScreenBaseDownloads({required this.fromFirstScreen,required this.drawerMenuController, super.key});

  @override
  State<ScreenBaseDownloads> createState() => _ScreenBaseDownloadsState();
}

class _ScreenBaseDownloadsState extends State<ScreenBaseDownloads> {
  ControllerBaseDownloads controllerBaseDownloads = Get.put(ControllerBaseDownloads());


  @override
  void dispose() {
    Get.delete<ControllerBaseDownloads>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(

      child: SafeArea(
        child: GetBuilder<ControllerBaseDownloads>(builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              centerTitle: true,
              title: CustomText(
                labeltext: "yuklemeler".tr,
                textAlign: TextAlign.center,
                fontsize: 22,
                fontWeight: FontWeight.bold,
              ),
              leading: IconButton(
                icon:const Icon( Icons.menu),
                onPressed: (){
                  widget.drawerMenuController.openDrawer();
                },
              ),
              actions: [
                InkWell(
                    onTap: (){
                      _butunMelumatlariSyncEt();
                    },
                    child: Image.asset("images/sync.png",width: 30,height: 30,)),
                const SizedBox(width: 20,),

              ],

            ),
            body: Obx(() => controller.dataLoading.isTrue
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            )
                :  controller.getWidgetDownloads(context)),
          );
        }),
      ),
    );
  }


  void _butunMelumatlariSyncEt() {
    controllerBaseDownloads.syncAllInfo();
  }

}