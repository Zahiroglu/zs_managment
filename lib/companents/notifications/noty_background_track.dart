import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotyBackgroundTrack{

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =  const AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize =  const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings );
  }

  static Future showBigTextNotification({var id =0,required String title, required String body, var payload, required FlutterLocalNotificationsPlugin fln
  } ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      ongoing: true,
      autoCancel: false,
      'you_can_name_it_whatever1',
      'channel_name',
      playSound: true,
      //sound:('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not= NotificationDetails(android: androidPlatformChannelSpecifics,
        iOS: IOSNotificationDetails(),
    );
    await fln.show(0, title, body,not );
  }

  static IOSNotificationDetails() {}

  static showBigTextNotificationUpdate({int id=1,required String title, required String body, required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_namenew',
      ongoing: false,
      autoCancel: false,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('navsound'),
      //sound:('notification'),
      importance: Importance.high,
      priority: Priority.high,
    );
    var not= NotificationDetails(android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );
    await fln.show(id, title, body,not );
  }
  static showFireBaseNoty({int id=2,required String title, required String body, required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_namenew',
      ongoing: false,
      autoCancel: false,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('navsound'),
      //sound:('notification'),
      importance: Importance.high,
      priority: Priority.high,
    );
    var not= NotificationDetails(android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );
    await fln.show(id, title, body,not );
  }



}

