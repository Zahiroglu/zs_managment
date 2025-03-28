import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:zs_managment/companents/live_track/model/model_live_track.dart';
import 'package:zs_managment/companents/live_track/screen_search_live_users.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenNotInWorkUsers extends StatefulWidget {
  LoggedUserModel loggedUserModel;
  List<ModelLiveTrack> listModel;
   ScreenNotInWorkUsers({required this.listModel,required this.loggedUserModel,super.key});

  @override
  State<ScreenNotInWorkUsers> createState() => _ScreenNotInWorkUsersState();
}

class _ScreenNotInWorkUsersState extends State<ScreenNotInWorkUsers> {

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: CustomText(labeltext: "${DateTime.now().toString().substring(0,11)} ${"notInWorkUsers".tr}",),
          actions: [],
        ),
        body: SizedBox(
          child: ListView.builder(
      itemCount: widget.listModel.length,
      itemBuilder: (context,index){
      return WidgetWorkerItemNotWorkedToday(
        loggedUserModel: widget.loggedUserModel,
        context: context, element: widget.listModel.elementAt(index), callBack: (e) {  },);
        }))),
    );

}
}
