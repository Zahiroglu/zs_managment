import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotyBackgroundTrack {
  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  static Future<void> showUncleanbleNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      ongoing: true,
      autoCancel: false,
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await fln.show(id, title, body, notificationDetails, payload: payload);
  }

  static Future<void> showBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      ongoing: true,
      autoCancel: false,
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await fln.show(id, title, body, notificationDetails, payload: payload);
  }

  static Future<void> showBigTextNotificationUpdate({
    int id = 1,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_namenew',
      ongoing: false,
      autoCancel: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarmsoundlocation'),
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await fln.show(id, title, body, notificationDetails);
  }

  static Future<void> showFireBaseNoty({
    int id = 2,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_namenew',
      ongoing: false,
      autoCancel: false,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('navsound'),
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await fln.show(id, title, body, notificationDetails);
  }
}
