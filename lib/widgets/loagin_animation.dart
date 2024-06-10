
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'custom_responsize_textview.dart';

class LoagindAnimation extends StatelessWidget {
  bool isDark;
  String? textData="yoxlanir";
  String? icon="lottie/loagin_animation.json";
  LoagindAnimation({this.textData,this.icon,required this.isDark,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              height: 200,
                  width: 250,
                  icon!,
                  filterQuality: FilterQuality.high,
                  repeat: true,
                  fit: BoxFit.contain),
            CustomText(labeltext: textData!,fontWeight: FontWeight.w800,)

          ],
        ));
  }
}
