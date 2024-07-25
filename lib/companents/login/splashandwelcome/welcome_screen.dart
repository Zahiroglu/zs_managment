import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class WellCameScreen extends StatefulWidget {
  const WellCameScreen({Key? key}) : super(key: key);

  @override
  State<WellCameScreen> createState() => _WellCameScreenState();
}

class _WellCameScreenState extends State<WellCameScreen> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late Timer timer;
  late LoggedUserModel loggedUserModel = LoggedUserModel();
  bool isLoading = true;
  late LocalUserServices localUserServices = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalBaseDownloads localBaseDownloads=LocalBaseDownloads();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    localUserServices.init();
    localBaseDownloads.init();
    checkDviceType = CheckDviceType();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();
    animation = CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    timer = Timer(const Duration(seconds: 3), () async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      getUser(connectivityResult);
    });
  }

  getUser(ConnectivityResult connectivityResult) async {
    loggedUserModel = localUserServices.getLoggedUser();
    checkDviceType=CheckDviceType();
    if(checkDviceType.getDviceType()==3){
      Get.offNamed(RouteHelper.getWindosLoginScreen());

    }else{
      if (loggedUserModel.isLogged == null || loggedUserModel.isLogged == false) {
        if (await localUserServices.getIfAppOpenFistOrNot()==false) {
          Get.offNamed(RouteHelper.getLoginMobileFirstScreen());
        } else {
          Get.offNamed(RouteHelper.getMobileLisanceScreen());
        }
      }
      else {
        bool base=await localBaseDownloads.checkIfUserMustDonwloadsBaseFirstTime(loggedUserModel.userModel!.roleId!);
        print("Yukelnmeli baza var? "+base.toString());
        if (base) {
          Get.offNamed(RouteHelper.getbazaDownloadMobile());
        } else {
          Get.offNamed(RouteHelper.getMobileMainScreen());
        }
      }
    }

    setState(() {
      isLoading = false;
    });
    print("User model :" + loggedUserModel.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: Center(
                child: Image.asset(
              "images/zs6.png",
              width: 200,
              height: 200,
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(labeltext: 'welcome', fontsize: 18, maxline: 2),
              const SizedBox(
                width: 5,
              ),
            ],
          )
        ],
      ),
    );
  }
}
