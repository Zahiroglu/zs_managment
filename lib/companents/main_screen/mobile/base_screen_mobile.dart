import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/main_screen/drawer/custom_drawer_windows.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';

import '../../../routs/rout_controller.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../anbar/screan_anbar_esas.dart';
import '../../base_downloads/screen_download_base.dart';
import '../../connected_users/rout_detail_users_screen.dart';
import '../../dashbourd/dashbourd_screen_mobile.dart';
import '../../giris_cixis/sceens/reklam_girisCixis/screen_giriscixis_reklamsobesi.dart';
import '../../giris_cixis/sceens/satisGirisCixis/screen_giriscixis_umumilist.dart';
import '../../giris_cixis/sceens/yeni_giriscixis_map.dart';
import '../../live_track/screen_live_track.dart';
import '../../local_bazalar/local_db_downloads.dart';
import '../../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import '../../rut_gostericileri/mercendaizer/screens/merc_routdatail_screen.dart';
import '../../satis_emeliyyatlari/sifaris_detallari/screen_sifarislerebax.dart';
import '../../setting_panel/setting_screen_mobile.dart';
import '../../tapsiriqlar/screen_tasks.dart';
import '../../users_panel/mobile/users_panel_mobile_screen.dart';
import '../../users_panel/user_panel_windows_screen.dart';
import '../drawer/custom_drawermobile.dart';
import '../drawer/model_drawerItems.dart';

class MainScreenMobile extends StatefulWidget {
  const MainScreenMobile({ super.key});

  @override
  State<MainScreenMobile> createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  ThemaController themaController=ThemaController();
  DrawerMenuController drawerMenuController=Get.put(DrawerMenuController());
  LocalUserServices userServices=LocalUserServices();

  bool melumatYuklendi=false;


  @override
  void initState() {
    initAllValues();
    initKeyToController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        _cixisAlqoritmasiniQur();
      },
      child: Material(
        child: SafeArea(
          child: melumatYuklendi?Scaffold(
            key: _key,
            drawer: melumatYuklendi?Drawer(
              backgroundColor: Colors.transparent,
              width: ScreenUtil.defaultSize.width*0.8,
              child: CustomDrawerMobile(
                drawerMenuController: drawerMenuController,
                userModel: userServices.getLoggedUser(),
                data: (va) {
                },
                scaffoldkey: _key,
                appversion: '0.1',
                initialSelected: 0,
                closeDrawer: (val) {
                  _key.currentState!.closeDrawer();
                  setState(() {
                  });
                },
              ),
            ):const Drawer(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: drawerMenuController.pageView)
                ],
              ),
            ),
          ):LoagindAnimation(isDark: Get.isDarkMode,textData: "melumatyuklenir".tr,icon: "lottie/loagin_animation.json"),
        ),
      ),
    );

  }

  Future<void> initAllValues() async {
    await userServices.init();
    melumatYuklendi=true;
    setState(() {
    });
  }

  void initKeyToController() {
    if(drawerMenuController.initialized){
      drawerMenuController.initKeyForScafold(_key);
    }
  }

  void _cixisAlqoritmasiniQur() {

      Get.dialog(ShowSualDialog(
          messaje: "progCmeminsiz".tr, callBack: (va){
        if(va){
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }

        }
      }));



  }


}
