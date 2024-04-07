import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/giris_cixis/companents/dialog_selectmapapp.dart';
import 'package:zs_managment/companents/local_bazalar/local_app_setting.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/global_models/model_maptypeapp.dart';
import 'package:zs_managment/global_models/utils.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenMapsSetting extends StatefulWidget {
  const ScreenMapsSetting({super.key});

  @override
  State<ScreenMapsSetting> createState() => _ScreenMapsSettingState();
}

class _ScreenMapsSettingState extends State<ScreenMapsSetting> {
  bool backClicked = false;
  List<AvailableMap> listApps = [];
  late AvailableMap selectedApp=AvailableMap(mapName: MapType.google.name.tr, mapType: MapType.google, icon:Icon(Icons.map).toString());
  bool dropdownTap = false;
  LocalAppSetting localAppSetting = LocalAppSetting();
  String giriscixisScreenType="";
  bool userStartWork=false;
  List<ModelGirisCixisScreenType> listGirisCixisType=[ModelGirisCixisScreenType(name: "map",icon: const Icon(Icons.map,color: Colors.green,),kod: "map"),ModelGirisCixisScreenType(name: "list",icon: const Icon(Icons.list_alt),kod: "list")];
  ModelGirisCixisScreenType? selectedModelGirisCixis;
  ModelAppSetting modelsetting  =ModelAppSetting(mapsetting: null, girisCixisType: "",userStartWork: false);

  @override
  void initState() {
    getAPPlist();
    // TODO: implement initState
    super.initState();
  }

