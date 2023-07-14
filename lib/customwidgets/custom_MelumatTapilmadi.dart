import 'package:flutter/material.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
class WidgetMelumatTapilmadi extends StatelessWidget {
  String label;
   WidgetMelumatTapilmadi({required this.label,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset("images/notdatafound.png",height: MediaQuery.of(context).size.height*0.4,width: MediaQuery.of(context).size.width*0.5,),
          SizedBox(height: 15,),
          CustomText(labeltext: "Melumat Tapilmadi",color: Colors.black,fontWeight: FontWeight.bold,fontsize: 24,),
          SizedBox(height: 5,),
          CustomText(labeltext: label,color: Colors.black,fontWeight: FontWeight.bold,fontsize: 16,)
        ],
      ),
    );
  }
}
