import 'package:flutter/material.dart';
import 'package:zs_managment/routs/rout_controller.dart';

class ModelCariHesabatlar {
  String? label;
  IconData? icon;
  Color? color;
  String? routName;

  ModelCariHesabatlar({this.label, this.icon, this.color, this.routName});

  List<ModelCariHesabatlar> getAllHesabatlarListy(){
    return [
      ModelCariHesabatlar(label: "Cari ziyaret hesabati",icon:  Icons.transfer_within_a_station,color:  Colors.green,routName: RouteHelper.getCariZiyaretHesabatlari()),
      ModelCariHesabatlar(label: "Cari satis hesabati",icon:  Icons.monetization_on,color:  Colors.redAccent,routName:  RouteHelper.getCariSatisHesabati()),
      ModelCariHesabatlar(label: "Cari muqavile hesabati",icon:  Icons.handshake,color:  Colors.blue,routName:  RouteHelper.getCariMuqavilelerHesabati()),
      ModelCariHesabatlar(label: "Taninan mallar hesabati",icon:  Icons.production_quantity_limits,color:  Colors.deepPurple,routName:  RouteHelper.getCariTaninanMallarHesabati()),
      ModelCariHesabatlar(label: "Zay mallar hesabati",icon:  Icons.delete_forever,color:  Colors.red,routName:  RouteHelper.getCariQaytarmaRaporu()),
      ModelCariHesabatlar(label: "Cari cesid hesabati",icon:  Icons.bar_chart,color:  Colors.black45,routName:  RouteHelper.getCariSatilanCesidRaporu()),
    ];
  }
}
