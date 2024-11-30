import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/permitions/permitions_controller.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScreenAppPermitionSetting extends StatefulWidget {
  const ScreenAppPermitionSetting({super.key});

  @override
  State<ScreenAppPermitionSetting> createState() => _ScreenAppPermitionSettingState();
}

class _ScreenAppPermitionSettingState extends State<ScreenAppPermitionSetting> {
  List<SliderModel> mySLides = [];
  int slideIndex = 0;
  LocalUserServices userLocalService = LocalUserServices();
  LocalPermissionsController localPermissionsController =
      LocalPermissionsController();
  bool backLocationPermition = false;
  bool notificationPermition = false;
  bool notificationFirebasePermition = false;
  bool dataLoading = false;
  ItemScrollController _scrollController = ItemScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    //mySLides = getSlides();
    fillRequestList();
  }

  fillRequestList() async {
    mySLides.clear();
    setState(() {
      dataLoading = true;
    });
    backLocationPermition = await localPermissionsController.checkBackgroundLocationPermission();
    if (!backLocationPermition) {
      mySLides.add(SliderModel(
          desc: "desBackPermit".tr,
          title: "titleBackPermit".tr,
          imageAssetPath: "lottie/lottie_permition_request.json",
        code: "back",
        statusHasAcces: false
      ));
    }
    // notificationFirebasePermition = await localPermissionsController.checkForFirebaseNoticifations();
    // if (!notificationFirebasePermition) {
    //   mySLides.add(SliderModel(
    //       desc: "desNotyPermit".tr,
    //       title: "titleNotyPermit".tr,
    //       imageAssetPath: "lottie/lotie_fire_mesaje.json",
    //       code: "notfire",
    //       statusHasAcces: false));
    // }
    if(mySLides.isEmpty){
      Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
    }
    setState(() {
      dataLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: dataLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ScrollablePositionedList.builder(
                  scrollDirection: Axis.horizontal,
                   physics: NeverScrollableScrollPhysics(),
                  itemScrollController: _scrollController,
                  itemCount: mySLides.length,
                  itemBuilder: (context, index) {
                    return permitionItems(mySLides[index],index);
                  },
                ),
                // child: ListView.builder(
                //   controller: controller,
                //   scrollDirection: Axis.horizontal,
                //   physics: const NeverScrollableScrollPhysics(),
                //     itemCount: mySLides.length,
                //     itemBuilder: (c,index){
                //       return  permitionItems(mySLides[index],index);
                // }),
              ),
            ),
    );
  }
  
  Widget permitionItems(SliderModel model, int index){
    return Container(
      width: MediaQuery.of(context).size.width,
      height:  MediaQuery.of(context).size.height,
      padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 10,
              child: Lottie.asset(model.getImageAssetPath()!,
                  width: MediaQuery.of(context).size.width*0.7,
                  filterQuality: FilterQuality.medium, fit: BoxFit.fill)),
          Expanded(
            flex: 2,
            child: Center(
              child: CustomText(
                  color: Colors.blue.withOpacity(0.8),
                  labeltext: model.getTitle()!,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  fontsize: 30,
                  latteSpacer: 0.1,
                  maxline: 2),
            ),
          ),

          Expanded(
            flex: 5,
            child: CustomText(
                labeltext: model.getDesc()!,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
                fontsize: 16,
                maxline:10),
          ),
          CustomElevetedButton(
              fontWeight: FontWeight.bold,
              icon: Icons.verified,
              textColor: Colors.blue,
              borderColor: Colors.black,
              elevation: 10,
              height: 40,
              width: MediaQuery.of(context).size.width * 0.5,
              cllback: () async {
                 switch(model.code){
                   case 'back':
                     bool val= await localPermissionsController.permissionLocationAlways();
                     if(val){
                       if(index!=mySLides.length-1){
                         _scrollController.scrollTo(index: index+1, duration: const Duration(milliseconds: 300));
                       }else{
                         Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
                       }
                   }
                     break;
                     case 'notfire':
                       print("notfire firebase");
                     bool val= await localPermissionsController.reguestForFirebaseNoty();
                       print(DateTime.now().toString()+ " val oer :"+val.toString());
                       if(val){
                         print("index : "+index.toString());
                         print("mySLides.length : "+mySLides.length.toString());
                         if(index!=mySLides.length-1){
                           _scrollController.scrollTo(index: index+1, duration: const Duration(milliseconds: 300));
                         }else{
                           Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
                         }                     }
                     break;
                 }

              },
              label: "Icaze ver")
        ],
      ),
    );
  }
}

class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;
  String ? code;
  bool ? statusHasAcces;

  SliderModel({this.imageAssetPath, this.title, this.desc,this.code,this.statusHasAcces});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String? getImageAssetPath() {
    return imageAssetPath;
  }

  String? getTitle() {
    return title;
  }

  String? getDesc() {
    return desc;
  }


}
