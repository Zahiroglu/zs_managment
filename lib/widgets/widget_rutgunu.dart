import 'package:flutter/material.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class WidgetRutGunu extends StatelessWidget {
  String rutGunu;
  String orderNumber;
   WidgetRutGunu({required this.rutGunu,this.orderNumber="null",super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(color: Colors.black, width: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: CustomText(labeltext: rutGunu, color: Colors.white, fontsize: 12),
        ),
        orderNumber!="null"?Positioned(
            top: 0,
            right: 0,
            child: CustomText(labeltext: orderNumber,)):Positioned(
            top: 0,
            right: 5,
            child: CustomText(labeltext: "0",fontsize: 10,))
      ],
    );
  }
}

