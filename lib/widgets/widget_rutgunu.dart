import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class WidgetRutGunu extends StatelessWidget {
  String rutGunu;
  String orderNumber;
  LoggedUserModel loggedUserModel;
   WidgetRutGunu({required this.rutGunu,this.orderNumber="null",required this.loggedUserModel,super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.all(5),
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
            child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(child: CustomText(labeltext: orderNumber,color: Colors.white,)))):
        const SizedBox()
      ],
    );
  }
}

