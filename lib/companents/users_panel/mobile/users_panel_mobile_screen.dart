import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:zs_managment/utils/checking_dvice_type.dart';
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
  bool canSearch = false;
  CheckDviceType checkDviceType = CheckDviceType();

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
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )));
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
        canSearch
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: CustomTextField(
                  onSubmit: (s) {
                    ModelRequestUsersFilter model =
                        ModelRequestUsersFilter(name: s.toUpperCase());
                    print("model name :" + model.name!.toUpperCase());
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
              )
            : CustomText(
                labeltext: 'users'.tr,
                //color: Colors.black,
                fontWeight: FontWeight.bold,
                latteSpacer: 1,
                fontsize: 16),
        Spacer(),
        Spacer(),
        Spacer(),
        canSearch
            ? IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    canSearch = false;
                    _ctSearch.clear();
                  });
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                  size: 24,
                ))
            : IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    canSearch = true;
                  });
                },
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.green,
                  size: 24,
                )),
        canSearch
            ? SizedBox()
            : Obx(() => controller.listUsers!.isEmpty
                ? SizedBox()
                : IconButton(
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
                    icon: Icon(Icons.person_add_alt))),
        canSearch
            ? SizedBox()
            : Obx(
                () => controller.listUsers!.isEmpty
                    ? SizedBox()
                    : IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          controller.exportUsersDataGridToExcel(_key);
                        },
                        icon: const Icon(
                          Icons.add_chart_outlined,
                          color: Colors.green,
                          size: 24,
                        )),
              ),
        canSearch
            ? SizedBox()
            : Obx(
                () => controller.listModelAllUsersLisanceUserCount.length != 1
                    ? SizedBox()
                    : IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          controller.getTotalInfoUsersFromApiService();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.blue,
                          size: 24,
                        )),
              )
      ],
    );
  }

  Expanded widgetDataGrid() {
    return Expanded(
        child: ListView.builder(
            itemCount: controller.listUsers!.length,
            itemBuilder: (context, index) {
              return listUserItem(controller.listUsers!.elementAt(index));
            }));
  }

  widgetListFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              child: widgetUsersLisanceBourd(),
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
          duration: Duration(
              milliseconds: controller.infodashbourdVisible.value ? 400 : 1200),
          height: controller.infodashbourdVisible.value ? 210 : 70,
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
        const SizedBox(
          width: 5,
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
          minWidth: 220,
          maxWidth: 250,
          maxHeight: controller.infodashbourdVisible.value ? 0 : 0),
      child: MouseRegion(
        onEnter: (onEnter) => onClickEnter(true, element),
        onExit: (onExit) => onClickExit(true, element),
        child: InkWell(
          focusColor: Colors.transparent,
          onTap: () {
            ModelRequestUsersFilter modelRequestUsersFilter = ModelRequestUsersFilter(moduleId: element.id);
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
            elevation: 5,
            margin: const EdgeInsets.all(7).copyWith(bottom: 15),
            child: Padding(
              padding: const EdgeInsets.all(10.0).copyWith(bottom: 0),
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
                            fontsize: 16,
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

  Widget widgetVezifeItems(
    ModelAllUsersItemsLisance e,
    ModelAllUsersLisanceUserCount element,
  ) {
    return AnimatedClipRect(
      horizontalAnimation: false,
      open: controller.infodashbourdVisible.value,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeOut,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomText(
                      color: element.id == -1
                          ? selectedElement == element
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5)
                          : Colors.grey,
                      labeltext: e.roleName!,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Row(
                  children: [
                    CustomText(
                        color: Colors.blue,
                        labeltext: "${e.usedCount} / ",
                        fontsize: 12),
                    CustomText(
                      color: Colors.green,
                      labeltext: e.totalCount.toString(),
                      fontsize: 14,
                      fontWeight: FontWeight.w700,
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 0.2,
            color: Colors.grey,
            thickness: 0.2,
          )
        ],
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
      onTap: () {
        controller.changeSelectedUser(model);
        controller.openUserInfoTable.value = true;
        Get.dialog(ScreenUserInfoMobile(
          deleteCall: () {
            controller.deleteUser(
              controller.getSelectedUser(),
            );
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
          model:
              controller.getSelectedUser(), //burda istifadeci Modeli olmalidir
        ));
        setState(() {});
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 5,
        shadowColor: Colors.grey,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Image.asset(
                        model.gender == 0
                            ? "images/imageman.png"
                            : "images/imagewoman.png",
                        width: 80,
                        height: 80
                      ),
                      model.active!=null&&model.active!?Icon(Icons.verified,color: Colors.green,):Icon(Icons.block,color: Colors.red,size: 80,),
                    ],
                  )),
              Expanded(
                flex: 12,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          labeltext:
                              "${model.name.toString()} ${model.surname.toString()}",
                          fontWeight: FontWeight.w600,
                          fontsize: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                labeltext:
                                    "${model.regionName} | ${model.moduleName} | ${model.roleName}",
                                fontWeight: FontWeight.normal,
                                fontsize: 14,
                                maxline: 2,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              labeltext: "${"lastAktivdate".tr} : ",
                              fontWeight: FontWeight.normal,
                              fontsize: 12,
                              color: Colors.black87,
                            ),
                            CustomText(
                              labeltext: model.addDateStr.toString()=="null"?"":model.addDateStr.toString(),
                              fontWeight: FontWeight.normal,
                              fontsize: 12,
                              color: Colors.black87,
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            const Icon(Icons.alternate_email,
                                color: Colors.red, size: 14),
                            const SizedBox(
                              width: 2,
                            ),
                            CustomText(
                              labeltext: "${model.email}",
                              fontWeight: FontWeight.normal,
                              fontsize: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.red, size: 14),
                            const SizedBox(
                              width: 2,
                            ),
                            CustomText(
                              labeltext: "${model.phone}",
                              fontWeight: FontWeight.normal,
                              fontsize: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                             Image.asset("images/access.png",height: 15,width: 15,),
                            const SizedBox(
                              width: 2,
                            ),
                            CustomText(
                              labeltext:model.usernameLogin!?"Windows |":"",
                              fontWeight: FontWeight.normal,
                              fontsize: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            CustomText(
                              labeltext:model.deviceLogin!?"Mobile":"",
                              fontWeight: FontWeight.normal,
                              fontsize: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CustomText(
                        labeltext: model.code.toString(),
                      ),
                    )
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
      await File('/storage/emulated/0/Download/$_fileName.xlsx')
          .writeAsBytes(potato!, flush: true)
          .then((value) {
        print('saved');
      });
    } else if (status == PermissionStatus.denied) {
      print(
          'Denied. Show a dialog with a reason and again ask for the permission.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }

    return null;
  }
}
