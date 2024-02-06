import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/mercendaizer/model_mercbaza.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_dialog/dialog_select_user_connections.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/dialog_select_simpleuser_select.dart';

class ScreenMercCariEdit extends StatefulWidget {
  ModelMercBaza modelMerc;
  List<UserModel> listUsers;

  ScreenMercCariEdit(
      {required this.modelMerc, required this.listUsers, super.key});

  @override
  State<ScreenMercCariEdit> createState() => _ScreenMercCariEditState();
}

class _ScreenMercCariEditState extends State<ScreenMercCariEdit> {
  List<User> listUsers=[];
  late ModelMercBaza modelMerc;


  @override
  void initState() {
    for (var element in widget.listUsers) {
      listUsers.add( User(
          code: element.code,
          roleId: element.roleId,
          roleName: element.roleName,
          fullName: element.username,
        isSelected: element.code==widget.modelMerc.rutadi,
      ));

    }
    modelMerc=widget.modelMerc;
    // TODO: implement initState
    super.initState();
  }

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
    return InkWell(
      onTap: (){
        Get.dialog(DialogSimpleUserSelect(
          selectedUserCode: widget.modelMerc.rutadi!,
          getSelectedUse:  (selectedUser) {
            setState(() {
              modelMerc.rutadi=selectedUser.code;
              modelMerc.mercadi=selectedUser.fullName;
            });
          },
          listUsers: listUsers,
          vezifeAdi: "Mercendaizerler",
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0).copyWith(left: 10),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                  child: CustomText(
                    labeltext: "mercBaglanti".tr,
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5,top: 5,bottom: 5),
                  margin: const EdgeInsets.all(10).copyWith(top: 5),
                  height: MediaQuery.of(context).size.height * 0.08,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(labeltext: "rutKod".tr+ " : "),
                          CustomText(labeltext: modelMerc.rutadi!,fontWeight: FontWeight.w700,),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "merc".tr+ " : "),
                          CustomText(labeltext: modelMerc.mercadi!,fontWeight: FontWeight.w700,),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                top: 5,
                right: -0,
                child: IconButton(
                  iconSize: 32,
                  onPressed: (){
                    Get.dialog(DialogSimpleUserSelect(
                      selectedUserCode: widget.modelMerc.rutadi!,
                      getSelectedUse:  (selectedUser) {
                        setState(() {
                          modelMerc.rutadi=selectedUser.code;
                          modelMerc.mercadi=selectedUser.fullName;
                        });
                      },
                      listUsers: listUsers,
                      vezifeAdi: "Mercendaizerler",
                    ));
                  },
                  icon: const Icon(Icons.change_circle,color: Colors.green,),
                ))

          ],
        ),
      ),
    );
  }
}
