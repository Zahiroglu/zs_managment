import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';

class AnbarRaporEsas extends StatefulWidget {
  DrawerMenuController drawerMenuController;
   AnbarRaporEsas({required this.drawerMenuController,Key? key}) : super(key: key);

  @override
  _AnbarRaporEsasState createState() => _AnbarRaporEsasState();
}

class _AnbarRaporEsasState extends State<AnbarRaporEsas> {
  bool isloading = true;
  ControllerAnbar controllerAnbar = Get.put(ControllerAnbar());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    Get.delete<ControllerAnbar>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          labeltext: "anbar".tr,
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

      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Obx(() => Column(
      children: [

        const SizedBox(
          height: 5,
        ),
        controllerAnbar.dataLoading.isFalse?Expanded(
          child: SizedBox(
            height: 250,
            child: ListView(
              padding: EdgeInsets.all(5),
                children: controllerAnbar.listAnaQruplar
                    .map((element) => _customAnaQrupItems(element))
                    .toList()),
          ),
        ):LoagindAnimation(isDark: Get.isDarkMode,icon: "lottie/loagin_animation.json",textData: "Melumatlar yuklenir..."),
      ],
    ));
  }

  Widget _customAnaQrupItems(ModelAnaQrupAnbar element) {
    return InkWell(
      onTap: () async {
        controllerAnbar.changeSelectedQroupProducts(element);
      },
      child: Card(
        shadowColor: Colors.grey,
        elevation: 10,
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(labeltext: element.groupAdi!,fontsize: 16,fontWeight: FontWeight.w800),
              Row(
                children: [
                  CustomText(labeltext: "Qrup cesid sayi : "),
                  CustomText(labeltext: element.cesidSayi.toString()),
                ],
              ),
              Row(
                children: [
                  CustomText(labeltext: "'Stock Out' olanlar : "),
                  CustomText(labeltext: element.stockOutSayi.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
