import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';

import '../../../../widgets/custom_responsize_textview.dart';
import '../../../giris_cixis/models/model_customers_visit.dart';

class WidgetGirisCixisItem extends StatelessWidget {
  ModelCustuomerVisit element;
  bool? canDelete;
  Function(bool)? deleted;
  WidgetGirisCixisItem({required this.element,this.canDelete=false,this.deleted,super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: element.isRutDay!? Colors.red : Colors.green,
          margin:
          const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomText(
                          labeltext: element.customerName!,
                          fontsize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          overflow: TextOverflow.ellipsis,
                          maxline: 2,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   Row(
                     children: [
                       Image.asset(
                         "images/externalvisit.png",
                         width: 20,
                         height: 20,
                         color: Colors.blue,
                       ),
                       CustomText(labeltext: "girisVaxt".tr+" : "),
                       SizedBox(
                         width: 2,
                       ),
                       CustomText(labeltext: element.inDate!.toString().substring(11, 19)),
                     ],
                   ),
                    SizedBox(width: 10,),
                    Row(
                      children: [
                        Image.asset(
                          "images/distance.png",
                          width: 20,
                          height: 15,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(labeltext: changeDistanceToString(element.inDistance!.toString())),

                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                 Row(
                   children: [
                     Image.asset(
                       "images/externalvisit.png",
                       width: 20,
                       height: 20,
                       color: Colors.red,
                     ),
                     CustomText(labeltext: "cixisVaxt".tr+" : "),
                     const SizedBox(
                       width: 2,
                     ),
                     CustomText(labeltext:  element.outDistance!="0"?element.outDate!.toString().substring(11, 19):""),
                     const SizedBox(
                       width: 10,
                     ),
                   ],
                 ),
                    Row(
                      children: [
                        Image.asset(
                          "images/distance2.png",
                          width: 20,
                          height: 15,
                        ),
                        const SizedBox(width: 5,),
                        CustomText(labeltext: element.outDistance!=null?changeDistanceToString(element.outDistance!):"cixisedilmeyib".tr),

                      ],
                    )

                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: "marketdeISvaxti".tr+" : "),
                    const SizedBox(
                      width: 2,
                    ),
                    element.workTimeInCustomer!=null?CustomText(labeltext: element.workTimeInCustomer!):SizedBox(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                        labeltext: "${element.inDate.toString().substring(0, 11)}"),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: element.isRutDay!? Colors.red : Colors.green,
                          width: 0.4),
                      borderRadius: BorderRadius.circular(5)),
                  child: CustomText(
                    labeltext: element.isRutDay!? "rutdanKenar".tr : "rutgunu".tr,
                    color:element.isRutDay!? Colors.red : Colors.green,
                  ),
                ),
                canDelete!? Padding(
                  padding: const EdgeInsets.all(5.0).copyWith(left: 10,right: 10),
                  child: InkWell(
                      onTap: (){
                        Get.dialog(ShowSualDialog(messaje: "msilmek".tr, callBack: (val){
                          if(val){
                            deleted!.call(val);
                          }
                        }));
                      },
                      child: const Icon(Icons.delete_forever,color: Colors.red,)),
                ):SizedBox()
              ],
            ))
      ],
    );
  }

 String changeDistanceToString(String dictance) {
    String mesafe="";
    double mesafeD=double.parse(dictance);
    if(mesafeD<=1){
      mesafe="${(mesafeD*1000).round()} m";
    }else{
      mesafe="${mesafeD.round()} km";
    }
    return mesafe;
 }
}
