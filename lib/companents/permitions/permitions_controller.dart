import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalPermissionsController {
  // Method to check if location permission is granted
  Future<bool> checkLocationPermission() async {
    return await Permission.location.isGranted;
  }

  Future<bool> checkNotyPermission() async {
    return await Permission.notification.isGranted;
  }

  // Method to request location permission
  Future<void> requestLocationPermission() async {
    await Permission.location.request();
  }

  // Method to request background location permission
  Future<void> requestBackgroundLocationPermission() async {
    if (!(await Permission.location.isGranted)) {
      await Permission.location.request();
    }
    await Permission.locationAlways.request();
  }
  Future<void> requestNotyPermission() async {
    if (!(await Permission.notification.isGranted)) {
      await Permission.notification.request();
    }
    await Permission.notification.request();
  }

  //firebase notifications
  Future<bool> checkForFirebaseNoticifations()async{
    if (await Permission.notification.isGranted) {
      return await Permission.notification.isGranted;
    }
    return false;
  }

  Future<bool> reguestForFirebaseNoty() async {
    NotificationSettings settings=await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        announcement: true,
        sound: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      return true;
    }else{
      return false;
    }
  }


  // Method to check if background location permission is granted
  Future<bool> checkBackgroundLocationPermission() async {
    if (await Permission.location.isGranted) {
      return await Permission.locationAlways.isGranted;
    }
    return false;
  }


  Future<bool> permissionLocationAlways() async {
    bool hasPermission = false;
    int status = await BackgroundGeolocation.requestPermission();
    if (status == ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
      hasPermission=true;
    } else if (status == ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {
      hasPermission=false;
    }
    return Future<bool>.value(hasPermission);
  }
}