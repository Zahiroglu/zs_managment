import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/model_cari_hesabatlar.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/widgetHesabatListItems.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class WidgetCarihesabatlar extends StatefulWidget {
  String ckod;
  String cad;
  double height;

  WidgetCarihesabatlar(
      {required this.cad, required this.ckod, required this.height, super.key});

  @override
  State<WidgetCarihesabatlar> createState() => _WidgetCarihesabatlarState();
}

class _WidgetCarihesabatlarState extends State<WidgetCarihesabatlar> {
  ModelCariHesabatlar modelCariHesabatlar = ModelCariHesabatlar();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0).copyWith(left: 5,right: 5),
      child: DecoratedBox(
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.black,
                  spreadRadius: 5,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 1)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                      labeltext: "cariHesabatlar".tr,
                      fontWeight: FontWeight.w800,
                      fontsize: 16),
                  Icon(Icons.read_more)
                ],
              ),
            ),
            SizedBox(
              height: widget.height,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: modelCariHesabatlar
                    .getAllHesabatlarListy()
                    .map((e) => WidgetHesabatListItems(
                          cAd: widget.cad,
                          ckod: widget.ckod,
                          context: context,
                          modelCariHesabatlar: e,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
