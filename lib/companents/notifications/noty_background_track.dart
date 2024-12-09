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
      icon: '@mipmap/ic_launcher', // Burada düzgün ikon təyin edin
      playSound: false,
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await fln.show(id, title, body, notificationDetails, payload: payload);
  }

  static Future<void> showBigTextNotificationAlarm({
    int id = 1,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'you_can_name_it_whatever1', // Kanal ID
      'channel_namenew', // Kanal adı
      ongoing: true, // Bildiriş davamlıdır, istifadəçi tərəfindən bağlanmaz
      autoCancel: false, // Bildiriş avtomatik silinməz
      playSound: true, // Səs çalınsın
      sound: RawResourceAndroidNotificationSound('alarmsoundlocation'), // Səs faylı
      importance: Importance.high, // Yüksək əhəmiyyət
      priority: Priority.high, // Yüksək prioritet
      icon: '@mipmap/ic_launcher', // Kiçik ikon
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    // Bildirişi göstərmək
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
