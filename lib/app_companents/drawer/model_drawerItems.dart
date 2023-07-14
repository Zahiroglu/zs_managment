import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:zs_managment/login/models/model_userspormitions.dart';

class SelectionButtonData {
  final IconData? activeIcon;
  final IconData? icon;
  final String? label;
  final int? totalNotif;

  SelectionButtonData({
    this.activeIcon,
    this.icon,
    this.label,
    this.totalNotif,
  });
}
