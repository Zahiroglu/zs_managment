import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_userconnnection.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/delete_user/screen_delete_user.dart';
import 'package:zs_managment/companents/users_panel/mobile/screen_changeid_password_mobile.dart';
import 'package:zs_managment/companents/users_panel/mobile/screen_update_user_mobile.dart';
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
                       dividerColor: Colors.transparent,
                       indicator: BoxDecoration(
                         color: Colors.white,
                         boxShadow: const [
                           BoxShadow(
                             color: Colors.black26,
                             blurRadius: 5,
                             offset: Offset(1,1),
                             spreadRadius: 1
                           )
                         ],
                         //border: Border.all(color: Colors.white),
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
          widget.model.gender == 0
              ? "images/imageman.png"
              : "images/imagewoman.png",
          width: 60,
          height: 60,
        ),
      ),
      SizedBox(
        height: 5,
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
        padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 5),
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
              padding:  EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Padding(
                  padding:  EdgeInsets.only(left: 2,top: 5),
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
                  padding:  EdgeInsets.only(left: 2,top: 5),
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
                  padding:  EdgeInsets.only(left: 2,top: 5),
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
                  padding:  EdgeInsets.only(left: 2,top: 5),
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
                  padding:  EdgeInsets.only(left: 2,top: 5),
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
                  padding:  const EdgeInsets.only(left: 2,top: 5),
                  child: SizedBox(
                    // width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext:"usersStatus".tr,color: Colors.black.withOpacity(1), ),
                        Row(
                          children: [
                            widget.model.usernameLogin==true?Row(
                              children: [
                                CustomText(labeltext: "WINDOWS",color: Colors.white, ),
                                IconButton(onPressed: (){
                                  Get.dialog(ChangePasswordAndDviceIdMobile(changeType: 0,modelUser: widget.model,));
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
            const SizedBox(height: 2,),
            const Divider(height: 0.5,color: Colors.white,thickness: 0.3,indent: 10,endIndent: 10,),
            const SizedBox(height: 2,),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 0,
          ),
          Container(
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5)
              ),
              child: Center(child: CustomText(labeltext: "Menular"+" ("+widget.model.permissions!.where((a) => a.category==1).length.toString()+")"))),
          Expanded(child: ListView(
            children: widget.model.permissions!.where((a) => a.category==1).map((e) => itemsPermitions(e)).toList(),
          )),
          Container(
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5)
              ),
              child: Center(child: CustomText(labeltext: "Diger icezeler"+" ("+widget.model.permissions!.where((a) => a.category!=1).length.toString()+")"))),
          Expanded(child: ListView(
            children: widget.model.permissions!.where((a) => a.category!=1).map((e) => itemsPermitions(e)).toList(),
          ))
        ],
      ),
    );
  }

  Widget itemsPermitions(ModelUserPermissions e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 15, 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 11,
                  child: CustomText(
                      maxline: 2,
                      labeltext: "${e.name} : ",color: Colors.black,fontsize: 14,fontWeight: FontWeight.w500)),
              const SizedBox(width: 2,),
              Expanded(
                  flex: 3,
                  child: CustomText(
                      maxline: 2,
                      labeltext: "${e.valName.toString()}",color: Colors.white,fontsize: 14,fontWeight: FontWeight.w800)),
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
      margin:  EdgeInsets.only(left: 5,right: 5,bottom: 5),
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
