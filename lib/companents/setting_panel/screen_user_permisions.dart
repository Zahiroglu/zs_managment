import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import '../login/models/model_userspormitions.dart';

class ScreenUserPermisions extends StatelessWidget {
  ScreenUserPermisions({super.key, required this.listPermisions});

  List<ModelUserPermissions> listPermisions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
         backgroundColor: Colors.transparent,
         foregroundColor: Colors.black,
        title: CustomText(labeltext: "icazeler".tr,fontsize: 18),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: listPermisions.length,
          itemBuilder: (context,index){
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(labeltext: listPermisions.elementAt(index).name!,fontsize: 16,maxline: 5),
                Icon(Icons.verified_user_outlined,color: Colors.green,)
               // CustomText(labeltext: listPermisions.elementAt(index).valName??"")
              ],
            ),
          ),
        );
      }),
    );
  }
}
