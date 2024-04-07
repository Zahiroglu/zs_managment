import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class ScreenDeleteUser extends StatefulWidget {
  LoggedUserModel loggedUserModel;
  UserModel modelUser;
  Function() deleteCall;

  ScreenDeleteUser({required this.loggedUserModel,required this.deleteCall,required this.modelUser, super.key});

  @override
  State<ScreenDeleteUser> createState() => _ScreenDeleteUserState();
}

class _ScreenDeleteUserState extends State<ScreenDeleteUser> {
  bool valueSelected = true;
  bool valueSelected2 = false;
  late CheckDviceType checkDviceType = CheckDviceType();
  ExeptionHandler exeptionHandler=ExeptionHandler();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
        color: Colors.transparent,
        child: Container(
            decoration: const BoxDecoration(
                border: Border(),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            height: ScreenUtil.defaultSize.height / 2,
            width: ScreenUtil.defaultSize.width / 2,
            margin: EdgeInsets.symmetric(vertical: 200.h, horizontal: 140.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: widgetHeader()),
                Expanded(
                  flex: 9,
                  child: _body(context),
                ),
                Expanded(flex: 3, child: widgetFooter()),
              ],
            )));
  }

  Widget widgetHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
                labeltext: "Form Silme",
                color: Colors.black,
                fontsize: 18,
                fontWeight: FontWeight.w700),
          ),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.red),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
    );
  }

  Widget widgetFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomElevetedButton(
              elevation: 10,
              cllback: () {
                deleteUserFromApi();
              },
              height: 40,
              width: 100,
              icon: Icons.delete,
              label: "sil".tr,
              textColor: Colors.red,
              borderColor: Colors.red.withOpacity(0.5)),
        )
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
           padding: const EdgeInsets.all(5),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(10)),
             border: Border.all(color: Colors.grey)
           ),
           
           width: 110.w,
           child: Column(
             children: [ Row(
               children: [
                 CustomText(
                     labeltext: "${"username".tr} : ",
                     fontWeight: FontWeight.w700),
                 CustomText(
                     labeltext:
                     "${widget.modelUser.name!} ${widget.modelUser.surname!}"),
               ],
             ),
               const SizedBox(
                 height: 5,
               ),
               Row(
                 children: [
                   CustomText(
                       labeltext: "${"Erazi Kodu".tr} : ",
                       fontWeight: FontWeight.w700),
                   CustomText(labeltext: widget.modelUser.code!),
                 ],
               ),
             ],
           ),
         ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: CustomText(
                    labeltext: "${"Yalniz temsilci silinsin?".tr} ",
                    maxline: 2,
                    fontWeight: FontWeight.w700),
              ),
              Checkbox(
                  value: valueSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val!) {
                        valueSelected = val;
                        valueSelected2 = false;
                      }
                    });
                  })
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: CustomText(
                    labeltext: "${"Erazi daxil butun melumatlar silinsin?".tr}",
                    maxline: 2,
                    fontWeight: FontWeight.w700),
              ),
              Checkbox(
                  value: valueSelected2,
                  onChanged: (val) {
                    setState(() {
                      if (val!) {
                        valueSelected2 = val;
                        valueSelected = false;
                      }
                    });
                  })
            ],
          )
        ],
      ),
    );
  }

  Future<void> deleteUserFromApi() async {
    int deleteMode=0;
    deleteMode=valueSelected2?1:0;
    DialogHelper.showLoading("Melumat silinir...", false);
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = widget.loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
        final response = await ApiClient().dio().delete(
          "${widget.loggedUserModel.baseUrl}/api/v1/User/delete-user/${widget.modelUser.code}/${widget.modelUser.roleId}/$deleteMode",
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'abs': '123456',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          DialogHelper.hideLoading();
          Get.dialog(ShowInfoDialog(
            color: Colors.green,
            icon: Icons.verified_user_outlined,
            messaje: "Melumat ugurla silindi",
            callback: () {
              Get.back();
              widget.deleteCall.call();
            },
          ));

        }else{
          DialogHelper.hideLoading();
          exeptionHandler.handleExeption(response);
        }
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
