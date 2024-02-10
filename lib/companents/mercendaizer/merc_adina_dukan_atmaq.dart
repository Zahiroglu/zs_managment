import 'package:flutter/material.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenMercAdinaMusteriEalveEtme extends StatefulWidget {
  ModelCariler modelCari;
  List<UserModel> listUsers;
  ScreenMercAdinaMusteriEalveEtme({required this.modelCari,required this.listUsers,super.key});

  @override
  State<ScreenMercAdinaMusteriEalveEtme> createState() => _ScreenMercAdinaMusteriEalveEtmeState();
}

class _ScreenMercAdinaMusteriEalveEtmeState extends State<ScreenMercAdinaMusteriEalveEtme> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(labeltext: widget.modelCari.name!),
        ),
      ),
    );
  }
}
