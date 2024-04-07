import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/users_panel/controller/user_mainscreen_controller.dart';
import 'package:zs_managment/companents/users_panel/mobile/user_info_screen_mobile.dart';
import 'package:zs_managment/companents/users_panel/models_user/model_requet_allusers.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/screen_new_user.dart';
import 'package:zs_managment/companents/users_panel/services/user_datagrid.dart';
import 'package:zs_managment/companents/users_panel/user_info_screen.dart';
import 'package:zs_managment/widgets/animated_sizewidget.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';
import 'package:excel/excel.dart';
import '../../login/services/api_services/users_controller_mobile.dart';

class UsersPanelScreenMobile extends StatefulWidget {
  DrawerMenuController drawerMenuController;

  UsersPanelScreenMobile({required this.drawerMenuController, super.key});

  @override
  State<UsersPanelScreenMobile> createState() => _UsersPanelScreenMobileState();
}

class _UsersPanelScreenMobileState extends State<UsersPanelScreenMobile>
    with SingleTickerProviderStateMixin {
  UserMainScreenController controller = Get.put(UserMainScreenController());
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  ModelAllUsersLisanceUserCount selectedElement =
      ModelAllUsersLisanceUserCount();
  ModelAllUsersLisanceUserCount howerSelectedElement =
      ModelAllUsersLisanceUserCount();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _ctSearch = TextEditingController();
  bool canSearch=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ctSearch.dispose();
    Get.delete<UserMainScreenController>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() => controller.userLisanceLoading.isFalse
            ? controller.listModelAllUsersLisanceUserCount.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 0),
                              child: widgetFirstHeader(context),
                            ),
                            widgetListFilter(),
                            const SizedBox(
                              height: 5,
                            ),
                            widgetDataGrid(),
                          ],
                        ),
                      ],
                    ),
                  )
                : NoDataFound()
            : const SizedBox()));
  }

  Row widgetFirstHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: () {
              widget.drawerMenuController.openDrawer();
            },
            child: Icon(Icons.menu)),
        const Spacer(),
        canSearch? SizedBox(
          width: MediaQuery.of(context).size.width*0.7,
          child: CustomTextField(
            onSubmit: (s){
              ModelRequestUsersFilter model = ModelRequestUsersFilter(name: s.toUpperCase());
              print("model name :"+model.name!.toUpperCase());
              controller.getAllUsersByParams(model);
            },
            containerHeight: 40,
            icon: Icons.search,
            align: TextAlign.center,
            obscureText: false,
            fontsize: 14,
            controller: _ctSearch,
            inputType: TextInputType.text,
            hindtext: 'axtar'.tr,
          ),
        ):CustomText(
            labeltext: 'users'.tr,
            //color: Colors.black,
            fontWeight: FontWeight.bold,
            latteSpacer: 1,
            fontsize: 16),
        Spacer(),
        Spacer(),
        Spacer(),
        canSearch?
        IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: (){
              setState(() {
                canSearch=false;
                _ctSearch.clear();
              });
            }, icon: Icon(Icons.clear,color: Colors.red,size: 24,)):IconButton(
            padding: EdgeInsets.all(0),
            onPressed: (){
              setState(() {
                canSearch=true;
              });
            }, icon: Icon(Icons.search_outlined,color: Colors.green,size: 24,)),
        canSearch?SizedBox():IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ScreenNewUser(
                      refreshCall: () {
                        controller.infodashbourdVisible.value = false;
                        controller.updateAllValues(selectedElement);
                        setState(() {});
                      },
                    );
                  });
            },
            icon: Icon(Icons.person_add_alt)),
        canSearch?SizedBox():Obx(
              () => controller.listUsers!.isEmpty
              ? SizedBox()
              : IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){
                controller.exportUsersDataGridToExcel(_key);
              }, icon: Icon(Icons.add_chart_outlined,color: Colors.green,size: 24,)),
        )
      ],
    );
  }

  Expanded widgetDataGrid() {
    return Expanded(
        child: ListView.builder(
            itemCount: controller.listUsers!.length,
            itemBuilder: (context,index){
          return listUserItem(controller.listUsers!.elementAt(index));

        }));
  }

  widgetListFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Align(
        //   alignment: Alignment.topRight,
        //   child: Container(
        //     decoration: BoxDecoration(
        //         borderRadius: const BorderRadius.all(Radius.circular(5)),
        //         boxShadow: [
        //           BoxShadow(
        //               color: Colors.grey.withOpacity(0.2),
        //               offset: const Offset(2, 2),
        //               spreadRadius: 1,
        //               blurRadius: 0.5)
        //         ]),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Expanded(
        //           flex: 3,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Expanded(
        //                 child: CustomTextField(
        //                   containerHeight: 40,
        //                   icon: Icons.search,
        //                   align: TextAlign.center,
        //                   obscureText: false,
        //                   fontsize: 14,
        //                   controller: _ctSearch,
        //                   inputType: TextInputType.text,
        //                   hindtext: 'axtar'.tr,
        //                 ),
        //               ),
        //               SizedBox(
        //                 width: 5.w,
        //               ),
        //               CustomElevetedButton(
        //                 icon: Icons.search,
        //                 textColor: Colors.white,
        //                 surfaceColor: Colors.grey.withOpacity(0.8),
        //                 cllback: () {
        //                   ModelRequestUsersFilter model = ModelRequestUsersFilter(name: _ctSearch.text);
        //                   controller.getAllUsersByParams(model);
        //                 },
        //                 height: 20,
        //                 //width: 15.w,
        //                 elevation: 5,
        //                 label: "axtar".tr,
        //               ),
        //               SizedBox(
        //                 width: 5.w,
        //               ),
        //               Obx(
        //                 () => controller.listUsers!.isEmpty
        //                     ? SizedBox()
        //                     : CustomElevetedButton(
        //                         icon: Icons.add_chart_outlined,
        //                         textColor: Colors.white,
        //                         surfaceColor: Colors.green,
        //                         cllback: () {
        //                           controller.exportUsersDataGridToExcel(_key);
        //                         },
        //                         height: 20,
        //                         //width: 15.w,
        //                         elevation: 5,
        //                         label: "EXCEL",
        //                       ),
        //               )
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Stack(
          children: [
            Positioned(
                top: 15,
                right: 0,
                child: controller.infodashbourdVisible.isTrue
                    ? controller.listUsers!.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                controller.infodashbourdVisible.value = false;
                              });
                            },
                            child: const Icon(Icons.expand_less_rounded))
                        : SizedBox()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            controller.infodashbourdVisible.value = true;
                          });
                        },
                        child: const Icon(
                          Icons.expand_more,
                          color: Colors.black,
                        ),
                      )),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Expanded(flex: 25, child: widgetUsersLisanceBourd()),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget widgetUsersLisanceBourd() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: controller.infodashbourdVisible.value ? 500 : 1000),
          height: controller.infodashbourdVisible.value ? 220 : 70,
          child: CupertinoScrollbar(
            controller: _scrollController,
            child: ListView.builder(
                //shrinkWrap: true,
                controller: _scrollController,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: controller.listModelAllUsersLisanceUserCount.length,
                itemBuilder: (cont, index) => widgetModuleItems(controller
                    .listModelAllUsersLisanceUserCount
                    .elementAt(index))),
          ),
        ),
      ],
    );
  }

  Row widgetItemsCount(String label, double labelSize, int usercount, double lisanceSize, int lisancecount, double userCountsize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(
            labeltext: label, fontsize: labelSize, fontWeight: FontWeight.w700),
        SizedBox(
          width: 5.w,
        ),
        CustomText(
            color: Colors.blue, labeltext: "$usercount", fontsize: lisanceSize),
        CustomText(
          color: Colors.green,
          labeltext: "/$lisancecount",
          fontsize: userCountsize,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget widgetModuleItems(ModelAllUsersLisanceUserCount element) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 180,
          maxWidth: 240,
          maxHeight: controller.infodashbourdVisible.value ? 0 : 0),
      child: MouseRegion(
        onEnter: (onEnter) => onClickEnter(true, element),
        onExit: (onExit) => onClickExit(true, element),
        child: InkWell(
          focusColor: Colors.transparent,
          onTap: () {
            ModelRequestUsersFilter modelRequestUsersFilter =
                ModelRequestUsersFilter(moduleId: element.id);
            controller.getAllUsersByParams(modelRequestUsersFilter);
            selectedElement = element;
          },
          child: Card(
            color: selectedElement == element
                ? Colors.black12.withOpacity(0.5)
                : element.id == -1
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white,
            shadowColor: selectedElement == element
                ? Colors.indigoAccent
                : howerSelectedElement == element
                    ? Colors.indigoAccent
                    : Colors.grey,
            elevation: 20,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: CustomText(
                            color: selectedElement == element
                                ? Colors.white
                                : Colors.black,
                            labeltext: element.name!.toUpperCase(),
                            fontsize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomText(
                                color: Colors.blue,
                                labeltext: element.userCounts!
                                    .fold<int>(
                                        0, (sum, item) => sum + item.usedCount!)
                                    .toString(),
                                fontsize: 14),
                            CustomText(
                              color: Colors.green,
                              labeltext:
                                  "/${element.userCounts!.fold<int>(0, (sum, item) => sum + item.totalCount!).toString()}",
                              fontsize: 16,
                              fontWeight: FontWeight.w700,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Divider(
                      color: selectedElement == element
                          ? Colors.white
                          : Colors.black,
                      height: 1),
                  const SizedBox(
                    height: 3,
                  ),
                  AnimatedClipRect(
                    horizontalAnimation: false,
                    open: controller.infodashbourdVisible.value,
                    curve: Curves.easeOut,
                    reverseCurve: Curves.easeOut,
                    child: SizedBox(
                      height: 130,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: element.userCounts!
                              .map((e) => widgetVezifeItems(e, element))
                              .toList(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetVezifeItems(ModelAllUsersItemsLisance e, ModelAllUsersLisanceUserCount element,) {
    return AnimatedClipRect(
      horizontalAnimation: false,
      open: controller.infodashbourdVisible.value,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeOut,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 200,
          maxWidth: 300,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  color: element.id == -1
                      ? selectedElement == element
                          ? Colors.white.withOpacity(0.5)
                          : Colors.black.withOpacity(0.5)
                      : Colors.grey,
                  labeltext: e.roleName!,
                  fontsize: 14,
                  maxline: 2,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700),
              const Spacer(),
              Row(
                children: [
                  CustomText(
                      color: Colors.blue,
                      labeltext: "${e.usedCount}/",
                      fontsize: 14),
                  CustomText(
                    color: Colors.green,
                    labeltext: e.totalCount.toString(),
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  onClickEnter(bool bool, ModelAllUsersLisanceUserCount element) {
    setState(() {
      howerSelectedElement = element;
    });
  }

  onClickExit(bool bool, ModelAllUsersLisanceUserCount element) {
    setState(() {
      howerSelectedElement = ModelAllUsersLisanceUserCount();
    });
  }

  InkWell listUserItem(UserModel model) {
    return InkWell(
      onTap: (){
        controller.changeSelectedUser(model);
        controller.openUserInfoTable.value = true;
        Get.dialog(ScreenUserInfoMobile(
          deleteCall: (){
            controller.deleteUser(controller.getSelectedUser(),);
            setState(() {
              Get.back();
            });
          },
          loggedUserModel: controller.loggedUserModel,
          callClouse: () {
            setState(() {
              controller.openUserInfoTable.value = false;
              Get.back();
            });
          },
          sizeWidght: 100,
          model: controller.getSelectedUser(), //burda istifadeci Modeli olmalidir
        ));
        setState(() {});
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 20,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 4,
                  child: Image.asset(
                    model.gender == 0
                        ? "images/imageman.png"
                        : "images/imagewoman.png",
                    width: 80,
                    height: 80,
                  )),
              Expanded(
                flex: 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    CustomText(labeltext: "${model.name.toString()} ${model.surname.toString()}",fontWeight: FontWeight.w600,fontsize: 16,),
                    CustomText(labeltext: "${model.regionName} | ${model.moduleName} | ${model.roleName}",fontWeight: FontWeight.normal,fontsize: 14,color: Colors.grey,),
                    Row(
                      children: [
                        Icon(Icons.alternate_email,color: Colors.red,size: 14),
                        SizedBox(width: 2,),
                        CustomText(labeltext: "${model.email}",fontWeight: FontWeight.normal,fontsize: 14,color: Colors.grey,),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,color: Colors.red,size: 14),
                        SizedBox(width: 2,),
                        CustomText(labeltext: "${model.phone}",fontWeight: FontWeight.normal,fontsize: 14,color: Colors.grey,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(labeltext: "Windows"),
                            Icon(
                              model.usernameLogin!? Icons.verified_user : Icons.block,
                              color:  model.usernameLogin! ? Colors.green : Colors.red,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Row(
                          children: [
                            CustomText(
                              labeltext: "Mobile",
                            ),
                            Icon(
                             model.deviceLogin!? Icons.verified_user : Icons.block,
                              color:  model.deviceLogin!  ? Colors.green : Colors.red,
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(labeltext: "${model.lastOnlineDate}",fontWeight: FontWeight.normal,fontsize: 14,color: Colors.grey,),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future exportReport() async {
    var excel = Excel.createExcel();
    String _name = "Samir";
    String _fileName = 'surname-' + _name;

    List<int>? potato = excel.save(fileName: _name);

    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      await File('/storage/emulated/0/Download/$_fileName.xlsx').writeAsBytes(potato!, flush: true).then((value) {
        print('saved');
      });
    } else if (status == PermissionStatus.denied) {
      print('Denied. Show a dialog with a reason and again ask for the permission.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }

    return null;
  }
}
