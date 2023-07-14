import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get.dart';
import 'package:zs_managment/language/localization_controller.dart';

class CutomTextButton extends StatelessWidget {
  Function callBack;
  String label;
  CutomTextButton({required this.label,required this.callBack, Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(builder: (localizationController)
    {
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          backgroundColor: Colors.white,
          maximumSize: Size(200,40),
          minimumSize: Size(40, 20),
          elevation: 2,
          side: BorderSide(
            color: Colors.green,
          )
      ),
      onPressed: (){},
      child: Text(label.tr,style: TextStyle(color: Colors.black,fontSize: 12),),
    );
  });
}}
