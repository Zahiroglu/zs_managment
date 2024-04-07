import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';

import '../users_panel/new_user_create/new_user_controller.dart';

class ScreenCreateNewTask extends StatefulWidget {
  const ScreenCreateNewTask({super.key});

  @override
  State<ScreenCreateNewTask> createState() => _ScreenCreateNewTaskState();
}

class _ScreenCreateNewTaskState extends State<ScreenCreateNewTask> {
  TextEditingController ctTaskHeader = TextEditingController();
  TextEditingController ctTaskTitle = TextEditingController();
  TextEditingController ctImageCount = TextEditingController();
  LocalUserServices userLocalService = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  List<Role> listRollar = [];
  Role selectedRole = Role();
  bool taskIsIportand=false;
  bool taskNeedPhoto=false;
  bool taskIsPeriodik=false;

  @override
  void initState() {
    userLocalService.init();
    listRollar = [
      Role(
          name: "Butun istifadeciler",
          id: 100,
          deviceLogin: false,
          usernameLogin: false),
      Role(
          name: "Mercendaizer",
          id: 21,
          deviceLogin: false,
          usernameLogin: false),
      Role(
          name: "Satis temsilcisi",
          id: 17,
          deviceLogin: false,
          usernameLogin: false)
    ];
    selectedRole == listRollar.first;
    loggedUserModel = userLocalService.getLoggedUser();
    super.initState();
  }

  // @override
  // Future<void> initState() async {
  //   await userLocalService.init();
  //   loggedUserModel=userLocalService.getLoggedUser();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  void dispose() {
    ctTaskHeader.dispose();
    ctTaskTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        toolbarHeight: 60,
        title: CustomText(labeltext: "newTask".tr),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          _customersInfo(context),
          const SizedBox(
            height: 10,
          ),
          _taskHeader(context),
          const SizedBox(
            height: 10,
          ),
          _taskOrderBy(context),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomElevetedButton(
              cllback: (){},
              label: "Tapsiriq yarat",
              height: 40,
              width: 200,
              elevation: 5,
              surfaceColor: Colors.white,
              borderColor: Colors.blue,
              textColor: Colors.blue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10,),

        ],
      ),
    );
  }

  _customersInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              labeltext: "Tapsiriq uzre secilmis market",
              fontsize: 16,
              fontWeight: FontWeight.w800),
          Card(
            elevation: 20,
            surfaceTintColor: Colors.white,
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomText(labeltext: "Cari kod : "),
                      CustomText(labeltext: "01254"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      CustomText(labeltext: "Cari ad : "),
                      CustomText(labeltext: "Bravo m-t Xirdalan"),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _taskHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              labeltext: "Tapsiriq melumatlari",
              fontsize: 16,
              fontWeight: FontWeight.w800),
          Card(
            margin: const EdgeInsets.all(0),
            elevation: 5,
            surfaceTintColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  maxLines: 1,
                  onSubmit: (s) {},
                  hasBourder: true,
                  isImportant: true,
                  updizayn: true,
                  containerHeight: 40,
                  controller: ctTaskHeader,
                  inputType: TextInputType.text,
                  hindtext: "taskHeader".tr,
                  fontsize: 14,
                  obscureText: false,
                ),
                CustomTextField(
                    maxLines: 6,
                    isImportant: true,
                    onSubmit: (s) {},
                    containerHeight: 120,
                    controller: ctTaskTitle,
                    inputType: TextInputType.multiline,
                    hindtext: "taskTitle".tr,
                    fontsize: 14,
                    obscureText: false)
              ],
            ),
          ),
        ],
      ),
    );
  }

  _taskOrderBy(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              labeltext: "Tapsiriq duzelisler",
              fontsize: 16,
              fontWeight: FontWeight.w800),
          Card(
            elevation: 20,
            surfaceTintColor: Colors.white,
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(labeltext: "Tasiriq aiddir  :"),
                      SizedBox(
                          height: 30,
                          width: 200,
                          child: Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  //background color of dropdown button
                                  border: Border.all(
                                      color: Colors.blueAccent.withOpacity(0.5),
                                      width: 1),
                                  //border of dropdown button
                                  borderRadius: BorderRadius.circular(5),
                                  //border raiuds of dropdown button
                                  boxShadow: const <BoxShadow>[
                                    //apply shadow on Dropdown button
                                    BoxShadow(
                                        spreadRadius: 1,
                                        color: Color.fromRGBO(0, 0, 0, 0.57),
                                        //shadow for button
                                        blurRadius: 2)
                                    //blur radius of shadow
                                  ]),
                              child: DropdownButton(
                                  value: selectedRole.id == null
                                      ? null
                                      : selectedRole,
                                  elevation: 5,
                                  icon: const Icon(Icons.expand_more_outlined),
                                  underline: const SizedBox(),
                                  hint: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CustomText(labeltext: "posSec".tr),
                                  ),
                                  alignment: Alignment.center,
                                  isDense: false,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  items: listRollar
                                      .map<DropdownMenuItem<Role>>(
                                        (lang) => DropdownMenuItem(
                                        alignment: Alignment.center,
                                        value: listRollar.isNotEmpty
                                            ? lang
                                            : Role(),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey),
                                              color: Colors.transparent,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  5), //border raiuds of dropdown button
                                            ),
                                            height: 40,
                                            width: 140,
                                            child: Center(
                                                child: CustomText(
                                                    labeltext: lang.name
                                                        .toString())))),
                                  )
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        selectedRole = val;
                                      });
                                    }
                                  }),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(color: Colors.grey,thickness: 0.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex:10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(labeltext: "Tapsiriq cox vacibdir"),
                            CustomText(
                              maxline: 2,
                              labeltext: "Tapsiriq icra edilmeden cixis edile bilinmez",fontsize: 10,color: Colors.grey,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: SizedBox(
                          height: 30,
                          child: Center(
                            child: Checkbox(
                              value: taskIsIportand,
                              onChanged: (v){
                                setState(() {
                                  taskIsIportand=v!;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Divider(color: Colors.grey,thickness: 0.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex:10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(labeltext: "Tapsiriq daimi tekrarlansin"),
                            CustomText(
                              maxline: 2,
                              labeltext: "Tapsiriq bu markete edilen butun girislerde uygun vezifede icra edilmesi ucun acilacaqdir",fontsize: 10,color: Colors.grey,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: SizedBox(
                          height: 30,
                          child: Center(
                            child: Checkbox(
                              value: taskIsPeriodik,
                              onChanged: (v){
                                setState(() {
                                  taskIsPeriodik=v!;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Divider(color: Colors.grey,thickness: 0.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex:10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(labeltext: "Tapsiriq icrasi ucun sekil lazimdir"),
                            CustomText(
                              maxline: 2,
                              labeltext: "Tasiriqa minimum secilmis sayda sekil elave edilmese cixis edile bilmeyecek",fontsize: 10,color: Colors.grey,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: SizedBox(
                          height: 30,
                          child: Center(
                            child: Checkbox(
                              value: taskNeedPhoto,
                              onChanged: (v){
                                setState(() {
                                  taskNeedPhoto=v!;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  taskNeedPhoto?SizedBox(
                    height: 45,
                    width: 300,
                    child: CustomTextField(
                        isImportant: true,
                        align: TextAlign.center,
                        containerHeight: 40,
                        controller: ctImageCount, inputType: const TextInputType.numberWithOptions(decimal: false,signed: false), hindtext: "Minimal sekil sayi", fontsize: 14),
                  ):SizedBox(),
                  const Divider(color: Colors.grey,thickness: 0.2),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
