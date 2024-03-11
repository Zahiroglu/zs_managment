import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/model_mercbaza.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenMercRutSirasiEdit extends StatefulWidget {
  List<MercCustomersDatail> listRutGunleri;
  String rutGunu;
  int rutGunuInt;
  ScreenMercRutSirasiEdit({required this.listRutGunleri,required this.rutGunu,required this.rutGunuInt,super.key});

  @override
  State<ScreenMercRutSirasiEdit> createState() => _ScreenMercRutSirasiEditState();
}

class _ScreenMercRutSirasiEditState extends State<ScreenMercRutSirasiEdit> {
  List<MercCustomersDatail> listRutGunleri=[];
  bool deyisiklikEdildi=false;

@override
  void initState() {

  for (var element in widget.listRutGunleri) {
      listRutGunleri.add(element);
  }
  melumatlariFilterle( widget.listRutGunleri);
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

  _body(List<MercCustomersDatail> listRutGunleri) {
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
    MercCustomersDatail model=listRutGunleri.removeAt(oldIndex);
    model.days.where((element) => element.day==widget.rutGunuInt).first.day==newIndex;
    listRutGunleri.insert(newIndex, model);
    deyisiklikEdildi=true;
  });
  melumatlariFilterle(listRutGunleri);
  }

  _listItem(MercCustomersDatail e) {
  return Container(
    height: 120,
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
                    const SizedBox(width: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.7,
                        child: CustomText(labeltext:  e.name.toString(),maxline: 2,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.drag_handle_outlined))
        ],
      ),
      Positioned(
          bottom: 0,
          child: SizedBox(
              width: 300,
              child: Expanded(child: CustomText(labeltext: e.days.toString(),maxline: 5,fontsize: 10,))))
    ]),

  );
  }

  void melumatlariFilterle(List<MercCustomersDatail> listRutGunleri) {
    final Map<int, MercCustomersDatail> profileMap = {};
    for (var item in listRutGunleri) {
      profileMap[item.days.where((element) => element.day==widget.rutGunuInt).first.orderNumber] = item;
    }
    profileMap.keys.toList().sort(((a, b) => b.compareTo(a)));
    listRutGunleri = profileMap.values.toList();
    listRutGunleri = widget.listRutGunleri;
    setState(() {});
  }

}
