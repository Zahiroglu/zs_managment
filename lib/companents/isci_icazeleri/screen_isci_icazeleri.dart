
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';

import '../../dio_config/api_client.dart';
import '../../helpers/dialog_helper.dart';
import '../../helpers/user_permitions_helper.dart';
import '../../utils/checking_dvice_type.dart';
import '../../widgets/custom_responsize_textview.dart';
import '../../widgets/simple_info_dialog.dart';
import '../local_bazalar/local_users_services.dart';
import '../login/models/logged_usermodel.dart';
import 'ModelIcazeRequest.dart';

class ScreenUsersLeaveRequest extends StatefulWidget {
  const ScreenUsersLeaveRequest({super.key});

  @override
  State<ScreenUsersLeaveRequest> createState() => _ScreenUsersLeaveRequestState();
}

class _ScreenUsersLeaveRequestState extends State<ScreenUsersLeaveRequest> {
  LocalUserServices userServices=LocalUserServices();
  LoggedUserModel loggedUserModel=LoggedUserModel();
  UserPermitionsHelper userPermitionsHelpee=UserPermitionsHelper();
  late CheckDviceType checkDviceType = CheckDviceType();
  List<ModelIcazeRequest> listIcazeler=[];
  late ModelIcazeRequest selecTedModel = ModelIcazeRequest(userId: 0, userCode: "",
      userRoleId: 0, userRoleName: "", userNameAndSurname: "", icazeTypeId: 0,
      icazeStartDate: DateTime.now(), icazeEndDate:  DateTime.now(), icazeQeyd: ""); // Default dəyər verin

  bool screenLoading=true;

