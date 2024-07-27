import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../widgets/custom_text_field.dart';
import 'model/model_live_track.dart';

class SearchLiveUsers extends StatelessWidget {
  List<ModelLiveTrack> listUsers;
  SearchLiveUsers({required this.listUsers,super.key});
  TextEditingController ctSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Material(
      child:  Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: CustomTextField(
            containerHeight: 40,
            suffixIcon: Icons.search_outlined,
            align: TextAlign.center,
            controller: ctSearch,
            fontsize: 14,
            hindtext: "axtar".tr,
            inputType: TextInputType.text,
            onTextChange: (s){
              searchUsers(s);
            },
          ),
        ),
        body: ListView.builder(
            itemCount: listUsers.length,
            itemBuilder: (context,index){
          return WidgetWorkerItemLiveTtack(context: context, element: listUsers.elementAt(index));
        }),
      ),
    );
  }

  void searchUsers(String s) {}

}

class WidgetWorkerItemLiveTtack extends StatelessWidget {
  const WidgetWorkerItemLiveTtack({
    super.key,
    required this.context,
    required this.element,
  });

  final BuildContext context;
  final ModelLiveTrack element;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(element.currentLocation!=null){
        Get.back(result: element);}
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child: element.lastInoutAction!=null?Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: CustomText(
                    overflow: TextOverflow.ellipsis,
                    labeltext: "${element.userCode!}-${element.currentLocation!.userFullName}",
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: element.currentLocation!.isOnline!
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey,width: 0.5)),
                    child: Center(
                        child: CustomText(
                          labeltext: element.currentLocation!.isOnline!
                              ? "Online"
                              : "Offline",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    labeltext: "${"sonYenilenme".tr} : ",
                    fontsize: 14,
                    fontWeight: FontWeight.normal),
                CustomText(
                    labeltext: element.currentLocation!.locationDate!),
              ],
            ),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        labeltext: "${"surret".tr} : ",
                        fontsize: 14,
                        fontWeight: FontWeight.normal),
                    CustomText(
                        labeltext: "${element.currentLocation!.speed} km"),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),element.currentLocation!.speed ==
                    "0"
                    ? SizedBox()
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        labeltext: "${"hereket".tr} : ",
                        fontsize: 14,
                        fontWeight: FontWeight.normal),
                    CustomText(
                        labeltext: element.currentLocation!.speed ==
                            "0"
                            ? ""
                            : "hereketdedir".tr),
                  ],
                ),
              ],
            ),
        ],):Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext: "${element.userCode!}-${element.userFullName.toString()}",
                  fontsize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),

          ],),
      ),
    );
  }
}
