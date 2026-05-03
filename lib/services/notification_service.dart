import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      // For Web, if Firebase isn't fully configured in index.html, 
      // accessing FirebaseMessaging.instance can throw errors.
      if (kIsWeb) {
        debugPrint("Skipping full Firebase Messaging init on Web for now...");
        return;
      }

      // 1. Initialize Firebase
      // await Firebase.initializeApp(); 

      // 2. Request Permissions
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // 3. Setup Local Notifications for Foreground
      const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
      await _localNotifications.initialize(initSettings);

      // 4. Listen for Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(message);
      });

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint("NotificationService: Firebase not initialized or not supported on this platform.");
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // await Firebase.initializeApp();
    debugPrint("Handling background message: ${message.messageId}");
  }

  static void _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  static Future<void> getTokenAndSave() async {
    if (kIsWeb) return; // FCM tokens on web require valid service worker / index.html setup
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final user = Session.currentUser;
      if (token != null && user != null) {
        await ApiService.saveFcmToken(user['email'], token);
        debugPrint("FCM Token Saved: $token");
      }
    } catch (e) {
      debugPrint("NotificationService: Could not retrieve FCM token.");
    }
  }
}
