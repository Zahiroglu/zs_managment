import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../widgets/custom_responsize_textview.dart';
import 'controllers/controller_dashbourd_exp.dart';

class DashborudScreenMobile extends StatefulWidget {
  const DashborudScreenMobile({super.key});

  @override
  State<DashborudScreenMobile> createState() => _DashborudScreenMobileState();
}

class _DashborudScreenMobileState extends State<DashborudScreenMobile> {
  ControllerDashBorudExp controllerDashBorudExp=Get.put(ControllerDashBorudExp());

  @override
  void dispose() {
    Get.delete<ControllerDashBorudExp>();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerDashBorudExp>(builder: (contoller) {
      return Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.1),
          body: Obx(() => contoller.screenLoading.isFalse? Stack(
            children: [
              Container(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,color: Colors.transparent,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.3,
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
                    const SizedBox(height: 35,),
                    contoller.getUserInfoField(context),
                    contoller.getDownloadMenu(context),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: MediaQuery.of(context).size.height*0.32,
                child: Container(
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
            ],
          ):Center(child: CircularProgressIndicator(color: Colors.blue,),)));
    });


    }


}
