import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'custom_responsize_textview.dart';
import 'package:get/get.dart';

class CustomElevetedButton extends StatelessWidget {
  CustomElevetedButton(
      {required this.cllback,
      required this.label,
      this.surfaceColor,
      this.borderColor = Colors.white12,
      this.hasshadow = true,
      this.isSvcFile = false,
      this.svcFile = '',
      this.elevation = 2,
      this.clicble = true,
      this.width = 100,
      this.height = 60,
      this.textsize = 14,
      this.fontWeight = FontWeight.normal,
      this.icon,
      this.textColor,
      Key? key})
      : super(key: key);

  Function cllback;
  String label;
  bool hasshadow;
  bool isSvcFile;
  String svcFile;
  double elevation;
  double width;
  double height;
  Color? surfaceColor;
  Color borderColor;
  double textsize;
  Color? textColor;
  IconData? icon;
  FontWeight fontWeight;
  bool clicble;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          side: BorderSide(color: borderColor),
          foregroundColor: borderColor.withOpacity(.2),
          backgroundColor: surfaceColor ?? (Get.isDarkMode ? Colors.black : Colors.white),
          shadowColor:clicble? Colors.grey:Colors.black,
          elevation:clicble? elevation:0,
        ),
        onPressed: () {
          clicble? cllback.call():null;
        },
        child: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isSvcFile
                  ? ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                height: 25,
                width: 25,
                      child: SvgPicture.asset(
                fit: BoxFit.fill,
                          alignment: Alignment.center,

                          svcFile,
                          width: 24,
                          height: 24,

                          // ...
                        ),
                    ),
                  )
                  : icon == null
                      ? const SizedBox()
                      : Icon(icon,
                          color: textColor ??
                              (Get.isDarkMode ? Colors.white : Colors.black)),
              Expanded(
                  child: CustomText(
                color: textColor ?? (Get.isDarkMode ? Colors.white : Colors.black),
                textAlign: TextAlign.center,
                labeltext: label,
                fontWeight: fontWeight,
                overflow: TextOverflow.ellipsis,
                maxline: 2,
              ))
            ],
          ),
        ));
  }
}
