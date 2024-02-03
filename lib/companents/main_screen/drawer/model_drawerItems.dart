import 'package:flutter/material.dart';

class SelectionButtonData {
  final IconData? activeIcon;
  final IconData? icon;
  final String? label;
  final int? totalNotif;
  final bool? statickField;
  final bool? isSelected;
  final String? codename;

  SelectionButtonData({
    this.activeIcon,
    this.icon,
    this.label,
    this.totalNotif,
    this.statickField,
    this.isSelected,
    this.codename,
  });
}
