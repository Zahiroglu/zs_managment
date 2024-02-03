import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/thema/thema_controller.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({required this.changeTheme,super.key});
  final Function(bool) changeTheme;


  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.light_mode_outlined);
      }
      return const Icon(Icons.dark_mode_outlined);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Switch(
          onFocusChange: (val){

          },
          thumbIcon: thumbIcon,
          value: light1,
          onChanged: (bool value) {
            setState(() {
              light1 = value;
              widget.changeTheme(value);
            });
          },
        ),
      ],
    );
  }
}
