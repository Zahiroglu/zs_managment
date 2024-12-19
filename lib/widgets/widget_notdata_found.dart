import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';

import 'custom_responsize_textview.dart';

class NoDataFound extends StatelessWidget {
  double? width;
  double? height;
  String? title; // default value
  bool? mustReloud;
  Function()? callBack;

  NoDataFound({this.width, this.height, this.title, this.mustReloud, this.callBack, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            height: height,
            width: width,
            "lottie/nodata.json",
            filterQuality: FilterQuality.high,
            repeat: true,
            fit: BoxFit.contain,
          ),
          CustomText(
            labeltext: title ?? "melumattapilmadi".tr,  // title null olduqda default dəyər
            fontWeight: FontWeight.w800,
            fontsize: 30,
          ),
          mustReloud!=null?CustomElevetedButton(cllback: (){
            callBack!.call();
          },

              width: width!,
              height: height!/5,
              borderColor: Colors.white,
              surfaceColor: Colors.green,
              textColor: Colors.white,
              label: "tryagain".tr):SizedBox()

        ],
      ),
    );
  }
}
