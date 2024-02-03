import 'package:flutter/material.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class UsersPanelScreenMobile extends StatelessWidget {
  const UsersPanelScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: CustomText(labeltext: "UserPanel"),
      ),
    );
  }
}
