import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/mercendaizer/model_mercbaza.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenMercCariEdit extends StatefulWidget {
  ModelMercBaza modelMerc;
  List<UserModel> listUsers;

  ScreenMercCariEdit(
      {required this.modelMerc, required this.listUsers, super.key});

  @override
  State<ScreenMercCariEdit> createState() => _ScreenMercCariEditState();
}

class _ScreenMercCariEditState extends State<ScreenMercCariEdit> {
  @override
  Widget build(BuildContext context) {
    return Material(child: SafeArea(child: Scaffold(
      appBar: AppBar(),
      body: _body(context),
    )));
  }

  _body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(labeltext: widget.modelMerc.cariad!),
      ),
    );
  }
}
