import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import 'controller_base_downloads.dart';

class ScreenBaseDownloads extends StatefulWidget {
  bool fromFirstScreen;
  bool davamEtButonuGorunsun;

  ScreenBaseDownloads({required this.fromFirstScreen,required this.davamEtButonuGorunsun, super.key});

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
    return GetBuilder<ControllerBaseDownloads>(builder: (controller) {
      return Material(
        color: Colors.white,
        child: Obx(() => controller.dataLoading.isTrue
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
                    const SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: CustomText(
                          labeltext: "Yuklemeler".tr,
                          textAlign: TextAlign.center,
                          fontsize: 22,
                          fontWeight: FontWeight.bold,
                        )),
              
              
              
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: (){
                          controllerBaseDownloads.clearAllDataSatis();
                        }, icon: const Icon(Icons.cleaning_services))
                      ],
                    ),
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
                    widget.davamEtButonuGorunsun? Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomElevetedButton(
                            cllback: () {
                              Get.toNamed(RouteHelper.mobileMainScreen);
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
    });
  }
}
