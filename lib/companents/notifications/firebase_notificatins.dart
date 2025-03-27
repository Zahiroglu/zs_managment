import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../login/mobile/mobile_lisance_screen.dart';
import 'noty_background_track.dart';

class FirebaseNotyficationController {

  FirebaseMessaging messaging=FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool> reguestForFirebaseNoty() async {
    NotificationSettings settings=await messaging.requestPermission(
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

  Future<String> getFireToken() async {
    String? token=await messaging.getToken();
    return token!;
  }

  Future<void> fireBaseMessageInit()async{
    NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onMessage.listen((message) async {
      // Mesajın body və title sahələrini əldə edin
      final title = message.notification?.title ?? "No Title";
      final body = message.notification?.body ?? "No Body";
      // Mesajın data hissəsindən Click_Action-u əldə edin
      var clickAction="";
      if (message.data.containsKey('click_action')) {
        clickAction = message.data['click_action'];
      }
      await NotyBackgroundTrack.showFireBaseNoty(
        body: body,
        title: title,
        id: 5,
        fln: flutterLocalNotificationsPlugin,
      );
      // "BLOCK" dəyərinə görə proqramı bağla
      if (clickAction == "Block") {
       // Proqramı bağla
        if (Platform.isAndroid) {
          SystemNavigator.pop(); // Android üçün
          messaging.deleteToken();
        } else if (Platform.isIOS) {
          exit(0); // iOS üçün (App Store-da tövsiyə edilmir)
        }
        return;
      }else if(clickAction == "Yenilik"){
        restartApplication();
      }
    });
  }
  void restartApplication() {
    Get.offAll(() => ScreenRequestCheckMobile()); // Bütün naviqasiyanı sıfırlayır və əsas səhifəni açır
  }
  Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
    final title = message.notification?.title ?? "No Title";
    final body = message.notification?.body ?? "No Body";
    // Mesajın data hissəsindən Click_Action-u əldə edin
    var clickAction = "";
    if (message.data.containsKey('click_action')) {
      clickAction = message.data['click_action'];
    }
    await NotyBackgroundTrack.showFireBaseNoty(
      body: body,
      title: title,
      id: 5,
      fln: flutterLocalNotificationsPlugin,
    );
    // "BLOCK" dəyərinə görə proqramı bağla
    if (clickAction == "Block") {
      // Proqramı bağla
      if (Platform.isAndroid) {
        SystemNavigator.pop(); // Android üçün
        messaging.deleteToken();
      } else if (Platform.isIOS) {
        exit(0); // iOS üçün (App Store-da tövsiyə edilmir)
      }
      return;
    }
    else if (clickAction == "Yenilik") {
      restartApplication();
    }
}


}
