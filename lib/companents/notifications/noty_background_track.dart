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



}

