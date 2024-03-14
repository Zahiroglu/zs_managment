import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import 'controller_base_downloads.dart';

class FirstScreenBaseDownloads extends StatefulWidget {
  bool fromFirstScreen;

  FirstScreenBaseDownloads({required this.fromFirstScreen ,super.key});

  @override
  State<FirstScreenBaseDownloads> createState() => _FirstScreenBaseDownloadsState();
}

class _FirstScreenBaseDownloadsState extends State<FirstScreenBaseDownloads> {
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
                : SingleChildScrollView(
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
                            child: controller.getWidgetDownloads(context),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  controllerBaseDownloads.davamEtButonuGorunsun.isTrue?Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomElevetedButton(
                          cllback: () {
                            Get.offNamed(RouteHelper.mobileMainScreen);
                          },
                          label: "goAhed".tr,
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2,
                          surfaceColor: Colors.white,
                          borderColor: Colors.blueAccent,
                          elevation: 10,
                        )
                      ],
                    ),
                  ):SizedBox(),
                ],
              ),
            )),
          );
        }),
      ),
    );
  }

  void _butunMelumatlariSyncEt() {
    controllerBaseDownloads.syncAllInfo();
  }

}
