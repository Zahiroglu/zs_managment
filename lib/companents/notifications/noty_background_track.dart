import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotyBackgroundTrack {
  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static NotificationDetails _buildNotificationDetails({
    required AndroidNotificationDetails androidDetails,
  }) {
    return NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
    );
  }

  static Future<void> showUncleanbleNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'uncleanable_channel',
      'Uncleanable Notifications',
      ongoing: true,
      autoCancel: false,
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = _buildNotificationDetails(androidDetails: androidDetails);
    await fln.show(id, title, body, notificationDetails, payload: payload);
  }

  static Future<void> showBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'bigtext_channel',
      'Big Text Notifications',
      ongoing: true,
      autoCancel: false,
      icon: '@mipmap/ic_launcher',
      playSound: false,
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = _buildNotificationDetails(androidDetails: androidDetails);
    await fln.show(id, title, body, notificationDetails, payload: payload);
  }

  static Future<void> showBigTextNotificationAlarm({
    int id = 1,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      ongoing: true,
      autoCancel: false,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarmsoundlocation'),
      icon: '@mipmap/ic_launcher',
    );

    final notificationDetails = _buildNotificationDetails(androidDetails: androidDetails);
    await fln.show(id, title, body, notificationDetails);
  }

  static Future<void> showFireBaseNoty({
    int id = 2,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'firebase_channel',
      'Firebase Notifications',
      ongoing: false,
      autoCancel: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('navsound'),
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = _buildNotificationDetails(androidDetails: androidDetails);
    await fln.show(id, title, body, notificationDetails);
  }
}
