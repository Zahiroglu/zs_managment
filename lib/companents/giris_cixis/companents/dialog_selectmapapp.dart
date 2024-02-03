
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class DialogSelectMapApp extends StatelessWidget {
  List<AvailableMap> listmap;
  Function(AvailableMap) callBack;
  DialogSelectMapApp({required this.listmap,required this.callBack,super.key});

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        height: 80,
        width: 150,
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/4.2,horizontal: MediaQuery.of(context).size.width/10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(labeltext: "Daimi Program sec",fontsize: 24,),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: listmap.map((e) => widgetAppItem(e)).toList(),
                ),
              ),
            ),
            CustomElevetedButton(cllback: (){
              Get.back();
            }, label: "bagla".tr,height: 30,elevation: 10,borderColor: Colors.grey),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

Widget  widgetAppItem(AvailableMap e) {
    return InkWell(
      onTap: (){
        callBack(e);
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  e.icon,
                  width: 32,
                  height: 32,
                  // ...
                ),
                const SizedBox(width: 10,),
                CustomText(labeltext: e.mapName,fontsize: 16),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(height: 1,color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}
