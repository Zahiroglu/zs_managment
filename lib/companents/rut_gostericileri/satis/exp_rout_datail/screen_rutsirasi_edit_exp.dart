import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenExpRutSirasiEdit extends StatefulWidget {
  List<ModelCariler> listRutGunleri;
  String rutGunu;
  ScreenExpRutSirasiEdit({required this.listRutGunleri,required this.rutGunu,super.key});

  @override
  State<ScreenExpRutSirasiEdit> createState() => _ScreenExpRutSirasiEditState();
}

class _ScreenExpRutSirasiEditState extends State<ScreenExpRutSirasiEdit> {
  List<ModelCariler> listRutGunleri=[];
  bool deyisiklikEdildi=false;

@override
  void initState() {
  for (var element in widget.listRutGunleri) {
      listRutGunleri.add(element);
  }
  final Map<String, ModelCariler> profileMap = {};
  for (var item in widget.listRutGunleri) {
    profileMap[item.name!] = item;
  }
  listRutGunleri = profileMap.values.toList();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(child:  Scaffold(
      appBar: AppBar(
        title: CustomText(labeltext: "${widget.rutGunu} ${"msirasi".tr}"),
        centerTitle: false,
      ),
      body:Column(
        children: [
          _body(listRutGunleri),
          deyisiklikEdildi?Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(0.0).copyWith(top: 10),
              child: CustomElevetedButton(
                width: MediaQuery.of(context).size.width/2,
              height: 40,
              elevation: 10,
              borderColor: Colors.green,
              surfaceColor: Colors.white,
              textColor: Colors.green,
              fontWeight: FontWeight.bold,
              label: "change".tr,
              cllback: (){
                  Get.back();
              },),
            ),):const SizedBox()
        ],
      ),
    ));
  }

  _body(List<ModelCariler> listRutGunleri) {
    return SizedBox(
      height:deyisiklikEdildi?MediaQuery.of(context).size.height*0.8:MediaQuery.of(context).size.height*0.85,
      child: ReorderableListView(
        shrinkWrap: false,
        padding: EdgeInsets.all(0),
        children: listRutGunleri.map((e) =>ListTile(
          enabled: true,
          contentPadding: const EdgeInsets.all(0).copyWith(left: 10,bottom: 5,right: 10),
          splashColor: Colors.orange,
          title: _listItem(e),
          key: ValueKey(e.code),
        )).toList(),
        onReorder: (oldIndex,newIndex){
          _changeListOrder(oldIndex,newIndex);
        },
      ),
    );
  }

  void _changeListOrder(int oldIndex, int newIndex) {
  setState(() {
    if(oldIndex<newIndex){
      newIndex--;
    }
    ModelCariler model=listRutGunleri.removeAt(oldIndex);
    listRutGunleri.insert(newIndex, model);
    deyisiklikEdildi=true;
  });
  }

  _listItem(ModelCariler e) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      boxShadow:  const [
        BoxShadow(
          color: Colors.black,
          offset: Offset(0,0),
          spreadRadius: 0.2,
          blurRadius: 5,
          blurStyle: BlurStyle.outer
        )
      ],
      color: Colors.white.withOpacity(0.5),
      border: Border.all(color: Colors.black.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(10)
    ),
    child: Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.all(0.0).copyWith(top: 5,left: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: CustomText(

                            labeltext: (listRutGunleri.indexOf(e)+1).toString()),
                      ),

                    ),
                    SizedBox(width: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.7,
                        child: CustomText(labeltext:  e.name!,maxline: 2,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.drag_handle_outlined))
        ],
      ),
    ]),
    // decoration: BoxDecoration(
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.grey,
    //       blurRadius: 1,
    //       spreadRadius: 2,
    //       offset: Offset(5,5)
    //     )
    //   ]
    // ),

  );
  }

}