  getAPPlist() async {
    listApps = await MapLauncher.installedMaps;
    await localAppSetting.init();
    ModelAppSetting modelAppSetting = await localAppSetting.getAvaibleMap();
    modelsetting=modelAppSetting;
    print("Model Setting :"+modelAppSetting.toString());
    if(modelAppSetting.mapsetting!=null) {
      ModelMapApp modelMapApp=modelAppSetting.mapsetting!;
      CustomMapType? customMapType=modelMapApp.mapType;
      MapType mapType=MapType.values[customMapType!.index];
      if (modelMapApp.name == "null") {
        print("modelMapApp.name: data yoxdu$modelAppSetting");
        selectedApp = listApps.first;
      } else {
        print("modelMapApp.name: data var$modelAppSetting");
        setState(() {
          selectedApp =  AvailableMap(mapName: modelMapApp.name!,
              mapType: mapType,
              icon: modelMapApp.icon!);
        });
      }
    }
    if(modelAppSetting.girisCixisType!=null){
      giriscixisScreenType=modelAppSetting.girisCixisType!;
    }else{
      giriscixisScreenType="map";
    }
    if(modelAppSetting.userStartWork!=null){
      userStartWork=modelAppSetting.userStartWork!;
    }else{
      userStartWork=false;
    }
    if(giriscixisScreenType.isNotEmpty){
      selectedModelGirisCixis= listGirisCixisType.where((element) => element.kod==giriscixisScreenType).first;
    }else{
      selectedModelGirisCixis=listGirisCixisType.first;
    }
    print(" selected App :"+selectedModelGirisCixis!.name.toString());
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.1),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widgetHeader(),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      widgetForXeriteandNavigation(),
                      const SizedBox(
                        height: 15,
                      ),
                      widgetForGirisCixis(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding widgetHeader() {
    return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          child: IconButton(
                              icon: backClicked
                                  ? Icon(Icons.arrow_forward)
                                  : Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  backClicked = true;
                                });
                                Get.back(result: selectedApp);
                              }),
                        ),
                        const Spacer(),
                        SizedBox(
                            child: CustomText(
                              labeltext: "setting".tr,
                              fontsize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          width: 30,
                        ),
                        const Spacer(),

                      ],
                    ),
                  );
  }

  Column widgetForXeriteandNavigation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: CustomText(
            labeltext: "mapandNavigation".tr,
            fontWeight: FontWeight.bold,
            fontsize: 22,
          ),
        ),
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                widgetChouseAppForUse(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget widgetChouseAppForUse() {
    return SizedBox(
      width: ScreenUtil.defaultSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blue.withOpacity(0.5),
              child: const Icon(
                size: 18,
                Icons.route,
                color: Colors.white,
              )),
          const SizedBox(
            width: 5,
          ),
          CustomText(
            labeltext: "Naviqasiya ucun Program",
            fontsize: 16,
            maxline: 2,
          ),
          const Spacer(),
          listApps.isNotEmpty ? widgetSelectApp() : const SizedBox()
        ],
      ),
    );
  }

  Widget widgetSelectApp() {
    return GestureDetector(
      onTap: () async {
        await localAppSetting.init();
        Get.dialog(
            DialogSelectMapApp(
              callBack: (modela) {
                setState(() {
                  CustomMapType customMapType = CustomMapType.values[modela.mapType.index];
                  ModelMapApp modelMapApp = ModelMapApp(
                      mapType: customMapType,
                      icon: modela.icon,
                      name: modela.mapName);
                  selectedApp=AvailableMap(mapName: modela.mapName, mapType: modela.mapType, icon: modela.icon);
                  modelsetting = ModelAppSetting(mapsetting: modelMapApp, girisCixisType: giriscixisScreenType,userStartWork: userStartWork);
                  saveChangedSettingtoDb(modelsetting);
                });
              },
              listmap: listApps,
            ),
            barrierDismissible: true,);
      },
      child: Row(
        children: [
          SvgPicture.asset(
            selectedApp.icon,
            width: 24,
            height: 24,
            // ...
          ),
          Icon(Icons.expand_more)
        ],
      ),
    );
  }

  widgetForGirisCixis() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: CustomText(
            labeltext: "giriscixis".tr,
            fontWeight: FontWeight.bold,
            fontsize: 22,
          ),
        ),
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                widgetGiriscixistypeSec(),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  widgetGiriscixistypeSec() {
    return SizedBox(
        width: ScreenUtil.defaultSize.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            CircleAvatar(
            radius: 12,
            backgroundColor: Colors.green.withOpacity(0.5),
            child: const Icon(
              size: 18,
              Icons.transfer_within_a_station,
              color: Colors.white,
            )),
        const SizedBox(
          width: 5,
        ),
        CustomText(
          labeltext: "giriscixistype".tr,
          fontsize: 16,
          maxline: 2,
        ),
        const Spacer(),
              DropdownButton<ModelGirisCixisScreenType>(
                value: selectedModelGirisCixis,
                elevation: 16,
                padding: const EdgeInsets.all(0),
                style: const TextStyle(color: Colors.deepPurple),
                underline: const SizedBox(),
                onChanged: (ModelGirisCixisScreenType? value) {
                  setState(() {
                    print("value :"+value.toString());
                    selectedModelGirisCixis = value!;
                    modelsetting.girisCixisType=value.kod;
                    saveChangedSettingtoDb(modelsetting);
                  });
                },
                items: listGirisCixisType.map<DropdownMenuItem<ModelGirisCixisScreenType>>((ModelGirisCixisScreenType value) {
                  return DropdownMenuItem<ModelGirisCixisScreenType>(
                    value: value,
                    child: widgetDrowerItems(value)
                  );
                }).toList(),
              )
          ],
        ));
  }

  widgetGirisCixis(ModelGirisCixisScreenType e) {
    return Container();
  }

  widgetDrowerItems(ModelGirisCixisScreenType value) {
    return Row(children: [
      value.icon!,
      const SizedBox(width: 5,),
      CustomText(labeltext: value.name!)
    ],);
  }

  Future<void> saveChangedSettingtoDb(ModelAppSetting modelsetting) async {
    await localAppSetting.addSelectedMyTypeToLocalDB(modelsetting);
    getAPPlist();
  }
}

class ModelGirisCixisScreenType{
  Icon? icon;
  String? kod;
  String? name;

  ModelGirisCixisScreenType({this.icon,this.kod,this.name});

  @override
  String toString() {
    return 'ModelGirisCixisScreenType{icon: $icon, kod: $kod, name: $name}';
  }
}