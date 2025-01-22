import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/isci_icazeleri/ModelIcazeRequest.dart';
import 'package:zs_managment/companents/isci_icazeleri/ModelUserIcaze.dart';
import 'package:zs_managment/companents/isci_icazeleri/screen_isci_icazeleri.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/services/api_services/firebase_users_controller_mobile.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/helpers/user_permitions_helper.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:intl/intl.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';
import '../../dio_config/api_client.dart';
import '../../widgets/simple_info_dialog.dart';
import 'screen_icazeyarat.dart';

class ScreenIcazeler extends StatefulWidget {
  final DrawerMenuController drawerMenuController;

  const ScreenIcazeler({required this.drawerMenuController ,super.key});

  @override
  State<ScreenIcazeler> createState() => _ScreenIcazelerState();
}

class _ScreenIcazelerState extends State<ScreenIcazeler> {
  LocalUserServices userServices=LocalUserServices();
  LoggedUserModel loggedUserModel=LoggedUserModel();
  UserPermitionsHelper userPermitionsHelpee=UserPermitionsHelper();
  List<ModelIcazeRequest> listIcazeler=[];
  bool screenLoading=true;
  late CheckDviceType checkDviceType = CheckDviceType();
  int qaliqGunIcazeSayi=0;
  int qaliqGunMezuniyyetIcazeSayi=0;
  int qaliqSaatIcazeSayi=0;

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
            leading: IconButton(
                onPressed: () {
                  widget.drawerMenuController.openDrawer();
                },
          icon: const Icon(Icons.menu),),
          actions: [
            CustomElevetedButton(
              height: 35,
                elevation: 0,
                borderColor: Colors.transparent,
                textColor: Colors.blue,
                iconLeft: false,
                surfaceColor: Colors.transparent,
                textsize: 12,
                icon: Icons.add_home_work,
                cllback: () async {
              await Get.to(() => ScreenIcazeYrat(
                illikGunLimiti: (userPermitionsHelpee.getResmiIcazeliGunSayi(loggedUserModel.userModel!.configrations!).$2),
                ayliqSaatLimiti: (userPermitionsHelpee.getResmiSaatliqIcazeSayi(loggedUserModel.userModel!.configrations!).$2),
                callBack: (result) {
                  if (result == 200) {
                    getAllDataFromServer();
                  }
                },
              ));

            }, label: "Icaze iste"),
        const SizedBox(width: 5,),
          ],
        ),
        body: screenLoading?const Center(child: CircularProgressIndicator(color: Colors.green,),):_body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return RefreshIndicator(
      onRefresh:  getAllDataFromServer,
      child: Column(children: [
       Expanded(
         flex: 0,
           child:  _infoUser(context)),
      Expanded(
          child:   listIcazeler.isNotEmpty?
      Column(children: [
        _infoQaliqHesabati(context),
        Padding(
          padding: const EdgeInsets.all(0.0).copyWith(left: 10,top: 10,bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(labeltext: "${"butunIcazeler".tr}(${listIcazeler.length})",fontsize: 18,fontWeight: FontWeight.bold,),
              IconButton(onPressed: (){}, icon: const Icon(Icons.calendar_month))
            ],
          ),
        ),
        _listIcazeler(),
      ],):NoDataFound())
      ],),
    );
  }

  _infoUser(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Card(
              margin: const EdgeInsets.all(10).copyWith(top: 0),
              color: Colors.blue.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(15.0).copyWith(top: 10,bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(labeltext: "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",color: Colors.white,fontsize: 22,fontWeight: FontWeight.bold,),
                    const SizedBox(height: 2,),
                    Row(
                      children: [
                        CustomText(labeltext: "${"qeydiyyatDate".tr} : "),
                        const SizedBox(width: 10,),
                        CustomText(labeltext: loggedUserModel.userModel!.addDateStr!.substring(0,10)),
                      ],
                    ),
                    const SizedBox(height: 2,),
                    Row(
                      children: [
                        CustomText(labeltext: "${"mezGunu".tr} : "),
                        const SizedBox(width: 10,),
                        CustomText(labeltext: "${userPermitionsHelpee.getMezuniyyetGunleri(loggedUserModel.userModel!.configrations!).$2} gun" )
                      ],
                    ),
                    const SizedBox(height: 2,),
                    Row(
                      children: [
                        CustomText(labeltext: "${"rGunu".tr} : "),
                        const SizedBox(width: 10,),
                        CustomText(labeltext: "${userPermitionsHelpee.getResmiIcazeliGunSayi(loggedUserModel.userModel!.configrations!).$2} gun" )
                      ],
                    ),
                    const SizedBox(height: 2,),
                    Row(
                      children: [
                        CustomText(labeltext: "${"sIcazeLimiti".tr} : "),
                        const SizedBox(width: 10,),
                        CustomText(labeltext: "${userPermitionsHelpee.getResmiSaatliqIcazeSayi(loggedUserModel.userModel!.configrations!).$2} deq" )
                      ],
                    )
                  ],
                ),
              ),
            ),
            userPermitionsHelpee.canAccessForUsersLeave(loggedUserModel.userModel!.permissions!)?Positioned(
                top: 1,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  radius: 20,
                  child: IconButton(
                    autofocus: true,
                    color: Colors.white,
                    icon: const Icon(Icons.notifications_active_rounded,color: Colors.white,),
                    onPressed: () async {
                      await Get.to(() => const ScreenUsersLeaveRequest());

                    },
                  ),
                )):const SizedBox(),
            Positioned(
                bottom: 20,
                right: 20,
                child:  DecoratedBox(decoration: BoxDecoration(
                border: Border.all(color:Colors.white),
                borderRadius: BorderRadius.circular(10)
            ),
              child: Padding(
                padding: const EdgeInsets.all(5.0).copyWith(left: 10,right: 10),
                child: CustomText(labeltext: calculateStaj(loggedUserModel.userModel!.addDateStr!),color: Colors.white,fontsize: 20,fontWeight: FontWeight.w800,),
              ),))
          ],
        ),
      ],
    );
  }

  _infoQaliqHesabati(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10,),
        Expanded(
          flex: 2,
          child: itemInfoQaliq(qaliqGunMezuniyyetIcazeSayi==0?Colors.red:Colors.green,"mezuniyyet".tr,userPermitionsHelpee.getMezuniyyetGunleri(loggedUserModel.userModel!.configrations!).$2.toString()
              ,qaliqGunMezuniyyetIcazeSayi.toString(),"day".tr),),
       const SizedBox(width: 10,),
       Expanded(
         flex: 2,
         child:  itemInfoQaliq(qaliqGunIcazeSayi==0?Colors.red:Colors.green,"rIcaze".tr,userPermitionsHelpee.getResmiIcazeliGunSayi(loggedUserModel.userModel!.configrations!).$2.toString()
             ,qaliqGunIcazeSayi.toString(),"day".tr),),
        const SizedBox(width: 10,),
        Expanded(
            flex: 2,
            child: itemInfoQaliq(qaliqSaatIcazeSayi==0?Colors.red:Colors.green,"sIcaze".tr,userPermitionsHelpee.getResmiSaatliqIcazeSayi(loggedUserModel.userModel!.configrations!).$2.toString(),
    qaliqSaatIcazeSayi.toString(),"deq".tr)),
        const SizedBox(width: 10,),
      ],
    );
  }

  itemInfoQaliq(Color color,String basliq,String esasSay,String qaliqSay,String tip) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow:  [
          BoxShadow(
            color: color,
            blurRadius: 5,
            blurStyle: BlurStyle.outer,
            offset: const Offset(0,0),
            spreadRadius: 0
          )
        ],
        border: Border.all(color: color,width: 2),
      borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(labeltext: qaliqSay,color: Colors.black,fontWeight: FontWeight.bold,fontsize: 18,),
                const SizedBox(width: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(labeltext: tip,fontsize: 12,),
                    CustomText(labeltext:"qalib".tr,fontsize: 12,),

                  ],
                ),
              ],
            ),
            const SizedBox(height: 5,),
            CustomText(labeltext: basliq,fontWeight: FontWeight.w700,)
          ],
        ),
      ),
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
    return Card(
      elevation: elementAt.tesdiqStatusu=="True"?10:2,
      shadowColor: Colors.black,
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
                    CustomText(labeltext: "icazeninNovu".tr),
                    const SizedBox(width: 10,),
                    CustomText(labeltext:elementAt.icazeTypeId==4?"sIcaze".tr:"rGicaze".tr),
                  ],
                ),
                elementAt.icazeTypeId!=4?Row(
                  children: [
                    CustomText(labeltext: "${"dateBetween".tr} : "),
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
                        CustomText(labeltext: "${"date".tr} : "),
                        const SizedBox(width: 10,),
                        CustomText(labeltext:elementAt.icazeEndDate.toString().substring(0,10)),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(labeltext: "${"timeBetween".tr} : "),
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
                    CustomText(labeltext: "icazeSebebi".tr),
                    const SizedBox(width: 10,),
                    CustomText(labeltext:elementAt.icazeQeyd),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: elementAt.tesdiqStatusu=="True"?const Icon(Icons.verified_sharp,color: Colors.green,size: 32,):const Icon(Icons.timelapse_outlined,color: Colors.red,))
        ],
      ),
    );
  }

  Future<void> getAllDataFromServer() async {
    setState(() {
      screenLoading=true;
    });
    qaliqGunIcazeSayi=0;
    qaliqGunMezuniyyetIcazeSayi=0;
    qaliqSaatIcazeSayi=0;
    listIcazeler.clear();
    int ay=DateTime.now().month;
    int il=DateTime.now().year;
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
          "${loggedUserModel.baseUrl}/Icaze/GetAllIcazelerByUserCode?userId=${loggedUserModel.userModel!.id}&il=$il+&ay=$ay",
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
          var dataModel = json.encode(response.data['Result']);
          ModelUserIcaze model =ModelUserIcaze.fromJson(jsonDecode(dataModel));
          listIcazeler.addAll(model.listIcazeler);
          qaliqGunMezuniyyetIcazeSayi=(userPermitionsHelpee.getMezuniyyetGunleri(loggedUserModel.userModel!.configrations!).$2- model.illikResmiMezuniyyet);
          qaliqGunIcazeSayi=(userPermitionsHelpee.getResmiIcazeliGunSayi(loggedUserModel.userModel!.configrations!).$2- model.illikIcazeGunluk);
          qaliqSaatIcazeSayi=(userPermitionsHelpee.getResmiSaatliqIcazeSayi(loggedUserModel.userModel!.configrations!).$2- model.ayliqIcazeSaatliq);
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

  String calculateStaj(String stajDate) {
    // Giriş formatı: 'YYYY-MM-DD'
    DateFormat inputFormat = DateFormat("M/d/yyyy h:mm:ss a"); // Giriş formatı
    DateTime startDate = inputFormat.parse(stajDate);
    DateTime dateNow = DateTime.now();

    // İllər, aylar və günlər arasındakı fərqi hesabla
    int years = dateNow.year - startDate.year;
    int months = dateNow.month - startDate.month;
    int days = dateNow.day - startDate.day;

    // Əgər ay və ya gün mənfi olarsa, uyğun düzəliş et
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    if (days < 0) {
      months -= 1;
      days += DateTime(dateNow.year, dateNow.month, 0).day; // Ayın son gününü al
    }

    // Nəticəni formatla
    String stajvaxti = '';
    if (years > 0) stajvaxti += '$years il ';
    if (months > 0) stajvaxti += '$months ay ';

    return stajvaxti.trim();
  }


}
