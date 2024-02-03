import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/model_userconnnection.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import '../login/models/model_userspormitions.dart';

class ScreenUserConnections extends StatelessWidget {
  ScreenUserConnections({super.key, required this.listConnections});

  List<ModelUserConnection> listConnections = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
         backgroundColor: Colors.transparent,
         foregroundColor: Colors.black,
        title: CustomText(labeltext: "connections".tr,fontsize: 18),
        elevation: 0,
      ),
      body: listConnections.isNotEmpty?ListView.builder(
        itemCount: listConnections.length,
          itemBuilder: (context,index){
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(labeltext: listConnections.elementAt(index).roleName!+" : ",fontsize: 16,maxline: 5),
                SizedBox(width: 10,),
                CustomText(labeltext:listConnections.elementAt(index).code!+"-"+listConnections.elementAt(index).fullName!,fontsize: 16,maxline: 5),
               // CustomText(labeltext: listConnections.elementAt(index).valName??"")
              ],
            ),
          ),
        );
      }):Center(child: CustomText(labeltext: "Melumat tapilmadi")),
    );
  }
}
