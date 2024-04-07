import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../global_models/model_appsetting.dart';
import 'controller_base_downloads.dart';
import 'controller_base_downloads_firsttime.dart';

class FirstScreenBaseDownloads extends StatefulWidget {
  bool fromFirstScreen;

  FirstScreenBaseDownloads({required this.fromFirstScreen ,super.key});

  @override
  State<FirstScreenBaseDownloads> createState() => _FirstScreenBaseDownloadsState();
}

class _FirstScreenBaseDownloadsState extends State<FirstScreenBaseDownloads> {
  ControllerBaseDownloadsFirstTime controllerBaseDownloads = Get.put(ControllerBaseDownloadsFirstTime());

  @override
  void dispose() {
    Get.delete<ControllerBaseDownloadsFirstTime>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(

      child: SafeArea(
        child: GetBuilder<ControllerBaseDownloadsFirstTime>(builder: (controller) {
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
                  controllerBaseDownloads.davamEtButonuGorunsun.isFalse?SizedBox():Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex:5,
                            child: CustomElevetedButton(
                              cllback: () async {
                                await controllerBaseDownloads.saveChangedSettingtoDb(false);
                              },
                              label: "goAhead".tr,
                              height: 40,
                              icon: Icons.info,
                              surfaceColor: Colors.white,
                              textColor: Colors.orangeAccent,
                              borderColor: Colors.orangeAccent,
                              elevation: 10,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            flex: 5,
                            child: CustomElevetedButton(
                              cllback: () async {
                                await controllerBaseDownloads.saveChangedSettingtoDb(true);
                              },
                              textColor: Colors.green,
                              icon: Icons.work_history,
                              label: "startWork".tr,
                              height: 40,
                              surfaceColor: Colors.white,
                              borderColor: Colors.green,
                              elevation: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
