import 'package:flutter/material.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class WidgetRutGunu extends StatelessWidget {
  String rutGunu;
   WidgetRutGunu({required this.rutGunu,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(color: Colors.black, width: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: CustomText(labeltext: rutGunu, color: Colors.white, fontsize: 12),
    );
  }
}

