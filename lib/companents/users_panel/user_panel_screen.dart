import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/controller/user_mainscreen_controller.dart';
import 'package:zs_managment/companents/users_panel/models_user/model_requet_allusers.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/screen_new_user.dart';
import 'package:zs_managment/companents/users_panel/services/user_datagrid.dart';
import 'package:zs_managment/companents/users_panel/user_info_screen.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/widgets/animated_sizewidget.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';

import '../../widgets/loagin_animation.dart';

class UserPanelScreen extends StatefulWidget {
  const UserPanelScreen({super.key});

  @override
  State<UserPanelScreen> createState() => _UserPanelScreenState();
}

class _UserPanelScreenState extends State<UserPanelScreen>
    with SingleTickerProviderStateMixin {
  UserMainScreenController controller = Get.put(UserMainScreenController());
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  ModelAllUsersLisanceUserCount selectedElement = ModelAllUsersLisanceUserCount();
  ModelAllUsersLisanceUserCount howerSelectedElement = ModelAllUsersLisanceUserCount();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _ctSearch=TextEditingController();

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
      body: Obx(() =>
      controller.userLisanceLoading.isFalse
          ? controller.listModelAllUsersLisanceUserCount.isNotEmpty ? Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Stack(
            children: [
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            widgetFirstHeader(context),
        Obx(() =>
            SizedBox(
              height: controller.infodashbourdVisible.isTrue ? 20 : 10,
            ),),
        widgetListFilter(),
        SizedBox(
          height: 5,
        ),

        widgetDataGrid(),

        ],
      ),
        controller.openUserInfoTable.isTrue
            ? Positioned(
            top: 0,
            right: 0,
            child: ScreenUserInfo(
              deleteCall: (){
                controller.deleteUser(controller.getSelectedUser(),);
                setState(() {});
              },
              loggedUserModel: controller.loggedUserModel,
              callClouse: () {
                setState(() {
                  controller.openUserInfoTable.value = false;
                });
              },
              sizeWidght: MediaQuery.of(context).size.width * 1.2,
              model: controller.getSelectedUser(), //burda istifadeci Modeli olmalidir
            ))
            : const SizedBox()
        ],
      ),
    ): NoDataFound():
    const SizedBox()));
  }

  Row widgetFirstHeader(BuildContext context) {
    return Row(
      children: [
        CustomText(
            labeltext: 'users'.tr,
            //color: Colors.black,
            fontWeight: FontWeight.bold,
            latteSpacer: 1,
            fontsize: 8),
        const SizedBox(
          width: 15,
        ),
        CustomElevetedButton(
          icon: Icons.person_add_alt,
          textColor: Colors.black,
          surfaceColor: Colors.white,
          cllback: () {
            showDialog(
                context: context,
                builder: (context) {
                  return ScreenNewUser(
                    refreshCall: (){
                      controller.infodashbourdVisible.value=false;
                      controller.updateAllValues(selectedElement);
                      setState(() {});
                    },
                  );
                });
          },
          width: 40,
          height: 35,
          elevation: 5,
          label: "newUser".tr,
        ),
      ],
    );
  }

  Expanded widgetDataGrid() {
    return Expanded(
        child: controller.listUsers!.isEmpty
            ? const SizedBox()
            : UserDataGrid(
          listUsers: controller.listUsers!.toList(),
          keyTable: _key,
          callBack: (model) {
            setState(() {
              controller.changeSelectedUser(model);
              controller.openUserInfoTable.value = true;
            });
          },
        ));
  }

  widgetListFilter() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      spreadRadius: 1,
                      blurRadius: 0.5
                  )

                ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          containerHeight: 40,
                          icon: Icons.search,
                          align: TextAlign.center,
                          obscureText: false,
                          fontsize: 14,
                          controller: _ctSearch,
                          inputType: TextInputType.text,
                          hindtext: 'axtar'.tr,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CustomElevetedButton(
                        icon: Icons.search,
                        textColor: Colors.white,
                        surfaceColor: Colors.grey.withOpacity(0.8),
                        cllback: () {
                          ModelRequestUsersFilter model=ModelRequestUsersFilter(
                            name: _ctSearch.text
                          );
                          controller.getAllUsersByParams(model);
                        },
                        height: 20,
                        //width: 15.w,
                        elevation: 5,
                        label: "axtar".tr,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Obx(() =>
                      controller.listUsers!.isEmpty ? SizedBox() : CustomElevetedButton(
                        icon: Icons.add_chart_outlined,
                        textColor: Colors.white,
                        surfaceColor: Colors.green,
                        cllback: () {
                          controller.exportUsersDataGridToExcel(_key);
                        },
                        height: 20,
                        //width: 15.w,
                        elevation: 5,
                        label: "EXCEL",
                      ),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
         const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 30,
                child: widgetUsersLisanceBourd()),
            Expanded(flex: 1,child: controller.infodashbourdVisible.isTrue
                ? controller.listUsers!.isNotEmpty ? IconButton(
              icon: const Icon(Icons.expand_less_rounded),
              onPressed: () {
                setState(() {
                  controller.infodashbourdVisible.value = false;
                });
              },
            ):SizedBox()
                : IconButton(
              icon: const Icon(
                Icons.expand_more,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  controller.infodashbourdVisible.value = true;
                });
              },
            ),)
          ],
        ),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget widgetUsersLisanceBourd() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration:  Duration(milliseconds:controller.infodashbourdVisible.value? 500:1000),
            height:  controller.infodashbourdVisible.value?220:90,
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: ListView.builder(
                //shrinkWrap: true,
                  controller: _scrollController,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.listModelAllUsersLisanceUserCount.length,
                  itemBuilder: (cont, index) =>
                      widgetModuleItems(controller.listModelAllUsersLisanceUserCount
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
            labeltext: label,
            fontsize: labelSize,
            fontWeight: FontWeight.w700),
        SizedBox(
          width: 5,
        ),
        CustomText(
            color: Colors.blue,
            labeltext: "$usercount",
            fontsize: lisanceSize),
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
      constraints:   BoxConstraints(
          minWidth: 250,
          maxWidth: 350,
          maxHeight:controller.infodashbourdVisible.value?0:0
      ),
      child: MouseRegion(
        onEnter: (onEnter) => onClickEnter(true, element),
        onExit: (onExit) => onClickExit(true, element),
        child: InkWell(
          focusColor: Colors.transparent,
          onTap: () {
            ModelRequestUsersFilter modelRequestUsersFilter=ModelRequestUsersFilter(moduleId: element.id);
            controller.getAllUsersByParams(modelRequestUsersFilter);
            selectedElement = element;
          },
          child: Card(
            color: selectedElement == element ? Colors.black12.withOpacity(0.5)
                : element.id == -1 ? Colors.white.withOpacity(0.9) : Colors.white,
            shadowColor: selectedElement == element ? Colors.indigoAccent
                : howerSelectedElement == element ? Colors.indigoAccent : Colors.grey,
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
                      CustomText(
                          color: selectedElement == element ? Colors.white : Colors.black,
                          labeltext: element.name!.toUpperCase(),
                          fontsize: 18,
                          fontWeight: FontWeight.w700),
                      const Spacer(),
                     Row(
                       children: [
                         CustomText(
                             color: Colors.blue,
                             labeltext: element.userCounts!.fold<int>(0, (sum,
                                 item) => sum + item.usedCount!).toString(),
                             fontsize: 14),
                         CustomText(
                           color: Colors.green,
                           labeltext: "/${element.userCounts!.fold<int>(0, (sum,
                               item) => sum + item.totalCount!).toString()}",
                           fontsize: 16,
                           fontWeight: FontWeight.w700,
                         )
                       ],
                     )
                    ],
                  ),
                  const SizedBox(height: 2,),
                  Divider(color: selectedElement == element ? Colors.white : Colors.black,height: 1),
                  const SizedBox(height: 3,),
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
                          children: element.userCounts!.map((e) =>
                              widgetVezifeItems(e, element)).toList(),
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
        constraints:  const BoxConstraints(
          minWidth: 200,
          maxWidth:300,
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
}
