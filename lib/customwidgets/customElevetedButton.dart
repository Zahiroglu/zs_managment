import 'package:flutter/material.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CustomElevetedButton extends StatelessWidget {
  CustomElevetedButton(
      {required this.cllback,
      required this.label,
      required this.surfaceColor,
      this.borderColor = Colors.white12,
      this.hasshadow = true,
      this.elevation = 2,
      this.width = 150,
      this.height = 50,
      this.textsize = 14,
      this.icon,
      this.textColor = Colors.black,
      Key? key})
      : super(key: key);

  Function cllback;
  String label;
  bool hasshadow;
  double elevation;
  double width;
  double height;
  Color surfaceColor;
  Color borderColor;
  double textsize;
  Color textColor;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: label.length * 10,
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            side: BorderSide(color: borderColor),
            foregroundColor: borderColor.withOpacity(.2),
            backgroundColor: surfaceColor,
            shadowColor: Colors.grey,
            elevation: elevation,
            fixedSize: Size(width, height),
          ),
          onPressed: () {
            cllback();
          },
          child: Row(
              mainAxisAlignment: icon == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                icon == null
                    ? const SizedBox()
                    : Icon(
                        icon,
                        color: textColor,
                        size: 18,
                      ),
                icon == null?const SizedBox():const Spacer(),
                Center(
                  child: CustomText(
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    labeltext: label.tr,
                    fontsize: textsize,
                    color: textColor,
                  ),
                ),
                icon == null?const SizedBox():const Spacer(),
              ])),
    );
  }
}
