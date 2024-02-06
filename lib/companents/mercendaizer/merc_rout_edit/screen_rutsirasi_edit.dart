import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zs_managment/companents/mercendaizer/model_mercbaza.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenMercRutSirasiEdit extends StatefulWidget {
  List<ModelMercBaza> listRutGunleri;
  ScreenMercRutSirasiEdit({required this.listRutGunleri,super.key});

  @override
  State<ScreenMercRutSirasiEdit> createState() => _ScreenMercRutSirasiEditState();
}

class _ScreenMercRutSirasiEditState extends State<ScreenMercRutSirasiEdit> {
  List<ModelMercBaza> listRutGunleri=[];
  bool isStart=false;

@override
  void initState() {
  for (var element in widget.listRutGunleri) {
      listRutGunleri.add(element);
  }
  final Map<String, ModelMercBaza> profileMap = {};
  for (var item in widget.listRutGunleri) {
    profileMap[item.cariad!] = item;
  }
  listRutGunleri = profileMap.values.toList();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(child:  Scaffold(
      appBar: AppBar(),
      body: _body(listRutGunleri),
    ));
  }

  _body(List<ModelMercBaza> listRutGunleri) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.9,
      child: ReorderableListView(
        shrinkWrap: false,
        onReorderEnd: _recordStop(),
        onReorderStart: _recordStart(),
        padding: EdgeInsets.all(0),
        children: listRutGunleri.map((e) =>ListTile(
          enabled: true,
          contentPadding: const EdgeInsets.all(0).copyWith(left: 10,bottom: 5,right: 10),
          splashColor: Colors.orange,
          title: _listItem(e),
          key: ValueKey(e.carikod),
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
    ModelMercBaza model=listRutGunleri.removeAt(oldIndex);
    listRutGunleri.insert(newIndex, model);
  });
  }

  _listItem(ModelMercBaza e) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      boxShadow:  [
        BoxShadow(
          color:isStart?Colors.green: Colors.black,
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
                        child: CustomText(labeltext:  e.cariad!,maxline: 2,overflow: TextOverflow.ellipsis)),
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

  _recordStart() {
  setState(() {
    isStart==false;
  });
  }

  _recordStop() {
    setState(() {
      isStart==true;
    });
  }

}
