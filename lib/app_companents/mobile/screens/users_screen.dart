import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/login/models/user_model.dart';
import '../../../login/service/users_apicontroller.dart';

class UsersScreenMobile extends StatefulWidget {
  const UsersScreenMobile({Key? key}) : super(key: key);

  @override
  State<UsersScreenMobile> createState() => _UsersScreenMobileState();
}

class _UsersScreenMobileState extends State<UsersScreenMobile> {
  UsersApiController apiController = Get.put(UsersApiController());
  List<UserModel> listUsers = [];

  @override
  void initState() {
    // TODO: implement initState
    callAllUsers();
    super.initState();
  }

  callAllUsers() async {
    listUsers = await apiController.getAllUsers(1, 1, "");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      child:  Obx(() {
        return apiController.isLoading.isTrue
          ? Center(
          child: widgetAnimationYoxlanir(),) : ListView.builder(
            itemCount: listUsers.length,
            itemBuilder: (context, index) {
              return widgetUserItems(listUsers.elementAt(index));
            });
      })
    );
  }



  Stack widgetAnimationYoxlanir() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Lottie.asset("lottie/request_checking.json",
            height: ScreenUtil().screenHeight / 3,
            width: double.infinity,
            fit: BoxFit.fitHeight),
        Positioned(
          bottom: ScreenUtil().screenHeight / 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                labeltext: 'yuklenir'.tr,
                fontsize: 20.sp,
                maxline: 2,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent.withOpacity(0.6),
              ),
              SizedBox(
                width: 5.w,
              ),
              Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  size: 12.sp,
                  color: Colors.blueAccent.withOpacity(0.6),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget widgetUserItems(UserModel elementAt) {
    return Stack(
      
      children: [
        Card(
          margin: EdgeInsets.all(5.h),
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(8.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  maxRadius: 30.w,
                  minRadius: 20.w,
                  backgroundColor: Colors.white,
                  child:  Image.asset(
                    elementAt.gender.toString() == "Qadin"
                        ? "images/imagewoman.png"
                        : "images/imageman.png",
                  ),
                ),
                SizedBox(width: 5.w,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(labeltext: elementAt.username.toString(),fontWeight: FontWeight.w700),
                      //CustomText(labeltext: elementAt.departamentName.toString()+" | "+elementAt.roleName.toString(),fontWeight: FontWeight.w200)
                    ],

                  ),
                )

              ],
            ),
          ),

        ),
        Positioned(child: Text(''))
      ],
    );


  }

}
