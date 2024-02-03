import 'package:flutter/material.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/connected_users/controller_rout_detail_user.dart';
import 'package:zs_managment/companents/giris_cixis/controller_giriscixis_yeni.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

class ScreenUserRoutPerform extends StatefulWidget {
  ControllerRoutDetailUser controllerRoutDetailUser;

  ScreenUserRoutPerform({required this.controllerRoutDetailUser, super.key});

  @override
  State<ScreenUserRoutPerform> createState() => _ScreenUserRoutPerformState();

}

class _ScreenUserRoutPerformState extends State<ScreenUserRoutPerform> {
  bool mustSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          mustSearch?IconButton(
            icon: const Icon(Icons.clear),
            onPressed: (){
              setState(() {
                mustSearch=false;
                widget.controllerRoutDetailUser.filterCustomersBySearchView("");
              });
            },
          ):IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: (){
              setState(() {
                mustSearch=true;
              });
            },
          ),
          mustSearch?SizedBox():IconButton(onPressed: (){
            Get.toNamed(RouteHelper.screenExpRoutDetailMap,arguments: widget.controllerRoutDetailUser);
          }, icon: const Icon(Icons.map,color: Colors.green,)),
          mustSearch?SizedBox():IconButton(onPressed: (){}, icon: const Icon(Icons.filter_alt_outlined,)),

        ],
        elevation: 0,
        centerTitle: true,
        title: mustSearch?searchField():CustomText(labeltext: "Cariler"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Obx(() => SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.085,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                widget.controllerRoutDetailUser.listTabSifarisler.length,
                itemBuilder: (context, index) {
                  return tabItemsList(widget
                      .controllerRoutDetailUser.listTabSifarisler
                      .elementAt(index));
                }),
          ),
          const SizedBox(height: 10,),
          Obx(() =>  SizedBox(
            height: MediaQuery.of(context).size.height * 0.78,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.controllerRoutDetailUser.listFilteredCustomers.length,
                itemBuilder: (context, index) {
                  return  customersListItems(widget.controllerRoutDetailUser.listFilteredCustomers.elementAt(index));
                }),
          ))
        ],
      ),
    ));
  }

  Widget tabItemsList(ModelSifarislerTablesi element) {
    return Obx(() => InkWell(
      onTap: (){
        widget.controllerRoutDetailUser.changeSelectedTabItems(element);
      },
      child: Card(
          margin: const EdgeInsets.all(5).copyWith(left: 7,right: 7),
          shadowColor: element.color,
          elevation: widget.controllerRoutDetailUser.selectedTab.value.type==element.type?5:1,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  labeltext: element.label!,
                  fontWeight: FontWeight.w600,
                  fontsize: widget.controllerRoutDetailUser.selectedTab.value.type==element.type?16:14,
                ),
                Container(
                  width: element.label!.length * 8,
                  color: element.color,
                  height: 1,
                ),
                CustomText(labeltext: element.summa.toString())
              ],
            ),
          )),
    ));
  }

  Widget customersListItems(ModelCariler element) {
    int valuMore=0;
    if(element.day1.toString()=="1"){
      valuMore=valuMore+1;
    }
    if(element.day2.toString()=="1"){
      valuMore=valuMore+1;
    }  if(element.day3.toString()=="1"){
      valuMore=valuMore+1;
    }  if(element.day4.toString()=="1"){
      valuMore=valuMore+1;
    }  if(element.day5.toString()=="1"){
      valuMore=valuMore+1;
    } if(element.day6.toString()=="1"){
      valuMore=valuMore+1;
    }
    return InkWell(
      onTap: (){
        widget.controllerRoutDetailUser.showEditDialog(element,context);
      },
      child: Card(
        elevation: 10,
        color: Get.isDarkMode?Colors.black:Colors.white,
          margin: const EdgeInsets.all(10),
          shadowColor: Colors.blue,
          borderOnForeground: true,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 15,left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(labeltext: element.name!,fontWeight: FontWeight.w600,maxline: 2,),
                    const SizedBox(height: 2,),
                    const Divider(height: 1,color: Colors.grey,),
                    Row(
                      children: [
                        CustomText(labeltext: "${"mesulsexs".tr} : ",   color: Colors.grey,
                          fontWeight: FontWeight.w600,),
                        Expanded(child: CustomText(labeltext: element.ownerPerson!,overflow: TextOverflow.clip,maxline: 2,fontsize: 12)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          labeltext: "${"Rut gunu".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(width: 5,),
                        SizedBox(
                          height: valuMore>4?60:25,
                          width: 250,
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            children: [
                              element.day1.toString() == "1"
                                  ? WidgetRutGunu(rutGunu:"gun1".tr)
                                  : const SizedBox(),
                              element.day2.toString() == "1"
                                  ? WidgetRutGunu(rutGunu:"gun2".tr)
                                  : const SizedBox(),
                              element.day3.toString() == "1"
                                  ? WidgetRutGunu(rutGunu:"gun3".tr)
                                  : const SizedBox(),
                              element.day4.toString() == "1"
                                  ? WidgetRutGunu(rutGunu:"gun4".tr)
                                  : const SizedBox(),
                              element.day5.toString() == "1"
                                  ? WidgetRutGunu(rutGunu: "gun5".tr)
                                  : const SizedBox(),
                              element.day6.toString() == "1"
                                  ? WidgetRutGunu(rutGunu:"gun6".tr)
                                  : const SizedBox(),
                              element.day7.toString() == "1"
                                  ? WidgetRutGunu(rutGunu:"bagli".tr)
                                  : const SizedBox(),
                            ],
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        CustomText(labeltext: "${"borc".tr} : ", color: Colors.grey,
                            fontWeight: FontWeight.w600,),
                        Expanded(child: CustomText(labeltext: "${element.debt!} ${"manatSimbol".tr}",overflow: TextOverflow.clip,maxline: 2,fontsize: 12,
                        color: element.debt.toString()=="0"||element.debt.toString().contains("-")?Colors.blue:Colors.red,fontWeight: FontWeight.w700,)),
                      ],
                    ),


                  ],
                ),
              ),
              Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: element.action==false?Colors.red:Colors.green
                ),
                    child: element.orderNumber==0?const SizedBox():Center(child: CustomText(labeltext: element.orderNumber.toString()??"0",color: Colors.white,)),
              )),
              Positioned(
                  right: 2,
                  top: 2,
                  child: Row(
                    children: [
                      CustomText(labeltext: element.code!,fontsize: 10),
                      InkWell(
                          onTap: (){
                            Get.toNamed(RouteHelper.getwidgetScreenMusteriDetail(),arguments: [element,widget.controllerRoutDetailUser.availableMap.value]);
                          },
                          child: const Icon(Icons.more_vert,color: Colors.blue,size: 20,)),
                    ],
                  ))
            ],
          )),
    );
  }


  Widget searchField() {
    return SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: widget.controllerRoutDetailUser.ctSearch,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textAlign: TextAlign.center,
          onChanged: (st) {
            widget.controllerRoutDetailUser.filterCustomersBySearchView(st);
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: "axtar".tr,
            contentPadding: const EdgeInsets.all(0),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.redAccent)),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ));
  }

}
