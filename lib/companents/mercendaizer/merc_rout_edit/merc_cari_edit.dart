import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
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
    return Material(
        child: SafeArea(
            child: Scaffold(
      appBar: AppBar(
        title: CustomText(labeltext: widget.modelMerc.cariad!),
      ),
      body: _body(context),
    )));
  }

  _body(BuildContext context) {
    return Column(
      children: [
        _infoMerc(context),
      ],
    );
  }

  Widget _infoMerc(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0).copyWith(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0).copyWith(left: 10),
            child: CustomText(
              labeltext: "Merc baglanti",
              fontsize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5,top: 5),
            margin: const EdgeInsets.all(10).copyWith(top: 5),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                boxShadow: const [
                BoxShadow(
                  offset: Offset(2,2),
                  color: Colors.grey,
                  blurRadius: 5,
                  spreadRadius: 2
                )
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(labeltext: "rutKodu".tr+ " : "),
                    CustomText(labeltext: widget.modelMerc.rutadi!),
                  ],
                ),
                Row(
                  children: [
                    CustomText(labeltext: "merc".tr+ " : "),
                    CustomText(labeltext: widget.modelMerc.mercadi!),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
