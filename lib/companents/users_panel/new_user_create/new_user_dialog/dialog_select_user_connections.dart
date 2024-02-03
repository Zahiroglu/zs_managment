import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';

class DialogSelectedUserConnectins extends StatefulWidget {
  List<User> listUsers;
  List<User> selectedListUsers;
  Function(List<User>, List<User>) addConnectin;
  String vezifeAdi = "";

  DialogSelectedUserConnectins({required this.selectedListUsers,
    required this.addConnectin,
    required this.listUsers,
    required this.vezifeAdi,
    super.key});

  @override
  State<DialogSelectedUserConnectins> createState() =>
      _DialogSelectedUserConnectinsState();
}

class _DialogSelectedUserConnectinsState
    extends State<DialogSelectedUserConnectins> {
  final TextEditingController _cnSearching = TextEditingController();
  bool checboxIsSelected = false;
  List<User> listUsers = [];
  List<User> deSelectedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    listUsers = widget.listUsers;
    addselected();
    super.initState();
  }

  @override
  void dispose() {
    _cnSearching.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      color: Colors.transparent,
      child: isLoading ? const SizedBox() : Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 35.h, horizontal: 110.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          // height: 200,
          // width:100,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 10.h, bottom: 10.h, left: 5.w, right: 2.w),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                          labeltext: widget.vezifeAdi,
                          fontWeight: FontWeight.w800,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 18),
                    ),
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                          onTextChange: (s) {
                            searchFromList(s);
                          },
                          icon: Icons.search_outlined,
                          controller: _cnSearching,
                          obscureText: false,
                          hindtext: "axtar".tr,
                          inputType: TextInputType.text,
                          fontsize: 14,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2)
                        ),
                        child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomText(labeltext: "Secilen : ".tr),
                                CustomText(labeltext: listUsers
                                    .where((element) =>
                                element.isSelected == true)
                                    .toList()
                                    .length
                                    .toString()),
                                const SizedBox(width: 5,),
                                Checkbox(
                                    splashRadius: 5,
                                    value: listUsers.where((element) => element.isSelected == true).toList().length == listUsers.length,
                                    onChanged: (val) {
                                        changeAllSelectedUsers(val!);
                                    })
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: listUsers.length,
                          itemBuilder: (context, index) {
                            return myUsersItems(listUsers.elementAt(index));
                          }),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomElevetedButton(
                        surfaceColor: Colors.green.withOpacity(0.8),
                        cllback: () {
                          sendSelectedToBack();
                        },
                        label: "tesdiqle".tr,
                        width: 30.w,
                        height: 30.h,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget myUsersItems(User element) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              labeltext:
              "${element.code} - ${element.fullName}",
              fontsize: 16,
            ),
            Checkbox(
                value: element.isSelected,
                onChanged: (val) {
                  setState(() {
                    element.isSelected = val;
                    if (!val!) {
                      deSelectedUsers.add(element);
                    }
                  });
                })
          ],
        ),
      ),
    );
  }

  void searchFromList(String s) {
    if (s.isEmpty) {
      // listUsers = widget.model.users!;
    } else {
      // listUsers = widget.model.users!
      //     .where((element) => element.name!.toUpperCase().contains(s.toUpperCase()))
      //     .toList();
    }
    setState(() {});
  }

  void sendSelectedToBack() {
    widget.addConnectin.call(
        listUsers.where((element) => element.isSelected == true).toList(),
        deSelectedUsers);
    Get.back();
  }

  void addselected() {
    //selectedItemsCount=listUsers.where((element) => element.modulCode==widget.vezifeAdi).toList().length;
    setState(() {
      isLoading = false;
    });
  }

  void changeAllSelectedUsers(bool bool) {
    print("cal :"+bool.toString());
    for (var element in listUsers) {
      element.isSelected = bool;
    }
    setState(() {});
  }
}
