import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/app_companents/windows/custom_drawer.dart';
import 'package:zs_managment/app_companents/windows/screen_usersreport.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/utils/dilsecimi_dropdown.dart';
import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/service/shared_manager.dart';
import 'package:zs_managment/rout/rout_controller.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';

class BaseScreen extends StatefulWidget {
  LoggedUserModel userModel;
  BaseScreen({required this.userModel,Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late var pageView;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  int drawerWidget = 1;
  bool isMenuExpended = false;
  late SharedManager sharedManager=SharedManager();
  late LoggedUserModel modelUser = LoggedUserModel();
  bool isLoading = true;

  @override
  void initState() {
    pageView = const Placeholder();
    modelUser=widget.userModel;
    print("Screen logged user:"+widget.userModel.userModel.toString());
    sharedManager.init();
    // modelUser=sharedManager.getLoggedUser();
    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Material(
      child:
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return Scaffold(
          key: _key,
          body: Column(
            children: [
              widgetHeader(localizationController),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: isMenuExpended?200:80,
                        maxWidth: isMenuExpended?200:80
                      ),
                      child: Drawer(
                        elevation: 0,
                        child: CustomDrawer(
                          listPermisions: widget.userModel.userModel!.permissions!,
                          expandMenuItems: isMenuExpended,
                          data: (va) {
                            changeIndex(va);
                          },
                          logout: (val) {
                            if(val){
                              Get.offNamed(RouteHelper.getWellComeScreen());
                              sharedManager.cleareAllInfo();
                                print("cixis ucun button basoldi");
                             // });
                            }
                          },
                          scaffoldkey: _key,
                          appversion: '0.1',
                          initialSelected: -1,
                          closeDrawer: (val) {
                            if (val) {
                              setState(() {
                                _key.currentState!.openDrawer();
                                drawerWidget = 4;
                                isMenuExpended = true;
                              });
                            } else {
                              setState(() {
                                _key.currentState!.closeDrawer();
                                drawerWidget = 1;
                                isMenuExpended = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(child: pageView)
                  ],
                ),
              ),
              widgetFooter(),
            ],
          ),
        );
      }),
    );
  }

  Widget widgetHeader(LocalizationController localizationController) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      alignment: Alignment.centerRight,
      height: ResponsiveBuilder.mainHeight(context) * 0.08,
      width: ResponsiveBuilder.mainWidh(context),
      decoration:  BoxDecoration(
        color: localizationController.isDark?ThemeData.dark().canvasColor:ThemeData.light().canvasColor,
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.1,
              blurRadius: 2,
              offset: Offset(1.2, 0.8))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         widgetMenuDrawerOpen(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    maxRadius: 15,
                    minRadius: 10,
                    child: Icon(EvaIcons.personDone),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              color: localizationController.isDark?Colors.white:Colors.black,
                              labeltext: modelUser.userModel!.name.toString().toUpperCase()??
                                  'Username',
                              fontsize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            CustomText(
                                color: localizationController.isDark?Colors.white:Colors.black,
                                labeltext:
                                modelUser.userModel!.roleName.toString().toUpperCase() ??
                                        'admin',
                                fontsize: 10),
                          ],
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              WidgetDilSecimi(localizationController: localizationController),
              const SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: localizationController.isDark?IconButton(
                    onPressed: (){
                      setState(() {
                        localizationController.toggleTheme(false);
                      });
                    }, icon: const Icon(Icons.light_mode_outlined,color: Colors.white,))
                    :IconButton(onPressed: (){
                  setState(() {
                    localizationController.toggleTheme(true);
                  });

                }, icon: const Icon(Icons.dark_mode_outlined,color: Colors.black,)),),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget widgetMenuDrawerOpen() {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth:270,
            minHeight : ResponsiveBuilder.mainHeight(context) * 0.09,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50))),

          ),
        ),
        SizedBox(
          width: 280,
          height: ResponsiveBuilder.mainHeight(context) * 0.9,
          child: Row(
        children: [
        CircleAvatar(
        maxRadius: 15,
          minRadius: 10,
          child: Image.asset("images/zs2.png"),
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              labeltext: AppConstands.appName,
              fontWeight: FontWeight.bold,
              fontsize: 12,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomText(
                color: Colors.white,
                labeltext: 'nezsystem',
                fontWeight: FontWeight.bold,
                maxline: 2,
                fontsize: 14),
          ],
        )
      ],
    ),
        ),
        isMenuExpended
            ? const SizedBox()
            : Positioned(
                top: ResponsiveBuilder.mainHeight(context) * 0.015,
                right: 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isMenuExpended = true;
                      drawerWidget = 4;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(2, 0),
                            spreadRadius: 2,
                            blurRadius: 5)
                      ],
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white60),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ))
      ],
    );
  }

  void changeIndex(int drawerIndexdata) {
    if (drawerIndexdata == 0) {
      setState(() {
        pageView=const Placeholder();
      });
    } else if (drawerIndexdata ==1) {
      setState(() {
        pageView=ScreenUserControl();
      });
    }else if(drawerIndexdata==2){
      setState(() {
      });

    }

  }

  Widget widgetFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: Colors.black,width: 0.2))
      ),
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(labeltext: 'developed',fontsize: 12),
          const SizedBox(width: 5,),
          CustomText(labeltext: "| Version : 0.0.1",fontWeight: FontWeight.w600),
        ],
      ),
    );


  }
}



