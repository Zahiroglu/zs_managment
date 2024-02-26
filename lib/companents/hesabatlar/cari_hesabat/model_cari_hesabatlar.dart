import 'package:flutter/material.dart';
import 'package:zs_managment/routs/rout_controller.dart';

class ModelCariHesabatlar {
  String? label;
  IconData? icon;
  Color? color;
  String? routName;
  bool? needDate;
  String? key;

  ModelCariHesabatlar(
      {this.label,
      this.icon,
      this.color,
      this.routName,
      this.needDate,
      this.key});

  List<ModelCariHesabatlar> getAllHesabatlarListy() {
    List<ModelCariHesabatlar> cariHesabatlar = [];
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Cari ziyaret hesabati",
        icon: Icons.transfer_within_a_station,
        color: Colors.green,
        routName: RouteHelper.getCariZiyaretHesabatlari(),
        needDate: true,
        key: "cZiyaretH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Cari satis hesabati",
        icon: Icons.monetization_on,
        color: Colors.redAccent,
        routName: RouteHelper.getCariSatisHesabati(),
        needDate: true,
        key: "cSatisH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Cari muqavile hesabati",
        icon: Icons.handshake,
        color: Colors.blue,
        routName: RouteHelper.getCariMuqavilelerHesabati(),
        needDate: false,
        key: "cMusavileH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Taninan mallar hesabati",
        icon: Icons.production_quantity_limits,
        color: Colors.deepPurple,
        routName: RouteHelper.getCariTaninanMallarHesabati(),
        needDate: false,
        key: "cTanMallarH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Zay mallar hesabati",
        icon: Icons.delete_forever,
        color: Colors.red,
        routName: RouteHelper.getCariQaytarmaRaporu(),
        needDate: true,
        key: "cZayMalH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Cari cesid hesabati",
        icon: Icons.bar_chart,
        color: Colors.black45,
        routName: RouteHelper.getCariSatilanCesidRaporu(),
        needDate: true,
        key: "cCesidH"));

    return cariHesabatlar;
  }
}
