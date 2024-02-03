import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/umumi_widgetler/cari_hesabat/model_cari_hesabatlar.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class WidgetHesabatListItems extends StatelessWidget {
  ModelCariHesabatlar modelCariHesabatlar;
  WidgetHesabatListItems({required this.modelCariHesabatlar,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:  BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: modelCariHesabatlar.color!,
                  offset: const Offset(2,2),
                  spreadRadius: 0.1,
                  blurRadius: 2
              )
            ],
            border: Border.all(color: modelCariHesabatlar.color!.withOpacity(0.5)),
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 15,backgroundColor: modelCariHesabatlar.color!,foregroundColor:Colors.white,child: Icon(modelCariHesabatlar.icon!),),
            SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomText(labeltext: modelCariHesabatlar.label!.tr,maxline: 2,textAlign: TextAlign.center,),
                ))
          ],
        ),
      ),
    );
  }
}
