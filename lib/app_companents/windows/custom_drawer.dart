import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/drawer/model_drawerItems.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/customwidgets/sual_dialog.dart';
import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/models/model_token.dart';
import 'package:zs_managment/login/models/model_userspormitions.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:zs_managment/login/service/shared_manager.dart';
import 'package:zs_managment/rout/rout_controller.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import '../drawer/selection_buttondrawer.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({
    required this.listPermisions,
    required this.appversion,
    required this.closeDrawer,
    required this.data,
    required this.scaffoldkey,
    required this.logout,
    required this.initialSelected,
    required this.expandMenuItems,
    this.isMobile=false,
    Key? key,
  }) : super(key: key);

  final String appversion;
  final int initialSelected;
  final Function(bool) logout;
  final Function(int index) data;
  final Function(bool clouse) closeDrawer;
  final GlobalKey<ScaffoldState> scaffoldkey;
  final expandMenuItems;
  bool isMobile;
  List<ModelUserPermissions> listPermisions;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<SelectionButtonData> listScreens=[];
  bool menuLoading=true;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    createDrawerItemsItems();
  }



  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      //backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            margin:  EdgeInsets.only(top: widget.isMobile?0.h:50.h, bottom: widget.isMobile?0.h:50.h,right: 5.w),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(1,1)
                ),
              ],
              borderRadius:  BorderRadius.only(
                  topRight: Radius.circular(widget.isMobile?0:100),
                  bottomRight: Radius.circular(widget.isMobile?0:100)),
              color: Colors.blue.withOpacity(0.7),
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:  EdgeInsets.only(right: 0.w,left: 0.w, top: widget.isMobile?40.h:15.h),
                  child: Center(
                    child: widget.expandMenuItems
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                  labeltext: "menular".tr,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.closeDrawer(false);
                                    widget.expandMenuItems == false;
                                  });
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(EvaIcons.arrowBack),
                                ),
                              )
                            ],
                          )
                        :  CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        widget.closeDrawer(true);
                                        widget.expandMenuItems == true;
                                      });
                                    },
                                    child: const Icon(EvaIcons.arrowForward)),
                              ),
                            ),
                          ),
                  ),
                ),
                const Divider(thickness: 1),
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(
                        children: [
                          menuLoading? widgetMenuItems():const SizedBox(),
                        ],
                      )),
                ),
                const Divider(thickness: 1),
                Expanded(flex: 1, child: widgetLogOut(context)),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding widgetLogOut(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          elevation: 0,
          minimumSize:  Size(100.w, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ShowSualDialog(
                    messaje: "cmeminsiz".tr,
                    callBack: (val) {
                      if(val) {
                        setState(() {
                          print("Cixis ucun Buton basildi");
                          widget.logout.call(val);
                          //Get.offNamed(RouteHelper.getWellComeScreen());
                        });
                      }
                    });
              });
        },
        child: Padding(
          padding: EdgeInsets.all(widget.expandMenuItems?5.0:0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.logout),
              widget.expandMenuItems?const SizedBox(width: 5,):const SizedBox(),
              widget.expandMenuItems
                  ? CustomText(labeltext: "cixiset".tr,fontWeight: FontWeight.w600,color: Colors.white,)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Center widgetMenuItems() {
    return Center(
      child: SelectionButton(
        isExpendet: widget.expandMenuItems,
        initialSelected: widget.initialSelected,
        data: listScreens,
        onSelected: (index, value) {
          setState(() {
            widget.data.call(index);
            if (widget.expandMenuItems == true) {
              widget.closeDrawer(false);
            }
          });
        },
      ),
    );
  }

  void createDrawerItemsItems() {
    for(ModelUserPermissions permissions in widget.listPermisions){
      if(permissions.screen!){
        IconData icon=IconData(permissions.icon!, fontFamily: 'MaterialIcons');
        IconData iconSelected=IconData(permissions.selectIcon!,fontFamily: 'MaterialIcons');
        listScreens.add(SelectionButtonData(activeIcon: iconSelected,icon: icon,label: permissions.name));
      }
      setState(() {
      });
    }



  }
}
