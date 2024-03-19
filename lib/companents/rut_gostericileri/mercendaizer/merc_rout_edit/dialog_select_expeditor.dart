import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../../login/services/api_services/users_controller_mobile.dart';


class DialogSelectExpeditor extends StatefulWidget {
  List<SellingData> sellingDatas;
  Function(List<SellingData>) getDataBack;
  DialogSelectExpeditor({required this.sellingDatas,required this.getDataBack,super.key});

  @override
  State<DialogSelectExpeditor> createState() => _DialogSelectExpeditorState();
}

class _DialogSelectExpeditorState extends State<DialogSelectExpeditor> {
  List<SellingData> selectedSellingDatas=[];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),


        ),
        margin: const EdgeInsets.symmetric(vertical: 60,horizontal: 20),
        child: Stack(
          children: [
            const SizedBox(height: double.infinity,width: double.infinity,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(labeltext: "temsilciSecmi".tr,fontsize: 18,fontWeight: FontWeight.w800,),
                      ],
                    )),
                Expanded(
                    flex: 9,
                    child:  ListView.builder(
                        itemCount: widget.sellingDatas.length,
                        itemBuilder: (cont,index){return itemsSelectedTemsilci( widget.sellingDatas.elementAt(index));
                        }))

              ],
            ),
            Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.clear,color: Colors.red,))),
            Positioned(
                bottom: 15,
                right: 15,
                child: InkWell(
                    onTap: (){
                      widget.getDataBack(selectedSellingDatas);
                      Get.back();
                    },
                    child: CustomElevetedButton(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 35,
                      elevation: 10,
                      borderColor: Colors.green,
                      surfaceColor: Colors.white,
                      textColor: Colors.green,
                      fontWeight: FontWeight.bold,
                      label: "change".tr,
                      cllback: () async {
                       widget.getDataBack(selectedSellingDatas);
                      },
                    )))
          ],
        ),
      ),
    );
  }

  Widget itemsSelectedTemsilci(SellingData element) {
    return  InkWell(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        color: Colors.white,
        elevation: 10,
        margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      CustomText(
                          labeltext: "${"expeditor".tr} : ",
                          fontWeight: FontWeight.w700),
                      CustomText(labeltext: element.forwarderCode),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomText(
                                        labeltext: "${"plan".tr} : ",
                                        fontsize: 14,
                                        fontWeight: FontWeight.w700),
                                    CustomText(
                                        labeltext:
                                        "${element.plans} ${"manatSimbol".tr}",
                                        fontsize: 14),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                        labeltext: "${"satis".tr} : ",
                                        fontsize: 14,
                                        fontWeight: FontWeight.w700),
                                    CustomText(
                                        labeltext:
                                        "${element.selling} ${"manatSimbol".tr}",
                                        fontsize: 14),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                        labeltext: "${"zaymal".tr} : ",
                                        fontsize: 14,
                                        fontWeight: FontWeight.w700),
                                    CustomText(
                                        labeltext:
                                        "${element.refund} ${"manatSimbol".tr}",
                                        fontsize: 14),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                  top: 0,
                  right: -10,
                  height: 20,
                  child: Checkbox(
                    value: selectedSellingDatas.any((e) => e.forwarderCode==element.forwarderCode&&e.plans==element.plans),
                    onChanged: (va){
                      if(va!){
                        _addElementToSelectedList(element);
                      }else{
                        _remuveElementFromSelectedList(element);
                      }

                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _addElementToSelectedList(SellingData element) {
    selectedSellingDatas.add(element);
    setState(() {});
  }

  void _remuveElementFromSelectedList(SellingData element) {
    selectedSellingDatas.remove(element);
    setState(() {});
  }

}
