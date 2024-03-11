import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_userconnnection.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/controller/user_mainscreen_controller.dart';
import 'package:zs_managment/companents/users_panel/delete_user/screen_delete_user.dart';
import 'package:zs_managment/companents/users_panel/mobile/screen_changeid_password_mobile.dart';
import 'package:zs_managment/companents/users_panel/mobile/screen_update_user_mobile.dart';
import 'package:zs_managment/companents/users_panel/other_screens/screen_changeid_password.dart';
import 'package:zs_managment/companents/users_panel/update_users/screen_update_user.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenUserInfoMobile extends StatefulWidget {
  LoggedUserModel loggedUserModel;
  double sizeWidght;
  UserModel model;
  Function() callClouse;
  Function() deleteCall;

  ScreenUserInfoMobile(
      {required this.callClouse,
      required this.sizeWidght,
      required this.model,
        required this.loggedUserModel,
        required this.deleteCall,
      Key? key})
      : super(key: key);

  @override
  State<ScreenUserInfoMobile> createState() => _ScreenUserInfoMobileState();
}

class _ScreenUserInfoMobileState extends State<ScreenUserInfoMobile> with SingleTickerProviderStateMixin{
  late PageController controller;
  List<String> listMelumatlar = ["Genel Melumatlar", "Baglantilar", "Icazeler"];
  int selectedPageIndex = 0;
  TextEditingController ctUsername=TextEditingController();
  late TabController tabController;
  //UserConectionController userConectionController=UserConectionController();
  //UserAccessController userAccessController=UserAccessController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: 0, keepPage: true);
    controller.addListener(() {
     controller.jumpToPage( tabController.index);
    });
    tabController=TabController(length: listMelumatlar.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedPageIndex = tabController.index;
        controller.jumpToPage( tabController.index);

      });
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    ctUsername.dispose();
    tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:_body(),
      ),
    );

  }

  Widget _body(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Stack(
          children: [
            Column(
              children: [
               Column(
                 children: [
                   SizedBox(height: 20,width: MediaQuery.of(context).size.width,),
                   headerInfoUser(),
                   Container(
                     padding: const EdgeInsets.all(2),
                     decoration: BoxDecoration(
                         border: Border.all(color: Colors.white),
                         borderRadius: const BorderRadius.all(Radius.circular(10))
                     ),
                     margin:  const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                     //padding: const EdgeInsets.all(5),
                     height: 60,
                     child: TabBar(
                       indicator: BoxDecoration(
                         border: Border.all(color: Colors.white),
                           //color: Colors.white.withOpacity(0.8),
                           borderRadius:  BorderRadius.circular(10.0)
                       ) ,
                       labelColor: Colors.black,
                       unselectedLabelColor: Colors.transparent,
                       //indicatorSize: TabBarIndicatorSize.tab,
                       padding: const EdgeInsets.all(2),
                       controller: tabController,
                       tabs: listMelumatlar.map((e) => Center(child: Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: CustomText(labeltext: e.tr,textAlign: TextAlign.center,maxline: 2,),
                       ))).toList(),),
                   ),
                   const SizedBox(height: 5,),
                 ],
               ),
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  child: PageView(
                    controller: controller,
                    children: [
                      widgetGenralInfo(),
                      widgetBaglantilarInfo(),
                      widgetPermisonsInfo()
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: widgetFooter()),
      
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: widgetClouse()),
          ],
        ),
      ),
    );
  }

  ConstrainedBox widgetClouse() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 40,
          minWidth: 120
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
              setState(() {
                tabController.index=0;

              });
            },
          ),
        ],
      ),
    );
  }

  Widget headerInfoUser(){
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset(
          widget.model.gender == "Kisi"
              ? "images/imageman.png"
              : "images/imagewoman.png",
          width: 60.w,
          height: 60.h,
        ),
      ),
      SizedBox(
        height: 5.h,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomText(
          textAlign: TextAlign.center,
          maxline: 2,
          labeltext: "${widget.model.name.toString().toUpperCase()} ${widget.model.surname.toString().toUpperCase()}",
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontsize: 16,
        ),
      ),
      Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
        child: CustomText(
          textAlign: TextAlign.center,
          maxline: 1,
          labeltext: "${widget.model.roleName.toString().toUpperCase()} ( ${widget.model.moduleName.toString().toUpperCase()} )",
          color: Colors.black45,
          fontsize: 14,
        ),
      ),
    ],);
  }

  Widget widgetGenralInfo() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10.h),
              child: Column(children: [
                Padding(
                  padding:  EdgeInsets.only(left: 2.w,top: 5.h),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext:"userPhone".tr,color: Colors.black.withOpacity(0.5), ),
                        const SizedBox(height: 5,),
                        CustomText(labeltext: widget.model.phone.toString(),color: Colors.white, ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 2.w,top: 5.h),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext:"lastAktivdate".tr,color: Colors.black.withOpacity(0.5), ),
                        const SizedBox(height: 5,),
                        CustomText(labeltext: "widget.model.lastOnlineDate.toString()",color: Colors.white, ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 2.w,top: 5.h),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext:"email".tr,color: Colors.black.withOpacity(0.5), ),
                        const SizedBox(height: 5,),
                        CustomText(labeltext: widget.model.email.toString(),color: Colors.white, ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 2.w,top: 5.h),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext:"birthDay".tr,color: Colors.black.withOpacity(0.5), ),
                        const SizedBox(height: 5,),
                        CustomText(labeltext: widget.model.birthdate.toString(),color: Colors.white, ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 2.w,top: 5.h),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext:"userGender".tr,color: Colors.black.withOpacity(0.5), ),
                        const SizedBox(height: 5,),
                        CustomText(labeltext: widget.model.gender.toString()=="0"?"kisi".tr:"qadin".tr,color: Colors.white, ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 2.w,top: 5.h),
                  child: SizedBox(
                    // width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext:"usersStatus".tr,color: Colors.black.withOpacity(1), ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            widget.model.usernameLogin.toString()=="true"?Row(
                              children: [
                                CustomText(labeltext: "WINDOWS",color: Colors.white, ),
                                IconButton(onPressed: (){
                                  Get.dialog(ChangePasswordAndDviceId(changeType: 0,modelUser: widget.model,));
                                }, icon: const Icon(Icons.change_circle_outlined))
                              ],
                            ):const SizedBox(),
                            const SizedBox(width: 5,),
                            widget.model.deviceLogin.toString()=="true"?Container(
                              width: 2,
                              height: 20,
                              color: Colors.black38,
                            ):const SizedBox(),
                            const SizedBox(width: 10,),
                            widget.model.deviceLogin.toString()=="true"?Row(
                              children: [
                                CustomText(labeltext: "MOBILE",color: Colors.white, ),
                                IconButton(onPressed: (){
                                  Get.dialog(ChangePasswordAndDviceIdMobile(changeType: 1,modelUser: widget.model,));
                                }, icon: const Icon(Icons.change_circle_outlined))
                                // Checkbox(value: widget.model.deviceLogin!?true:false, onChanged: (value){})
                              ],
                            ):const SizedBox(),
                          ],
                        )

                      ],
                    ),
                  ),
                )
              ],),
            )

          ],
        ),
      ),
    );
  }

  Widget widgetBaglantilarInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 10),
              child: SizedBox(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(labeltext:"${"region".tr} : ",color: Colors.black,fontsize: 18, ),
                    const SizedBox(width: 5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(labeltext: widget.model.regionName.toString(),color: Colors.white,fontsize: 24,fontWeight: FontWeight.bold, ),
                        const SizedBox(width: 5,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(height: 2,color: Colors.white,thickness: 1,),
            ),
            Expanded(child: ListView(
              children: widget.model.connections!.map((e) => itemsConnections(e)).toList(),
            ),),
          ],
        ),
      ),
    );
  }

  Widget itemsConnections(ModelUserConnection e){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 15, 5),
      child: Column(
        children: [
          Row(
            children: [
              CustomText(labeltext: "${e.roleName} : ",color: Colors.black,fontsize: 16,fontWeight: FontWeight.w500),
              const SizedBox(width: 5,),
              CustomText(labeltext: "${e.fullName}",color: Colors.white,fontsize: 16,fontWeight: FontWeight.w800),
            ],
          ),
          const SizedBox(height: 5,),
          Container(
            height: 0.5,
            decoration:  BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 1,
                  spreadRadius: 0.1
                )
              ]
            ),
              width: MediaQuery.of(context).size.width,)
        ],
      ),
    );
  }

  Widget widgetPermisonsInfo() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(child: ListView(
            children: widget.model.permissions!.map((e) => itemsPermitions(e)).toList(),
          ))
        ],
      ),
    );
  }

  Widget itemsPermitions(ModelUserPermissions e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        children: [
          Row(
            children: [
              CustomText(labeltext: "${e.name} : ",color: Colors.black,fontsize: 12,fontWeight: FontWeight.w500),
              const SizedBox(width: 5,),
              CustomText(labeltext: "${e.valName.toString()}",color: Colors.white,fontsize: 12,fontWeight: FontWeight.w800,maxline: 2),
            ],
          ),
          const SizedBox(height: 5,),
          Container(
            height: 0.5,
            decoration:  BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.4),
                      blurRadius: 1,
                      spreadRadius: 0.1
                  )
                ]
            ),
            width: MediaQuery.of(context).size.width,)
        ],
      ),
    );

  }


  Widget widgetFooter() {
    return Container(
      margin:  EdgeInsets.only(left: 5.w,right: 5.w,bottom: 5.h),
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: CustomElevetedButton(
              height: 40,
                elevation: 10,
                borderColor: Colors.red,
                icon: Icons.delete,
                textColor: Colors.red,
                hasshadow: true,
                cllback: (){
                  Get.dialog(ScreenDeleteUser(modelUser: widget.model,loggedUserModel: widget.loggedUserModel,deleteCall: (){
                    widget.deleteCall.call();
                    widget.callClouse.call();
                    setState(() {
                      tabController.index=0;
                    });
                  },));

                }, label: "delete".tr, surfaceColor: Colors.white),
          ),
          const SizedBox(width: 40,),
          Expanded(
            flex: 1,
            child: CustomElevetedButton(
                textColor: Colors.yellow,
                elevation: 15,
                borderColor: Colors.white,
                height: 40,
                icon: Icons.update,
                cllback: (){
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return  ScreenUpdateUserMobile(model: widget.model);
                        });
                  });
                }, label: "update".tr, surfaceColor: Colors.blueAccent),
          )
        ],

      ),
    );

  }
}
