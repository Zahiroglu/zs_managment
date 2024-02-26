import 'package:flutter/material.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/model_cari_hesabatlar.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/widgetHesabatListItems.dart';

class WidgetCarihesabatlar extends StatefulWidget {
  String ckod;
  String cad;
  double height;
  WidgetCarihesabatlar({required this.cad,required this.ckod,required this.height,super.key});

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
    return SizedBox(
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
    );
  }
}
