import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/windows/admin_usercontrol/datatable/service_excellcreate.dart';
import 'package:zs_managment/app_companents/windows/admin_usercontrol/datatable/user_datagrid.dart';
import 'package:zs_managment/app_companents/windows/new_user/screen_newusertest.dart';
import 'package:zs_managment/app_companents/windows/screen_userinfo.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/customwidgets/CustomTextFiled.dart';
import 'package:zs_managment/customwidgets/customElevetedButton.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/login/service/users_apicontroller.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUserControl extends StatefulWidget {
  ScreenUserControl({Key? key}) : super(key: key);

  @override
  State<ScreenUserControl> createState() => _ScreenUserControlState();
}

class _ScreenUserControlState extends State<ScreenUserControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  TextEditingController ctSearch = TextEditingController();
  bool openInfoTable = false;
  late UserModel selectedUserModel = UserModel();
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  ServiceExcell serviceExcell = ServiceExcell();
  UsersApiController usersApiController = Get.put(UsersApiController());
  late List<UserModel> listUsers = [];
  bool infodashbourdVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = IntTween(begin: 0, end: 100).animate(_animationController);
    _animation.addListener(() => setState(() {}));
    getAllUserFromDatabase();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
    ctSearch.dispose();
  }

  getAllUserFromDatabase() async {
    listUsers = await usersApiController.getAllUsers(1, 1, "");
  }

  widgetInfoTable() {
    return infodashbourdVisible
        ? Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 150.h,
                    maxHeight: 180.h,
                    maxWidth: double.infinity),
                child: Row(
                  children: [
                    widgetListAboutRegions(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.expand_less_outlined),
                  onPressed: () {
                    setState(() {
                      infodashbourdVisible = false;
                    });
                  },
                ),
              )
            ],
          )
        : Stack(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.transparent,
                child: CustomText(labeltext: listUsers.length.toString()),
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.expand_circle_down,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        infodashbourdVisible = true;
                      });
                    },
                  ))
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
          padding: EdgeInsets.only(left: 0.w, right: 2.w, top: 0.h),
          child: Stack(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      CustomText(
                          labeltext: 'users'.tr,
                          fontWeight: FontWeight.bold,
                          latteSpacer: 1,
                          fontsize: 8.sp),
                      SizedBox(
                        width: 15.w,
                      ),
                      CustomElevetedButton(
                        icon: Icons.person_add_alt,
                        textColor: Colors.blue,
                        surfaceColor: Colors.white,
                        borderColor: Colors.blue,
                        cllback: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const ScreenNewUserTest();
                              });
                        },
                        width: 160,
                        height: 40,
                        elevation: 5,
                        label: "newUser".tr,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  widgetInfoTable(),
                  SizedBox(
                    height: 10.h,
                  ),
                  widgetHederUserControl(),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(() {
                    return usersApiController.isLoading.isTrue
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.cyan,
                          ))
                        : widgetDataGrid();
                  })
                ],
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: ScreenUserInfo(
                    callClouse: () {
                      setState(() {
                        animateUserInfo(true);
                      });
                    },
                    //sizeWidght: ResponsiveBuilder.isMobile(context)?_animationController.value * ResponsiveBuilder.mainWidh(context) / 1.8:ResponsiveBuilder.isTablet(context)?_animationController.value * ResponsiveBuilder.mainWidh(context) / 2.2:_animationController.value * ResponsiveBuilder.mainWidh(context) / 3,
                    sizeWidght: ResponsiveBuilder.isMobile(context)
                        ? _animationController.value * 350
                        : ResponsiveBuilder.isTablet(context)
                            ? _animationController.value * 380
                            : _animationController.value * 450,
                    model: selectedUserModel,
                  ))
            ],
          )),
    );
  }

  Expanded widgetDataGrid() {
    return Expanded(
        child: UserDataGrid(
      listUsers: listUsers,
      keyTable: _key,
      callBack: (model) {
        setState(() {
          selectedUserModel = model;
          animateUserInfo(false);
        });
      },
    ));
  }

  animateUserInfo(bool check) {
    setState(() {
      if (!check) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  widgetHederUserControl() {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        height: 40.h,
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                icon: Icons.search,
                align: TextAlign.center,
                obscureText: false,
                fontsize: 14,
                controller: ctSearch,
                inputType: TextInputType.text,
                hindtext: 'axtar'.tr,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            CustomElevetedButton(
              icon: Icons.search,
              textColor: Colors.white,
              surfaceColor: Colors.grey.withOpacity(0.8),
              cllback: () {},
              width: 100,
              height: 50,
              elevation: 10,
              label: "axtar".tr,
            ),
            const SizedBox(
              width: 15,
            ),
            CustomElevetedButton(
              icon: Icons.add_chart_outlined,
              textColor: Colors.white,
              surfaceColor: Colors.green,
              cllback: () {
                serviceExcell.exportUsersDataGridToExcel(_key);
              },
              width: 100,
              height: 50,
              elevation: 10,
              label: "EXCEL",
            ),
          ],
        ),
      ),
    );
  }

  widgetListAboutRegions() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
          itemCount: 5,
          itemBuilder: (c,index){
        return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.4),

              ),
              height: 40.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(labeltext: "Gence"+index.toString(),color: Colors.black,latteSpacer: 1,fontWeight: FontWeight.w800,fontsize: 4.sp,),
                      CustomText(labeltext: (index+15).toString(),color: Colors.black,latteSpacer: 1,fontWeight: FontWeight.w800,fontsize: 4.sp,),
                    ],
                  ),
                  Divider(height: 1,color: Colors.black,)
                ],
              ),
            );
      }),
    );
  }

//// infoListinWidgetleri
}
