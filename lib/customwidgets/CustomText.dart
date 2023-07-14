import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:get/get.dart';


class CustomText extends StatelessWidget {
  String labeltext;
  FontWeight fontWeight;
  double fontsize;
  TextOverflow overflow;
  Color? color;
  int maxline;
  TextAlign textAlign;
  double latteSpacer;

  CustomText({
    required this.labeltext,
    this.fontWeight = FontWeight.normal,
    this.fontsize = 14,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxline = 1,
    this.latteSpacer = 0,
    this.textAlign = TextAlign.start,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(builder: (localizationController)
    {
      return AutoSizeText(
        minFontSize: 6,
        labeltext.tr,
        style: GoogleFonts.nunito(
            color: color ?? (localizationController.isDark ? Colors.white : Colors.black),
            fontWeight: fontWeight,
            fontSize: fontsize,
            letterSpacing: latteSpacer),
        maxLines: maxline,
        overflow: overflow,
        textAlign: textAlign,
      );
    });

}}
