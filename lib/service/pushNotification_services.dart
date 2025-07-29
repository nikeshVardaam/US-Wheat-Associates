import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static void showNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null) {
      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'default_channel', // channel ID
        'Default', // channel name
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformDetails,
      );
    }
  }
}