  @override
  void initState() {
    initAllStates();
    // TODO: implement initState
    super.initState();
  }
  Future<void> initAllStates()async{
    await  userServices.init();
    loggedUserModel=userServices.getLoggedUser();
    await getAllDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(labeltext: "Icaze istekleri",fontsize: 18,fontWeight: FontWeight.bold,),
        ),
        body: screenLoading?const Center(child: CircularProgressIndicator(color: Colors.green,),):_body(context),
      ),
    );
  }

  Future<void> getAllDataFromServer() async {
    setState(() {
      screenLoading=true;
    });
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel = userServices.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    String languageIndex = await getLanguageIndex();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio(false).post(

          "${loggedUserModel.baseUrl}/Icaze/GetMyConnectedUserUnveryfiredLeave",
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'smr': '12345',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          if (response.data['Result'] != null) {
            var listuser = response.data['Result'];
            for (var i in listuser) {
              listIcazeler.add(ModelIcazeRequest.fromJson(i));
            }
          }
          setState(() {
            screenLoading=false;
          });
        }
      } on DioException catch (e) {
        if (e.response != null) {
        } else {
          // Something happened in setting up or sending the request that triggered an Error
        }
      }
    }

  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        listIcazeler.isNotEmpty?_listIcazeler():Center(child: NoDataFound(width: 250,height: 250,title: "melumattapilmadi".tr,)),
      ],
    );
  }

  _listIcazeler() {
    return Expanded(
        child: ListView.builder(
            itemCount: listIcazeler.length,
            itemBuilder: (c,index){
              return itemListIcazeler(listIcazeler.elementAt(index));
            }));
  }

  itemListIcazeler(ModelIcazeRequest elementAt) {
    //bool tesdiq=elementAt.tesdiqStatusu!=""&&elementAt.tesdiqStatusu!="null"?bool.parse(elementAt.tesdiqStatusu!):false;
    return InkWell(
      onTap: (){
        setState(() {
          if(selecTedModel==elementAt){
            selecTedModel=ModelIcazeRequest(userId: 0, userCode: "",
                userRoleId: 0, userRoleName: "", userNameAndSurname: "", icazeTypeId: 0,
                icazeStartDate: DateTime.now(), icazeEndDate:  DateTime.now(), icazeQeyd: "");
          }else {
            selecTedModel = elementAt;
          }});
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey,
        margin: const EdgeInsets.all(10).copyWith(bottom: 0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(labeltext: elementAt.userNameAndSurname,fontWeight: FontWeight.bold,),
                  Row(
                    children: [
                      CustomText(labeltext: "Icaze novu : ",color: Colors.grey,),
                      const SizedBox(width: 10,),
                      CustomText(labeltext:elementAt.icazeTypeName??"null"),
                    ],
                  ),
                  elementAt.icazeTypeId!=4?Row(
                    children: [
                      CustomText(labeltext: "Tarix aralgi : ",color: Colors.grey,),
                      const SizedBox(width: 10,),
                      CustomText(labeltext:"${elementAt.icazeStartDate.toString().substring(0,10)} - ${elementAt.icazeEndDate.toString().substring(0,10)}"),
                      const SizedBox(width: 10,),
                      DecoratedBox(decoration: BoxDecoration(
                          border: Border.all(color:elementAt.tesdiqStatusu=="True"?Colors.green:Colors.red),
                          borderRadius: BorderRadius.circular(10)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0).copyWith(left: 5,right: 5),
                          child: CustomText(labeltext: "${elementAt.totalDuration} ${"day".tr}",),
                        ),)
                    ],
                  ):Column(
                    children: [
                      Row(
                        children: [
                          CustomText(labeltext: "Tarix : ",color: Colors.grey,),
                          const SizedBox(width: 10,),
                          CustomText(labeltext:elementAt.icazeEndDate.toString().substring(0,10),color: Colors.grey,),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "Saat araligi : "),
                          const SizedBox(width: 10,),
                          CustomText(labeltext:"${elementAt.icazeStartDate.toString().substring(11,16)} - ${elementAt.icazeEndDate.toString().substring(11,16)}"),
                          const SizedBox(width: 10,),
                          DecoratedBox(decoration: BoxDecoration(
                              border: Border.all(color:elementAt.tesdiqStatusu=="True"?Colors.green:Colors.red),
                              borderRadius: BorderRadius.circular(10)
                          ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0).copyWith(left: 5,right: 5),
                              child: CustomText(labeltext: "${elementAt.totalDuration} ${"deq".tr}",),
                            ),)
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(labeltext: "Icaze sebebi",color: Colors.grey,),
                      const SizedBox(width: 10,),
                      CustomText(labeltext:elementAt.icazeQeyd),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  selecTedModel==elementAt?Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomElevetedButton(
                          height: 35,
                          cllback: (){
                            _sil(elementAt);
                      },
                          icon: Icons.delete,
                          borderColor: Colors.red,
                          textColor: Colors.red,
                          label: "sil".tr),
                      const SizedBox(width: 10,),
                      CustomElevetedButton(
                          height: 35,
                          cllback: (){
                        _tesdiqle(elementAt);
                      },
                          icon: Icons.verified_sharp,
                          borderColor: Colors.green,
                          textColor: Colors.green,
                          label: "Tesdiqle")
                    ],
                  ):const SizedBox()

                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 10,
                child: elementAt.tesdiqStatusu=="true"?const Icon(Icons.verified_sharp,color: Colors.green,):const Icon(Icons.timelapse,color: Colors.red,)),
          ],
        ),
      ),
    );
  }

  Future<void> _sil(ModelIcazeRequest model) async {
    Get.dialog(ShowSualDialog(messaje: "Icazeni silmeye eminsiniz?", callBack: (v) async {
      if(v){
        await deleteIcaze(model);
      }
    }));
  }

  Future<void> _tesdiqle(ModelIcazeRequest model) async {
    Get.dialog(ShowSualDialog(messaje: "Icazeni tesdiqlemeye eminsiniz?", callBack: (v) async {
      if(v){
        await callAddIcaze(model);
      }
    }));
  }

  Future<void> callAddIcaze(ModelIcazeRequest model) async {
    DialogHelper.showLoading("Melumatlar tesdilenir",false);
    await userServices.init();
    LoggedUserModel loggedUserModel = userServices.getLoggedUser();
    model.tesdiqStatusu="true";
    model.tesdiqlenmeTarixi=DateTime.now();
    model.tesdiqleyenCode=loggedUserModel.userModel!.code!;
    model.tesdiqleyenId=loggedUserModel.userModel!.id!;
    model.tesdiqleyenNameAndSurname="${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}";
    model.tesdiqleyenRoleId=loggedUserModel.userModel!.roleId!;
    model.tesdiqleyenRoleName=loggedUserModel.userModel!.roleName!;
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try{
        final response = await ApiClient().dio(false).post(
          "${loggedUserModel.baseUrl}/Icaze/UpdateTableIcazeler",
          data: model.toJson(),
          options: Options(
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'smr': '12345',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          listIcazeler.removeWhere((e)=>e.icazeId==model.icazeId);
          setState(() {
          });

          // Get.dialog(ShowInfoDialog(messaje: response.data['Result'], icon: Icons.verified_sharp, callback: (){
          //   Get.back();
          // }));
        }else{
        }
      }catch(e){
        DialogHelper.hideLoading();
      }
    }
  }

  Future<void> deleteIcaze(ModelIcazeRequest model) async {
    DialogHelper.showLoading("Melumatlar silinir",false);
    await userServices.init();
    LoggedUserModel loggedUserModel = userServices.getLoggedUser();
    model.tesdiqStatusu="true";
    model.tesdiqlenmeTarixi=DateTime.now();
    model.tesdiqleyenCode=loggedUserModel.userModel!.code!;
    model.tesdiqleyenId=loggedUserModel.userModel!.id!;
    model.tesdiqleyenNameAndSurname="${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}";
    model.tesdiqleyenRoleId=loggedUserModel.userModel!.roleId!;
    model.tesdiqleyenRoleName=loggedUserModel.userModel!.roleName!;
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try{
        final response = await ApiClient().dio(false).post(
          "${loggedUserModel.baseUrl}/Icaze/DeleteTableIcazeler",
          data: model.toJson(),
          options: Options(
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'smr': '12345',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          Get.back();
          listIcazeler.removeWhere((e)=>e.icazeId==model.icazeId);
          setState(() {
          });

        }
      }catch(e){
        DialogHelper.hideLoading();
      }
    }
  }


}
