import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/windows/admin_usercontrol/controller/useraccesController.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/customwidgets/customElevetedButton.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ScreenUserInfo extends StatefulWidget {
  double sizeWidght;
  UserModel model;
  Function() callClouse;

  ScreenUserInfo(
      {required this.callClouse,
      required this.sizeWidght,
      required this.model,
      Key? key})
      : super(key: key);

  @override
  State<ScreenUserInfo> createState() => _ScreenUserInfoState();
}

class _ScreenUserInfoState extends State<ScreenUserInfo> with SingleTickerProviderStateMixin{
  late PageController controller;
  List<String> listMelumatlar = ["Genel Melumatlar", "Baglantilar", "Icazeler"];
  int selectedPageIndex = 0;
  TextEditingController ctUsername=TextEditingController();
  late TabController tabController;
  //UserConectionController userConectionController=UserConectionController();
  UserAccessController userAccessController=UserAccessController();

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
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))

          ),
          height:  ResponsiveBuilder.mainHeight(context)-ResponsiveBuilder.mainHeight(context)/8,
          width: widget.sizeWidght,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))
          ),
          height: ResponsiveBuilder.mainHeight(context)-ResponsiveBuilder.mainHeight(context)/8,
          width: widget.sizeWidght,
          child: Column(
            children: [
              widgetClouse(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                //padding: const EdgeInsets.all(5),
                height: 50,
                child: TabBar(
                  indicator: BoxDecoration(
                    //border: Border.all(color: Colors.black),
                      color: Colors.white.withOpacity(0.8),
                      borderRadius:  BorderRadius.circular(10.0)
                  ) ,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  //indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.all(2),
                  controller: tabController,
                  //tabs: listMelumatlar.map((e) => Center(child: CustomText(labeltext: e.tr,fontsize: 14,maxline: 2,textAlign: TextAlign.center,))).toList(),),
                  tabs: listMelumatlar.map((e) => Center(child: Text(e.tr,textAlign: TextAlign.center,style: TextStyle(fontSize: 14),))).toList(),),
              ),
              const SizedBox(height: 10,),
              Expanded(
                flex: 18,
                child: PageView(
                  controller: controller,
                  children: [
                    widgetGenralInfo(),
                    widgetBaglantilarInfo(),
                    widgetPermisonsInfo()
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: widgetFooter(),
              )
            ],
          ),
        ),
      ],
    );
  }

  ConstrainedBox widgetClouse() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 50,
          minWidth: 120
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 20,
            icon: const Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              widget.callClouse.call();
              setState(() {
                tabController.index=0;

              });
            },
          ),
          const SizedBox(
            width: 2,
          ),
          CustomText(
            labeltext: "clouse".tr,
            color: Colors.white,
          )
        ],
      ),
    );
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
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                widget.model.gender == "Kisi"
                    ? "images/imageman.png"
                    : "images/imagewoman.png",
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                textAlign: TextAlign.center,
                maxline: 2,
                labeltext: widget.model.username.toString().toUpperCase(),
                color: Colors.white,
                fontsize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: CustomText(
                textAlign: TextAlign.center,
                maxline: 1,
                labeltext: "${widget.model.roleName.toString().toUpperCase()} (${"widget.model.departamentName"})",
                color: Colors.black,
                fontsize: 14,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Divider(height: 1,color: Colors.white,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15,top: 10),
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
                  padding: const EdgeInsets.only(left: 15,top: 10),
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
                  padding: const EdgeInsets.only(left: 15,top: 10),
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
                  padding: const EdgeInsets.only(left: 15,top: 10),
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
                  padding: const EdgeInsets.only(left: 15,top: 10),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext:"userGender".tr,color: Colors.black.withOpacity(0.5), ),
                        const SizedBox(height: 5,),
                        CustomText(labeltext: widget.model.gender.toString(),color: Colors.white, ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15,top: 10),
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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 10),
            child: SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(labeltext:"${"region".tr} : ",color: Colors.black.withOpacity(0.5),fontsize: 18, ),
                  const SizedBox(width: 5,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(labeltext: "widget.model.regionName.toString()",color: Colors.white,fontsize: 24,fontWeight: FontWeight.bold, ),
                      const SizedBox(width: 5,),
                      //CustomText(labeltext: "(${"${"regworkercount".tr} "}${UserModel().getUsersList().where((element) => element.regionId==widget.model.regionId).toList().length})",color: Colors.black.withOpacity(0.5),fontsize: 12, ),
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
            //children: userConectionController.getControllerList(widget.model),
          ))
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 10),
            child: SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(labeltext:"${"Istifadeci Yetkileri".tr} : ",color: Colors.black.withOpacity(0.5),fontsize: 18, ),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(height: 2,color: Colors.white,thickness: 1,),
          ),
          // Expanded(child: ListView(
          //   children: userAccessController.getUsersAccessList(widget.model),
          // ))
        ],
      ),
    );
  }

  Widget widgetFooter() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
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
                cllback: (){}, label: "delete".tr, surfaceColor: Colors.white),
          ),
          const SizedBox(width: 20,),
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
                  });
                }, label: "update".tr, surfaceColor: Colors.blueAccent),
          )
        ],

      ),
    );

  }
}
