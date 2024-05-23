import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    print("Fire token :"+token.toString());
    return token!;
  }

  void fireBaseMessageInit(){
    NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onMessage.listen((messaje) async {
      print("Messaje title :"+messaje.notification!.title.toString());
      print("Messaje body :"+messaje.notification!.body.toString());
    await NotyBackgroundTrack.showFireBaseNoty(body: messaje.notification!.body.toString(),fln: flutterLocalNotificationsPlugin,title: messaje.notification!.title.toString(),id: 2);
    });

  }

}
