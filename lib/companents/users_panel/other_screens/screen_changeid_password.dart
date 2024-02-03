import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';

import '../../../constands/app_constands.dart';
import '../../../dio_config/api_client.dart';
import '../../../utils/checking_dvice_type.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../local_bazalar/local_users_services.dart';

class ChangePasswordAndDviceId extends StatefulWidget {
  int changeType;
  UserModel modelUser;

  ChangePasswordAndDviceId(
      {required this.changeType, required this.modelUser, super.key});

  @override
  State<ChangePasswordAndDviceId> createState() =>
      _ChangePasswordAndDviceIdState();
}

class _ChangePasswordAndDviceIdState extends State<ChangePasswordAndDviceId> {
  TextEditingController cttextDviceId = TextEditingController();
  TextEditingController cttextUsername = TextEditingController();
  TextEditingController cttextPassword = TextEditingController();
  bool cttextDviceIdError = false;
  bool cttextUsernameError = false;
  bool cttextPasswordError = false;
  bool _isObscure = true;
  late CheckDviceType checkDviceType = CheckDviceType();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  LocalUserServices localUserServices = LocalUserServices();

  @override
  void initState() {
    localUserServices.init();
    loggedUserModel = localUserServices.getLoggedUser();
    cttextDviceId.text = widget.modelUser.deviceId!;
    cttextUsername.text = widget.modelUser.username!;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    cttextDviceId.dispose();
    // TODO: implement dispose
    super.dispose();
  }

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
            margin: EdgeInsets.symmetric(
                vertical: widget.changeType == 1 ? 250.h : 230.h,
                horizontal: widget.changeType == 1 ? 140.w : 140.w),
            child: Column(
              children: [
                Expanded(flex: 3, child: widgetHeader()),
                Expanded(
                  flex: 5,
                  child: widget.changeType == 1
                      ? changeDviceId()
                      : changePassword(),
                ),
                Expanded(flex: 3, child: widgetFooter()),
              ],
            )));
  }

  Widget changeDviceId() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 45.h, maxWidth: 70.w),
          child: CustomTextField(
            borderColor: Colors.grey,
            isImportant: true,
            icon: Icons.mobile_friendly,
            obscureText: false,
            controller: cttextDviceId,
            fontsize: 14,
            hindtext: "mobId".tr,
            inputType: TextInputType.text,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: cttextDviceIdError
              ? CustomText(
                  labeltext: "mobId".tr,
                  color: Colors.red,
                  fontsize: 8,
                )
              : const SizedBox(),
        )
      ],
    );
  }

  Widget changePassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 45.h, maxWidth: 60.w),
          child: CustomTextField(
              borderColor: cttextUsernameError ? Colors.red : Colors.grey,
              isImportant: true,
              obscureText: false,
              updizayn: false,
              icon: Icons.perm_identity,
              controller: cttextUsername,
              inputType: TextInputType.text,
              hindtext: 'username'.tr,
              fontsize: 14),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: cttextUsernameError
              ? CustomText(
                  labeltext: "icazeWinwosDialogUsername".tr,
                  color: Colors.red,
                  fontsize: 8,
                )
              : const SizedBox(),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 45.h, maxWidth: 60.w),
          child: CustomTextField(
              borderColor: cttextPasswordError ? Colors.red : Colors.grey,
              isImportant: true,
              obscureText: _isObscure,
              onTopVisible: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              suffixIcon: _isObscure ? Icons.visibility : Icons.visibility_off,
              updizayn: false,
              icon: Icons.lock,
              controller: cttextPassword,
              inputType: TextInputType.visiblePassword,
              hindtext: 'password'.tr,
              fontsize: 14),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: cttextPasswordError
              ? CustomText(
                  labeltext: "icazeWinwosDialogPassword".tr,
                  color: Colors.red,
                  fontsize: 8,
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget widgetHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
                labeltext: "Deyisiklik Formu",
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomElevetedButton(
              elevation: 10,
              cllback: () {
                if(widget.changeType==1){
                  changeDviceIdFromApi();
                }else{
                  changeUsernamePassword();
                }
              },
              height: 20,
              label: "change".tr,
              surfaceColor: Colors.green,
              borderColor: Colors.white.withOpacity(0.5)),
        )
      ],
    );
  }

  Future<void> changeDviceIdFromApi() async {
    var data = {"userId": widget.modelUser.id, "deviceId": cttextDviceId.text};
    DialogHelper.showLoading("Melumatlar yoxlanir...", false);
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
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
      try {
        final response = await ApiClient().dio().put(
              "${loggedUserModel.baseUrl}/api/v1/User/change-deviceid",
              data: data,
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
            icon: Icons.error,
            messaje: response.data['result'],
            callback: () {
            },
          ));

        } else {
          DialogHelper.hideLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: response.data.toString()??"Xeta Bas verdi",
            callback: () {
            },
          ));
        }
      } on DioException catch (e) {
        DialogHelper.hideLoading();
        if (e.type == DioExceptionType.connectionTimeout) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              Get.back();
            },
          ));
          //dataLoading.value = false;
        } else {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.type.toString() ?? "xeta".tr,
            callback: () {},
          ));
        }
        //dataLoading.value = false;
      }
    }
    DialogHelper.hideLoading();
  }
  Future<void> changeUsernamePassword() async {
    var data = {
      "userId": widget.modelUser.id,
      "username": cttextUsername.text,
      "password": cttextPassword.text
    };
    DialogHelper.showLoading("Melumatlar yoxlanir...", false);
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
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
      try {
        final response = await ApiClient().dio().put(
              "${loggedUserModel.baseUrl}/api/v1/User/change-username-password",
              data: data,
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
            icon: Icons.error,
            messaje: response.data['result'],
            callback: () {
            },
          ));

        } else {
          DialogHelper.hideLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: response.data.toString()??"Xeta Bas verdi",
            callback: () {
            },
          ));
        }
      } on DioException catch (e) {
        DialogHelper.hideLoading();
        if (e.type == DioExceptionType.connectionTimeout) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              Get.back();
            },
          ));
          //dataLoading.value = false;
        } else {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.type.toString() ?? "xeta".tr,
            callback: () {},
          ));
        }
        //dataLoading.value = false;
      }
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
