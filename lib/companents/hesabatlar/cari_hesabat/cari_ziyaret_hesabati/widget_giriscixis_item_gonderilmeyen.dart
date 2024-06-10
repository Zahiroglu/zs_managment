import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../widgets/custom_responsize_textview.dart';
import '../../../giris_cixis/models/model_customers_visit.dart';

class WidgetGirisCixisItemGonderilmeyen extends StatelessWidget {
  ModelCustuomerVisit element;
  WidgetGirisCixisItemGonderilmeyen({required this.element,super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: element.operationType=="out"?  Colors.red : Colors.green,
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
                element.operationType=="out"?SizedBox():Row(
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
                       const SizedBox(
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
                        CustomText(labeltext: element.inDistance!.toString()+" m"),

                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                element.operationType=="out"? Row(
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
                        CustomText(labeltext: element.outDistance!=null?element.outDistance!.toString()+" m":"cixisedilmeyib".tr),

                      ],
                    )

                  ],
                ):SizedBox(),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0).copyWith(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error,color: Colors.red,size: 14,),
                      SizedBox(width: 2,),
                      Expanded(child: CustomText(labeltext: element.operationType=="out"?"errorApiCixis".tr:"errorApiGiris".tr,color: Colors.red,)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: element.operationType=="out"? Colors.red : Colors.green,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                labeltext: element.operationType=="out"? "cixis".tr : "giris".tr,
                color:element.operationType=="out"? Colors.red : Colors.green,
              ),
            ))
      ],
    );
  }
}
