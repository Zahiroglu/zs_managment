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
              onPressed: (){
                widget.drawerMenuController.openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
            actions: [
              InkWell(
                  onTap: (){
                    _butunMelumatlariSyncEt();

                  },
                  child: Image.asset("images/sync.png",width: 30,height: 30,)),
              SizedBox(width: 20,),

            ],

          ),
          body: Obx(() => controller.dataLoading.isTrue
              ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          )
              : Obx(() => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                SizedBox(
                  height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.25,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: getWidgetDownloads(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))),
        );
      }),
    );
  }

  getWidgetDownloads(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controllerBaseDownloads.listDonwloads.value.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CustomText(
                  labeltext: "baseMustDownload".tr,
                  fontsize: 18,
                  color: Colors.black,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white10, width: 2),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(15)),
                    color: Colors.white),
                child: SizedBox(
                  height: controllerBaseDownloads.listDonwloads.length * 80,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(2),
                    scrollDirection: Axis.vertical,
                    children: controllerBaseDownloads.listDonwloads
                        .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: controllerBaseDownloads.itemsEndirilmeliBazalar(e, context),
                    ))
                        .toList(),
                  ),
                ),
              )
            ],
          )
              : const SizedBox(),
          SizedBox(
            height: controllerBaseDownloads.listDonwloads.isNotEmpty ? 30 : 0,
          ),
          controllerBaseDownloads.listDownloadsFromLocalDb.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CustomText(
                  color: Colors.black,
                  labeltext: "baseDownloaded".tr,
                  fontsize: 18,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    border: Border.all(color: Colors.green, width: 1)),
                child: SizedBox(
                  height: controllerBaseDownloads.listDownloadsFromLocalDb.length * 100,
                  child: ListView(
                   // physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    scrollDirection: Axis.vertical,
                    children: controllerBaseDownloads.listDownloadsFromLocalDb.map((e) => Padding(padding: const EdgeInsets.all(8.0),
                      child: itemsGuncellenmeliBazalar(e, context),
                    ))
                        .toList(),
                  ),
                ),
              )
            ],
          )
              : SizedBox(),
        ]);
  }


  Widget itemsGuncellenmeliBazalar(ModelDownloads model, BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 5),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          labeltext: model.name!,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontsize: 16),
                      Row(
                        children: [
                          CustomText(
                              color:  model.musteDonwload == true?Colors.red:Get.isDarkMode?Colors.white:Colors.black,
                              fontsize: 12,
                              labeltext:
                              "${"lastRefresh".tr}: ${model.lastDownDay!.substring(0, 10)}"),
                          SizedBox(width: 5,),
                          CustomText(
                            color:  model.musteDonwload == true?Colors.red:Get.isDarkMode?Colors.white:Colors.black,
                              fontsize: 12,
                              labeltext: "( ${model.lastDownDay!.substring(11, 16)} )"),

                        ],
                      ),
                      CustomText(
                        labeltext: model.info!,
                        maxline: 3,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black,
                        fontsize: 12,
                      ),
                      model.musteDonwload == true? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            size: 12,
                            Icons.info,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: CustomText(
                              labeltext: "infoRefresh".tr,
                              maxline: 3,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.red,
                              fontsize: 12,
                            ),
                          ),

                        ],
                      ):SizedBox()
                    ],
                  ),
                ),
                model.donloading!?FlutterLogo():InkWell(
                    onTap: () {
                      controllerBaseDownloads.melumatlariEndir(model, true);
                    },
                    child: const Icon(Icons.refresh))
              ],
            ),
          ],
        ),
      ),
    );
  }

  _clearAllData(){
    controllerBaseDownloads.clearAllDataSatis();
  }

  void _butunMelumatlariSyncEt() {
    controllerBaseDownloads.syncAllInfo();
  }
}
