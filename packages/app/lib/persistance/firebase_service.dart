import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:tedbook/firebase_options.dart';
import 'package:tedbook/utils/notification_service.dart';

class FirebaseService {
  firebaseInit() async {
    FirebaseMessaging.instance.requestPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String> getToken() async {
    try {
      var token = await FirebaseMessaging.instance.getToken();
      if (token?.isNotEmpty == true) {
        return token!;
      }
    } catch (e) {
      Logger().e("Error getting FCM token: $e");
    }
    return "";
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Logger().w("FCM background ${message.data}");
    await showNotification(message, null);
  }
}
