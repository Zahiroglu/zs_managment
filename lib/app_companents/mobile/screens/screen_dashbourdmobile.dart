
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/location_service/location_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/login/service/models/base_responce.dart';
import 'package:zs_managment/login/service/users_apicontroller.dart';

class ScreenDashBourdMobile extends StatefulWidget {
  const ScreenDashBourdMobile({Key? key}) : super(key: key);

  @override
  State<ScreenDashBourdMobile> createState() => _ScreenDashBourdMobileState();
}

class _ScreenDashBourdMobileState extends State<ScreenDashBourdMobile> {
  LocationController locationController=Get.put(LocationController());
  UsersApiController usersApiController=Get.put(UsersApiController());
  late final Timer timer;
  List<ModelLocation> listLocations=[];
  List<String> logs = [];

  @override
  void initState() {
    usersApiController.onInit();
    super.initState();

  }

  getUserLocationService()async{
    listLocations.clear();
    BaseResponce baseResponce= await usersApiController.getUsersLocationFromBase();
    var list=baseResponce.result;
    for(var listItem in list){
      listLocations.add(ModelLocation.fromJson(listItem));
      print(listItem.toString());
    }
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Background Location Service'),
        ),
        body: Center(
          child: Column(
            children: [
              Obx(() => usersApiController.isLoading.isFalse?SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: listLocations.length,
                    itemBuilder:(c,index)=> Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(labeltext: listLocations.elementAt(index).roleId.toString()),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: CustomText(labeltext: listLocations.elementAt(index).latitude.toString())),
                        CustomText(labeltext: "latitude lent :"+listLocations.elementAt(index).latitude.toString().length.toString()),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: CustomText(labeltext: listLocations.elementAt(index).longitude.toString())),
                        CustomText(labeltext: "longitude lent :"+listLocations.elementAt(index).longitude.toString().length.toString()),
                        CustomText(labeltext: listLocations.elementAt(index).lastSendTime.toString()),
                      ],
                    )),
              ):CircularProgressIndicator(color: Colors.blue,)),
              SizedBox(
                height: 200,
                child: ListView(
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () async {
                        _startLocationService(locationController);
                        },
                        child: const Text('Giris Et')),
                    ElevatedButton(
                        onPressed: () async {
                          locationController.changeGirisStatus(1);
                          //timer.cancel();
                        },
                        child: const Text('Cixis Et')),
                    ElevatedButton(
                        onPressed: () async {
                          getUserLocationService();
                          setState(() {

                          });
                        },
                        child: const Text('Melumatlari Getir')),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget locationData(RxDouble lat, RxDouble lng) {
    return Text(
      "${lat.value}-${lng.value}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  void _startLocationService(LocationController locationController) {
    locationController.changeGirisStatus(0);

  }
}