import 'package:flutter/material.dart';
import 'package:zs_managment/routs/rout_controller.dart';

class ModelCariHesabatlar {
  String? label;
  IconData? icon;
  Color? color;
  String? routName;
  bool? needDate;
  bool? needTime;
  String? key;
  bool? isAktiv;

  ModelCariHesabatlar(
      {this.label,
      this.icon,
      this.color,
      this.routName,
      this.needTime,
      this.needDate,
      this.isAktiv,
      this.key});

  List<ModelCariHesabatlar> getAllCariHesabatlarListy() {
    List<ModelCariHesabatlar> cariHesabatlar = [];
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Cari ziyaret hesabati",
        icon: Icons.transfer_within_a_station,
        color: Colors.green,
        routName: RouteHelper.getCariZiyaretHesabatlari(),
        needDate: true,
        isAktiv: true,
        key: "cZiyaretH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Cari cesid hesabati",
        icon: Icons.bar_chart,
        color: Colors.black45,
        routName: RouteHelper.getCariSatilanCesidRaporu(),
        needDate: true,
        isAktiv: true,
        key: "cCesidH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Cari satis hesabati",
        icon: Icons.monetization_on,
        color: Colors.redAccent,
        routName: RouteHelper.getCariSatisHesabati(),
        needDate: true,
        isAktiv: true,
        key: "cSatisH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Cari muqavile hesabati",
        icon: Icons.handshake,
        color: Colors.blue,
        routName: RouteHelper.getCariMuqavilelerHesabati(),
        needDate: false,
        isAktiv: false,
        key: "cMusavileH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Taninan mallar hesabati",
        icon: Icons.production_quantity_limits,
        color: Colors.deepPurple,
        routName: RouteHelper.getCariTaninanMallarHesabati(),
        needDate: false,
        isAktiv: false,
        key: "cTanMallarH"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Zay mallar hesabati",
        icon: Icons.delete_forever,
        color: Colors.red,
        routName: RouteHelper.getCariQaytarmaRaporu(),
        needDate: true,
        isAktiv: true,
        key: "cZayMalH"));

    return cariHesabatlar;
  }
  List<ModelCariHesabatlar> getAllUserHesabatlarListy() {
    List<ModelCariHesabatlar> cariHesabatlar = [];
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Temsilci rut hesabati",
        icon: Icons.list_alt,
        color: Colors.green,
        routName: RouteHelper.getScreenMercRoutDatail(),
        needDate: false,
        needTime: false,
        key: "trhesabat"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Temsilci ziyaret hesabati",
        icon: Icons.visibility,
        color: Colors.blue,
        needTime: false,
        //routName: RouteHelper.getCariSatilanCesidRaporu(),
        needDate: true,
        key: "tzhesab"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Temsilci izleme hesabati",
        icon: Icons.spatial_tracking_outlined,
        color: Colors.grey,
        needTime: true,
        //routName: RouteHelper.getCariSatilanCesidRaporu(),
        needDate: true,
        key: "tizlemehesab"));
    cariHesabatlar.add(ModelCariHesabatlar(
        label: "Temsilci xetalar raporu",
        icon: Icons.error,
        color: Colors.red,
        needTime: true,
        //routName: RouteHelper.getCariSatilanCesidRaporu(),
        needDate: true,
        key: "terror"));

    return cariHesabatlar;
  }
}
