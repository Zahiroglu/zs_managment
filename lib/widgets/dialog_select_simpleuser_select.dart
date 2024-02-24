import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';

class DialogSimpleUserSelect extends StatefulWidget {
  List<UserModel> listUsers;
  Function(UserModel selectedUser) getSelectedUse;
  String vezifeAdi = "";
  String selectedUserCode;


  DialogSimpleUserSelect({
    required this.getSelectedUse,
    required this.listUsers,
    required this.vezifeAdi,
    required this.selectedUserCode,
    super.key});

  @override
  State<DialogSimpleUserSelect> createState() =>
      _DialogSimpleUserSelectState();
}

class _DialogSimpleUserSelectState
    extends State<DialogSimpleUserSelect> {
  final TextEditingController _cnSearching = TextEditingController();
  bool checboxIsSelected = false;

  @override
  void initState() {
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
      child:Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 80.h, horizontal: 20.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          // height: 200,
          // width:100,
          child: Stack(
            children: [Padding(
                padding: EdgeInsets.only(
                    top: 15.h, bottom: 15.h, left: 2.w, right: 2.w),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                          labeltext: widget.vezifeAdi.tr,
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
                    Expanded(
                      child: ListView.builder(
                          itemCount: widget.listUsers.length,
                          itemBuilder: (context, index) {
                            return myUsersItems(widget.listUsers.elementAt(index));
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

  Widget myUsersItems(UserModel element) {
    return InkWell(
      onTap: (){
        setState(() {
          widget.selectedUserCode==element.code;
        });
        widget.getSelectedUse(element);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.all(5).copyWith(bottom: 2),
        margin: const EdgeInsets.all(15).copyWith(bottom: 0),
        decoration: BoxDecoration(
          color:widget.selectedUserCode==element.code?Colors.green: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2,2),
              spreadRadius: 1,
              blurRadius: 5
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                labeltext: "${element.code} - ${element.name}",
                fontsize: 16,
              ),
            ],
          ),
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

}
