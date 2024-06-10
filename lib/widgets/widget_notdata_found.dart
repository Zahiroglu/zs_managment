import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';

import 'custom_responsize_textview.dart';

class NoDataFound extends StatelessWidget {
  double? width;
  double? height;
  String? title="melumattapilmadi".tr;

  NoDataFound({this.width, this.height,this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            labeltext:title.toString(),
            fontWeight: FontWeight.w800,
            fontsize: 40,
          ),
          Lottie.asset(
              height: height,
              width: width,
              "lottie/nodata.json",
              filterQuality: FilterQuality.high,
              repeat: true,
              fit: BoxFit.contain),
        ],
      ),
    );
  }
}
