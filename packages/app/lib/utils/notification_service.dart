import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:tedbook/model/notification_model.dart';
import 'package:tedbook/utils/utils.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'lock_screen_channel',
  'Lock Screen Notifications',
  description: 'This channel is used for important notifications',
  importance: Importance.max, // High priority
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

showNotification(
  RemoteMessage remoteMessage,
  BuildContext? context,
) async {
  String? title, description, id, bigText;
  bool isSilent = false;
  if (remoteMessage.notification != null) {
    final model =
        NotificationModel.fromJson(remoteMessage.notification!.toMap());
    title = model.title;
    description = model.body;
    Logger().w("title: $title\ndesc: $description");
  } else {
    if (Platform.isIOS || context == null) {
      return;
    }
    debugLog("} else { ");
    if (remoteMessage.notification?.title == null ||
        remoteMessage.notification?.body == null) {
      return;
    }
    debugLog("} else { 22");
    // final model = GeneralNotificationModel.fromJson(notificationMap);
    title = remoteMessage.notification?.title ?? "";
    description = remoteMessage.notification?.body ?? "";
  }
  await flutterLocalNotificationsPlugin.show(
    id != null
        ? (int.tryParse(id) ?? remoteMessage.hashCode)
        : remoteMessage.hashCode,
    title,
    description,
    NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          silent: false,
          onlyAlertOnce: true,
          showProgress: true,
          visibility: NotificationVisibility.public,
          priority: Priority.high,
          // High priority
          icon: "notification_icon",
          styleInformation: BigTextStyleInformation(bigText ?? ""),
        ),
        iOS: DarwinNotificationDetails(
            presentSound: !isSilent, subtitle: bigText)),
    payload: remoteMessage.toMap().toString(),
  );
}
